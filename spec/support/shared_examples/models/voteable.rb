shared_examples_for 'Voteable Model' do

  let!(:user) { create(:user) }

  describe 'upvote' do
    context 'vote does not exist' do
      it 'should increment number of records in Votes' do
        expect { voteable_item.upvote(user) }.to change(Vote, :count).by(1)
      end
      it 'should set vote score for an item' do
        voteable_item.upvote(user)
        expect(voteable_item.votes.sum(:score)).to eq(1)
      end
    end
    context 'upvote exists' do
      let!(:vote) { create(:vote, score: 1, user: user, voteable: voteable_item) }

      it 'should NOT increment number of records in Votes' do
        expect { voteable_item.upvote(user) }.to_not change(Vote, :count)
      end
      it 'should set vote score for an item' do
        voteable_item.upvote(user)
        expect(voteable_item.votes.sum(:score)).to eq(1)
      end
    end
    context 'downvote exists' do
      let!(:vote) { create(:vote, score: -1, user: user, voteable: voteable_item) }

      it 'should NOT increment number of records in Votes' do
        expect { voteable_item.upvote(user) }.to_not change(Vote, :count)
      end
      it 'should set vote score for an item' do
        voteable_item.upvote(user)
        expect(voteable_item.votes.sum(:score)).to eq(1)
      end
    end
  end

  describe 'downvote' do
    context 'vote does not exist' do
      it 'should increment number of records in Votes' do
        expect { voteable_item.downvote(user) }.to change(Vote, :count).by(1)
      end
      it 'should set vote score for an item' do
        voteable_item.downvote(user)
        expect(voteable_item.votes.sum(:score)).to eq(-1)
      end
    end
    context 'upvote exists' do
      let!(:vote) { create(:vote, score: 1, user: user, voteable: voteable_item) }

      it 'should NOT increment number of records in Votes' do
        expect { voteable_item.downvote(user) }.to_not change(Vote, :count)
      end
      it 'should set vote score for an item' do
        voteable_item.downvote(user)
        expect(voteable_item.votes.sum(:score)).to eq(-1)
      end
    end
    context 'downvote exists' do
      let!(:vote) { create(:vote, score: -1, user: user, voteable: voteable_item) }

      it 'should NOT increment number of records in Votes' do
        expect { voteable_item.downvote(user) }.to_not change(Vote, :count)
      end
      it 'should set vote score for an item' do
        voteable_item.downvote(user)
        expect(voteable_item.votes.sum(:score)).to eq(-1)
      end
    end
  end

  describe 'clearvote' do
    context 'vote does not exist' do
      it 'should increment number of records in Votes' do
        expect { voteable_item.clearvote(user) }.to change(Vote, :count).by(1)
      end
      it 'should set vote score for an item to 0' do
        voteable_item.clearvote(user)
        expect(voteable_item.votes.sum(:score)).to eq(0)
      end
    end
    context 'upvote exists' do
      let!(:vote) { create(:vote, score: 1, user: user, voteable: voteable_item) }

      it 'should NOT increment number of records in Votes' do
        expect { voteable_item.clearvote(user) }.to_not change(Vote, :count)
      end
      it 'should set vote score for an item' do
        voteable_item.clearvote(user)
        expect(voteable_item.votes.sum(:score)).to eq(0)
      end
    end
    context 'downvote exists' do
      let!(:vote) { create(:vote, score: -1, user: user, voteable: voteable_item) }

      it 'should NOT increment number of records in Votes' do
        expect { voteable_item.clearvote(user) }.to_not change(Vote, :count)
      end
      it 'should set vote score for an item' do
        voteable_item.clearvote(user)
        expect(voteable_item.votes.sum(:score)).to eq(0)
      end
    end
  end

  describe 'votescore' do
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }

    context 'upvoting only' do
      it 'returns proper vote score' do
        voteable_item.upvote(user)
        voteable_item.upvote(user2)
        voteable_item.upvote(user3)
        expect(voteable_item.votescore).to eq(3)
      end
    end
    context 'downvoting only' do
      it 'returns proper vote score' do
        voteable_item.downvote(user)
        voteable_item.downvote(user2)
        voteable_item.downvote(user3)
        expect(voteable_item.votescore).to eq(-3)
      end
    end
    context 'mixed votes' do
      it 'returns proper vote score' do
        voteable_item.upvote(user)
        voteable_item.upvote(user2)
        voteable_item.downvote(user3)
        expect(voteable_item.votescore).to eq(1)
      end
    end
  end

  describe  'voted?' do
    it 'returns true if user vote record exists' do
      voteable_item.upvote(user)
      expect(voteable_item.voted?(user)).to be_truthy
    end
    it 'returns false if user did not vote for this item' do
      expect(voteable_item.voted?(user)).to be_falsey
    end
  end

  describe  'upvoted?' do
    it 'returns true if user voted 1' do
      voteable_item.upvote(user)
      expect(voteable_item.upvoted?(user)).to be_truthy
    end
    it 'returns false if user not voted' do
      expect(voteable_item.upvoted?(user)).to be_falsey
    end
    it 'returns false if user downvoted' do
      voteable_item.downvote(user)
      expect(voteable_item.upvoted?(user)).to be_falsey
    end
    it 'returns false if user upvoted and cleared' do
      voteable_item.upvote(user)
      voteable_item.clearvote(user)
      expect(voteable_item.upvoted?(user)).to be_falsey
    end
  end

  describe  'downvoted?' do
    it 'returns true if user voted -1' do
      voteable_item.downvote(user)
      expect(voteable_item.downvoted?(user)).to be_truthy
    end
    it 'returns false if user not voted' do
      expect(voteable_item.downvoted?(user)).to be_falsey
    end
    it 'returns false if user upvoted' do
      voteable_item.upvote(user)
      expect(voteable_item.downvoted?(user)).to be_falsey
    end
    it 'returns false if user downvoted and cleared' do
      voteable_item.downvote(user)
      voteable_item.clearvote(user)
      expect(voteable_item.downvoted?(user)).to be_falsey
    end
  end

end