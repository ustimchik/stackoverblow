require 'rails_helper'

describe 'Profile API', type: :request do
  let(:headers) { {"CONTENT_TYPE" => 'application/json',
                   "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/profiles/me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: '3wqe2132r3' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/', headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/', params: { access_token: '3wqe2132r3' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:other_users) { create_list(:user, 2) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of all users with public attributes' do
        other_users.each do |user|
          %w[id email admin created_at updated_at].each do |attr|
            json['users'].each do |user_response|
              expect(user_response[attr]).to eq user.send(attr).as_json
            end
          end
        end
      end

      it 'does not return private attributes' do
        %w[password encrypted_password].each do |attr|
          json['users'].each do |user_response|
            expect(user_response).to_not have_key(attr)
          end
        end
      end

      it 'does not return current user' do
        json['users'].each do |user_response|
          expect(user_response).to_not have_key(me)
        end
      end
    end
  end
end