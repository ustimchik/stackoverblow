require 'rails_helper'

RSpec.describe Services::FindForOauth do

  describe '.call' do
    let!(:user) { create (:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    subject { Services::FindForOauth.new(auth) }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'github', uid: '123456')
        expect(subject.call).to eq user
      end
    end

    context 'user does not have authorization' do

      context 'email NOT passed in arguments' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: nil } ) }

        it 'does not create a new user' do
          expect { subject.call }.to_not change(User, :count)
        end

        it 'does not create authorization' do
          expect { subject.call }.to_not change(Authorization, :count)
        end

        it 'returns nil' do
          expect(subject.call).to be_nil
        end
      end

      context 'email passed in arguments' do

        context 'email exists in database' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email } ) }

          it 'does not create a new user' do
            expect { subject.call }.to_not change(User, :count)
          end

          it 'creates authorizaton for existing user' do
            expect { subject.call }.to change(user.authorizations, :count).by(1)
          end

          it 'creates authorization with provider and uid' do
            authorization = subject.call.authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it 'returns user' do
            expect(subject.call).to eq user
          end
        end

        context 'email does not exist in database' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'another_user@test.com' } ) }

          it 'creates a new user' do
            expect { subject.call }.to change(User, :count).by(1)
          end

          it 'creates user with email' do
            user_new = subject.call
            expect(user_new.email).to eq 'another_user@test.com'
          end

          it 'creates authorizaton for a new user' do
            user_new = subject.call
            expect(user_new.authorizations).to_not be_empty
          end

          it 'creates authorization with provider and uid' do
            authorization = subject.call.authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it 'returns new user' do
            expect(subject.call).to be_a(User)
          end

          context 'needing confirmation (email got from user)' do
            it 'creates user NOT requiring confirmation' do
              expect(subject.call.confirmed?).to be_truthy
            end
          end

          context 'NOT needing confirmation (email got from trusted OAUTH provider)' do
            let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'another_user@test.com', need_confirmation: true } ) }

            it 'creates user requiring confirmation' do
              expect(subject.call.confirmed?).to be_falsey
            end
          end
        end
      end
    end
  end
end
