shared_examples_for 'Voteable Controller' do

  let!(:other_user) { create(:user) }

  describe '#POST upvote' do

    context 'user is NOT authorized' do
      before { post :upvote, params: { id: voteable_item } }
      it 'renders not authorized error' do
        expect(response.status).to eq(302);
      end
    end
    context 'user authorized' do
      context 'and is the author of item' do
        before do
          login(user)
          post :upvote, params: { id: voteable_item }
        end

        it 'renders json with total vote score unchanged' do
          expect(JSON.parse(response.body)["score"]).to eq(0)
        end

        it 'renders json with proper notice' do
          expect(JSON.parse(response.body)["notice"]).to include("You can not vote for your own")
        end
      end
      context 'and is NOT the author of item' do
        before do
          login(other_user)
          post :upvote, params: { id: voteable_item }
        end

        context 'upvoting item for the first time' do
          it 'renders json with total vote score +1' do
            expect(JSON.parse(response.body)["score"]).to eq(1)
          end

          it 'renders json with proper notice' do
            expect(JSON.parse(response.body)["notice"]).to include("You have voted for this")
          end
        end
        context 'upvoting item when already upvoted' do
          before { post :upvote, params: { id: voteable_item } }

          it 'renders json with total vote score unchanged' do
            expect(JSON.parse(response.body)["score"]).to eq(1)
          end

          it 'renders json with proper notice' do
            expect(JSON.parse(response.body)["notice"]).to include("You have already voted")
          end
        end
      end
    end
  end

  describe '#POST downvote' do

    context 'user is NOT authorized' do
      before { post :downvote, params: { id: voteable_item } }
      it 'renders not authorized error' do
        expect(response.status).to eq(302);
      end
    end
    context 'user authorized' do
      context 'and is the author of item' do
        before do
          login(user)
          post :downvote, params: { id: voteable_item }
        end

        it 'renders json with total vote score unchanged' do
          expect(JSON.parse(response.body)["score"]).to eq(0)
        end

        it 'renders json with proper notice' do
          expect(JSON.parse(response.body)["notice"]).to include("You can not vote against your own")
        end
      end
      context 'and is NOT the author of item' do
        before do
          login(other_user)
          post :downvote, params: { id: voteable_item }
        end

        context 'downvoting item for the first time' do
          it 'renders json with total vote score -1' do
            expect(JSON.parse(response.body)["score"]).to eq(-1)
          end

          it 'renders json with proper notice' do
            expect(JSON.parse(response.body)["notice"]).to include("You have voted against this")
          end
        end
        context 'downvoting item when already upvoted' do
          before { post :downvote, params: { id: voteable_item } }

          it 'renders json with total vote score unchanged' do
            expect(JSON.parse(response.body)["score"]).to eq(-1)
          end

          it 'renders json with proper notice' do
            expect(JSON.parse(response.body)["notice"]).to include("You have already voted")
          end
        end
      end
    end
  end

  describe '#POST clearvote' do
    before do
      login(other_user)
      post :upvote, params: { id: voteable_item }
      logout(other_user)
    end

    context 'user is NOT authorized' do
      before { post :clearvote, params: { id: voteable_item } }
      it 'renders not authorized error' do
        expect(response.status).to eq(302);
      end
    end
    context 'user authorized' do
      context 'and is the author of item' do
        before do
          login(user)
          post :clearvote, params: { id: voteable_item }
        end

        it 'renders json with total vote score unchanged' do
          expect(JSON.parse(response.body)["score"]).to eq(1)
        end

        it 'renders json with proper notice' do
          expect(JSON.parse(response.body)["notice"]).to include("You can not clear votes for your own")
        end
      end
      context 'and is NOT the author of item' do
        before do
          login(other_user)
          post :clearvote, params: { id: voteable_item }
        end

        context 'clearing item vote' do
          it 'renders json with total vote score 0' do
            expect(JSON.parse(response.body)["score"]).to eq(0)
          end

          it 'renders json with proper notice' do
            expect(JSON.parse(response.body)["notice"]).to include("You have cleared your vote for this")
          end
        end
      end
    end
  end
end