module VotesActions
  extend ActiveSupport::Concern

  included do
    before_action :set_item, only: [:upvote, :downvote, :clearvote]
  end

  def upvote
    if current_user.author_of?(@item)
      render json: { score: @item.votescore, notice: "You can not vote for your own #{@item_class.to_s.downcase}" }
    elsif @item.upvoted?(current_user)
      render json: { score: @item.votescore, notice: "You have already voted for this #{@item_class.to_s.downcase}" }
    else
      @item.upvote(current_user)
      render json: { score: @item.votescore, notice: "You have voted for this #{@item_class.to_s.downcase}" }
    end
  end

  def downvote
    if current_user.author_of?(@item)
      render json: { score: @item.votescore, notice: "You can not vote against your own #{@item_class.to_s.downcase}" }
    elsif @item.downvoted?(current_user)
      render json: { score: @item.votescore, notice: "You have already voted against this #{@item_class.to_s.downcase}" }
    else
      @item.downvote(current_user)
      render json: { score: @item.votescore, notice: "You have voted against this #{@item_class.to_s.downcase}" }
    end
  end

  def clearvote
    if current_user.author_of?(@item)
      render json: { score: @item.votescore, notice: "You can not clear votes for your own #{@item_class.to_s.downcase}" }
    elsif !@item.upvoted?(current_user) && !@item.downvoted?(current_user)
      render json: { score: @item.votescore, notice: "You have not voted for this #{@item_class.to_s.downcase}" }
    else
      @item.clearvote(current_user)
      render json: { score: @item.votescore, notice: "You have cleared your vote for this #{@item_class.to_s.downcase}" }
    end
  end

  private

  def set_item
    @item_class = controller_name.classify.constantize
    @item = @item_class.find(params[:id])
  end
end