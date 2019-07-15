require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { {"CONTENT_TYPE" => 'application/json',
                   "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/answers/answer_id' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, :with_attachment, question: question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { access_token: '3wqe2132r3' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 3, commentable: answer) }
      let!(:links) { create_list(:link, 4, linkable: answer) }
      let(:answer_response) { json['answer'] }

      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end

      it 'contains question object' do
        expect(answer_response['question']['id']).to eq question.id
      end

      describe 'comments' do
        let!(:comment) { comments.first }
        let(:comment_response) { answer_response['comments'].first }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let!(:link) { links.first }
        let(:link_response) { answer_response['links'].first }

        it 'returns list of links' do
          expect(answer_response['links'].size).to eq 4
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at gist].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let!(:file) { answer.files.first }
        let(:file_response) { answer_response['files'].first }

        it 'returns list of files' do
          expect(answer_response['files'].size).to eq 1
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
end