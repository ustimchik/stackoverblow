require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { {"CONTENT_TYPE" => 'application/json',
                   "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'UnauthorizedApi'

    def api_call( flex_params = {} )
      get '/api/v1/questions', params: flex_params, headers: headers
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
    end
  end

  describe 'GET /api/v1/questions/question_id' do
    let!(:question) { create(:question, :with_attachment) }

    it_behaves_like 'UnauthorizedApi'

    def api_call( flex_params = {} )
      get "/api/v1/questions/#{question.id}", params: flex_params, headers: headers
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

    it_behaves_like 'UnauthorizedApi'

    def api_call( flex_params = {} )
      post '/api/v1/questions/', params: {headers: headers}.merge(question_params).merge(flex_params)
    end

    context 'authorized' do

      context 'with no errors' do
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

      context 'with errors' do
        let(:access_token) { create(:access_token) }
        let(:question_params) { {title: "", body: ""} }

        before { post '/api/v1/questions/', params: { question: question_params, headers: headers, access_token: access_token.token} }

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end

        it 'returns error' do
          expect(json).to have_key('error')
        end

        it 'does not add a new record to Question table' do
          expect{post '/api/v1/questions/', params: { question: question_params, headers: headers, access_token: access_token.token} }.to_not change{Question.count}
        end
      end

    end
  end

  describe 'PATCH /api/v1/questions/question_id' do
    let!(:question) { create(:question) }
    let(:question_params) { {title: "WHY?", body: "ON EARTH", links_attributes: {randkey: {name: "ya", url: "https://ya.ru"}}} }

    it_behaves_like 'UnauthorizedApi'

    def api_call( flex_params = {} )
      patch "/api/v1/questions/#{question.id}", params: {headers: headers}.merge(question_params).merge(flex_params)
    end

    context 'authorized' do

      context 'as resource owner' do
        let(:user) {create :user}
        let!(:question) {create :question, user: user}
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }

        context 'with no errors' do
          before { patch "/api/v1/questions/#{question.id}", params: { question: question_params, headers: headers, access_token: access_token.token} }

          it 'returns OK status' do
            expect(response).to be_successful
          end

          it 'is able to get the updated record by id with the new values' do
            get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, headers: headers }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)['question']['title']).to eq "WHY?"
            expect(JSON.parse(response.body)['question']['body']).to eq "ON EARTH"
          end
        end

        context 'with errors' do
          let(:question_params) { {title: "", body: ""} }

          before { patch "/api/v1/questions/#{question.id}", params: { question: question_params, headers: headers, access_token: access_token.token} }

          it 'returns failed status' do
            expect(response).to_not be_successful
          end

          it 'does not save the new values to a record' do
            get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, headers: headers }
            expect(JSON.parse(response.body)['question']['title']).to_not eq ""
            expect(JSON.parse(response.body)['question']['body']).to_not eq ""
          end
        end
      end

      context 'as NOT resource owner' do
        let(:access_token) { create(:access_token) }

        before { patch "/api/v1/questions/#{question.id}", params: { question: question_params, headers: headers, access_token: access_token.token} }

        it 'returns failed status' do
          expect(response).to_not be_successful
        end

        it 'is not getting updated values from the record' do
          get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, headers: headers }
          expect(JSON.parse(response.body)['question']['title']).to_not eq "WHY?"
          expect(JSON.parse(response.body)['question']['body']).to_not eq "ON EARTH"
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/question_id' do
    let!(:question) { create(:question) }

    it_behaves_like 'UnauthorizedApi'

    def api_call( flex_params = {} )
      delete "/api/v1/questions/#{question.id}", params: {headers: headers}.merge(flex_params)
    end

    context 'authorized' do
      context 'as resource owner' do
        let(:user) {create :user}
        let!(:question) {create :question, user: user}
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }

        before { delete "/api/v1/questions/#{question.id}", params: { headers: headers, access_token: access_token.token} }

        it 'returns OK status' do
          expect(response).to be_successful
        end

        it 'is NOT able to get the record by id after delete' do
          get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, headers: headers }
          expect(response).to_not be_successful
        end
      end

      context 'as NOT resource owner' do
        let(:access_token) { create(:access_token) }

        before { delete "/api/v1/questions/#{question.id}", params: { headers: headers, access_token: access_token.token} }

        it 'returns failed status' do
          expect(response).to_not be_successful
        end

        it 'is able to get the record by id after trying to delete' do
          get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, headers: headers }
          expect(response).to be_successful
        end
      end
    end
  end

end