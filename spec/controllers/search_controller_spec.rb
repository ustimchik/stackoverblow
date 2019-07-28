require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:query) { "test" }
  let(:categories) { %w[All Question Answer Comment User] }
  let(:wrong_category) { 123 }
  let(:service) { Services::Search.new }

  describe 'GET #new' do

    before do
      request.env["HTTP_REFERER"] = "/questions"
    end

    context 'query param passed' do

      context 'category correct' do
        it 'calls Services::Search with params' do
          categories.each do |category|
            allow(Services::Search).to receive(:new).and_return(service)
            expect(service).to receive(:perform).with(query, category)
            get :new, params: { query: query, category: category }
          end
        end

        it 'renders search/results' do
          categories.each do |category|
            expect(get :new, params: { category: category, query: query }).to render_template 'search/results'
          end
        end
      end

      context 'category wrong' do

        it 'calls Services::Search' do
          expect(Services::Search).to receive(:new).and_call_original
          get :new, params: { category: wrong_category, query: query }
        end

        it 'redirects back to http/referer' do
          expect(get :new, params: { category: wrong_category, query: query }).to redirect_to '/questions'
        end
      end

      context 'category empty' do

        it 'calls Services::Search' do
          expect(Services::Search).to receive(:new).and_call_original
          get :new, params: { category: nil, query: query }
        end

        it 'redirects back to http/referer' do
          expect(get :new, params: { category: nil, query: query }).to redirect_to '/questions'
        end
      end

      context 'query empty' do

        it 'calls Services::Search' do
          categories.each do |category|
            expect(Services::Search).to receive(:new).and_call_original
            get :new, params: { category: category, query: "" }
          end
        end

        it 'redirects back to http/referer' do
          categories.each do |category|
            expect(get :new, params: { category: category, query: "" }).to redirect_to '/questions'
          end
        end
      end
    end

    context 'query param not passed' do

      it 'calls Services::Search' do
        categories.each do |category|
          expect(Services::Search).to receive(:new).and_call_original
          get :new, params: { category: category }
        end
      end

      it 'redirects back to http/referer' do
        categories.each do |category|
          expect(get :new, params: { category: category }).to redirect_to '/questions'
        end
      end
    end
  end
end