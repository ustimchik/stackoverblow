shared_examples_for 'UnauthorizedApi' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      api_call
      expect(response.status).to eq 401
    end
    it 'returns 401 status if access_token is invalid' do
      api_call(access_token: 'fake123456')
      expect(response.status).to eq 401
    end
  end
end