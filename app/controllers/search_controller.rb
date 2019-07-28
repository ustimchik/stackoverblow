class SearchController < ApplicationController

  skip_authorization_check

  def new
    @results = Services::Search.new.perform(params[:query], params[:category])&.page(params[:page])
    if @results
      render 'search/results'
    else
      redirect_back fallback_location: @questions, alert: 'The search query is empty or wrong category'
    end
  end
end