# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Breweries API', type: :request do
  let(:user) { create(:user) }
  let!(:brewery) { create(:brewery) }
  let(:brewery_id) { brewery.id }
  let(:headers) { valid_headers }

  describe 'GET /breweries' do
    before { get '/breweries', params: {}, headers: headers }

    it 'returns breweries' do
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /breweries/:id' do
    before { get "/breweries/#{brewery_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the brewery' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(brewery_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:brewery_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Brewery/)
      end
    end
  end

  describe 'POST /breweries' do
    let(:valid_attributes) { { name: 'Awesome Brewery' }.to_json }

    context 'when the request is valid' do
      before { post '/breweries', params: valid_attributes, headers: headers }

      it 'creates a todo' do
        expect(json['name']).to eq('Awesome Brewery')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/breweries', params: { name: '' }.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PUT /breweries/:id' do
    let(:valid_attributes) { { name: 'Another Brewery' }.to_json }

    context 'when the record exists' do
      before { put "/breweries/#{brewery_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /breweries/:id' do
    before { delete "/breweries/#{brewery_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
