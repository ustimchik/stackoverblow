require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { {"CONTENT_TYPE" => 'application/json',
                   "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/questions' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '3wqe2132r3' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq questions.first.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/question_id' do
    let!(:question) { create(:question, :with_attachment) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { access_token: '3wqe2132r3' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 4, linkable: question) }
      let(:question_response) { json['question'] }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      describe 'answers' do
        let!(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let!(:comment) { comments.first }
        let(:comment_response) { question_response['comments'].first }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let!(:link) { links.first }
        let(:link_response) { question_response['links'].first }

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 4
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at gist].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let!(:file) { question.files.first }
        let(:file_response) { question_response['files'].first }

        it 'returns list of files' do
          expect(question_response['files'].size).to eq 1
        end

        it 'returns filename' do
          expect(file_response['filename']).to eq file.send(:filename).as_json
        end

        it 'returns URL' do
          expect(file_response['url']).to eq Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:question_params) { {title: "WHY?", body: "ON EARTH", links_attributes: {randkey: {name: "ya", url: "https://ya.ru"}}} }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions", params: { question: question_params, headers: headers }
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions", params: { question: question_params, headers: headers, access_token: '123213214'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { post '/api/v1/questions/', params: { question: question_params, headers: headers, access_token: access_token.token} }

      it 'returns 201 status' do
        expect(response.status).to eq 201
      end

      it 'returns question ID' do
        expect(json).to have_key('question_id')
      end

      it 'adds a new record to Question table' do
        expect{post '/api/v1/questions/', params: { question: question_params, headers: headers, access_token: access_token.token} }.to change{Question.count}.by(1)
      end

      it 'is able to get the new record by id with proper values' do
        get "/api/v1/questions/#{(json)['question_id']}", params: { access_token: access_token.token, headers: headers }
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['question']['title']).to eq "WHY?"
        expect(JSON.parse(response.body)['question']['body']).to eq "ON EARTH"
      end
    end
  end

  describe 'PATCH /api/v1/questions/question_id' do
    let!(:question) { create(:question) }
    let(:question_params) { {title: "WHY?", body: "ON EARTH", links_attributes: {randkey: {name: "ya", url: "https://ya.ru"}}} }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        patch "/api/v1/questions/#{question.id}", params: { question: question_params, headers: headers }
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        patch "/api/v1/questions/#{question.id}", params: { question: question_params, headers: headers, access_token: '123213214'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { patch "/api/v1/questions/#{question.id}", params: { question: question_params, headers: headers, access_token: access_token.token} }

      it 'returns OK status' do
        expect(response).to be_successful
      end

      it 'is able to get the new record by id with the new values' do
        get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, headers: headers }
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['question']['title']).to eq "WHY?"
        expect(JSON.parse(response.body)['question']['body']).to eq "ON EARTH"
      end
    end
  end

  describe 'DELETE /api/v1/questions/question_id' do
    let!(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        delete "/api/v1/questions/#{question.id}", params: { headers: headers }
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        delete "/api/v1/questions/#{question.id}", params: { headers: headers, access_token: '123213214'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { delete "/api/v1/questions/#{question.id}", params: { headers: headers, access_token: access_token.token} }

      it 'returns OK status' do
        expect(response).to be_successful
      end

      it 'is NOT able to get the new record by id' do
        get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, headers: headers }
        expect(response).to_not be_successful
      end
    end
  end

end