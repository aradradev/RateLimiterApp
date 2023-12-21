require 'rails_helper'

RSpec.describe 'ApiControllers', type: :request do
  describe 'GET #limited' do
    it 'returns a success response' do
      get '/limited'
      expect(response).to have_http_status(:success)
    end

    it 'returns a rate limit exceeded response' do
      allow_any_instance_of(ApiController).to receive(:rate_limit) do
        render json: { error: 'Rate limit exceeded' }, status: :too_many_requests
      end

      get '/limited'
      expect(response).to have_http_status(:too_many_requests)
      expect(JSON.parse(response.body)['error']).to eq('Rate limit exceeded')
    end
  end
end
