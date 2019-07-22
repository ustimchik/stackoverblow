require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  describe 'POST #create' do
    let (:user) { create(:user) }
    let (:question) { create(:question) }
    let(:subscribe) { post :create, params: { question_id: question, subscription: attributes_for(:subscription)}, format: :js }

    context 'authorized' do
      before { login(user) }

      context 'subscription does not exist yet' do
        it 'increments the number of records in Subscription table' do
          expect{(subscribe)}.to change(Subscription, :count).by(1)
        end

        it 'associates new subscription with the given question' do
          expect{(subscribe)}.to change(question.subscriptions, :count).by(1)
        end

        it 'associates new subscription with the given user' do
          expect{(subscribe)}.to change(user.subscriptions, :count).by(1)
        end

        it 'renders create template' do
          expect(subscribe).to render_template :create
        end
      end

      context 'subscription already exists' do
        let!(:subscription) { create(:subscription, user: user, question: question) }

        it 'does not change the number of records in Subscription table' do
          expect{(subscribe)}.to_not change(Subscription, :count)
        end
        it 'does not change the number of associated subscriptions for a given user' do
          expect{(subscribe)}.to_not change(user.subscriptions, :count)
        end
        it 'does not change the number of associated subscriptions for a given question' do
          expect{(subscribe)}.to_not change(question.subscriptions, :count)
        end
        it 'renders create template' do
          expect(subscribe).to render_template :create
        end
      end
    end

    context 'NOT authorized' do
      it 'does not change the number of records in Subscription table' do
        expect{(subscribe)}.to_not change(Subscription, :count)
      end
      it 'does not change the number of associated subscriptions for a given user' do
        expect{(subscribe)}.to_not change(user.subscriptions, :count)
      end
      it 'does not change the number of associated subscriptions for a given question' do
        expect{(subscribe)}.to_not change(question.subscriptions, :count)
      end
      it 'does not render create template' do
        expect(subscribe).to_not render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let (:user) { create(:user) }
    let (:other_user) { create(:user) }
    let (:question) { create(:question) }
    let!(:subscription) { create(:subscription, user: user, question: question) }
    let (:unsubscribe) { delete :destroy, params: { id: subscription, format: :js } }

    context 'authorized' do

      context 'as subscription owner' do
        before { login(user) }

        it 'decrements the number of records in Subscription table' do
          expect{(unsubscribe)}.to change(Subscription, :count).by(-1)
        end
        it 'removes the association of a subscription with the given user' do
          expect{(unsubscribe)}.to change(user.subscriptions, :count).by(-1)
        end
        it 'removes the association of a subscription with the given question' do
          expect{(unsubscribe)}.to change(question.subscriptions, :count).by(-1)
        end
        it 'renders destroy template' do
          expect(unsubscribe).to render_template :destroy
        end
      end

      context 'as NOT subscription owner' do
        before { login(other_user) }

        it 'does not change the number of records in Subscription table' do
          expect{(unsubscribe)}.to_not change(Subscription, :count)
        end
        it 'does not change the subscription associated with the given user' do
          expect{(unsubscribe)}.to_not change(user.subscriptions, :count)
        end
        it 'does not change the subscriptions associated with the given question' do
          expect{(unsubscribe)}.to_not change(question.subscriptions, :count)
        end
        it 'renders destroy template' do
          expect(unsubscribe).to render_template :destroy
        end
      end
    end

    context 'NOT authorized' do
      it 'does not change the number of records in Subscription table' do
        expect{(unsubscribe)}.to_not change(Subscription, :count)
      end
      it 'does not change the subscription associated with the given user' do
        expect{(unsubscribe)}.to_not change(user.subscriptions, :count)
      end
      it 'does not change the subscriptions associated with the given question' do
        expect{(unsubscribe)}.to_not change(question.subscriptions, :count)
      end
      it 'does not render destroy template' do
        expect(unsubscribe).to_not render_template :destroy
      end
    end
  end
end