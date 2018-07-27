# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Breweries API", type: :request do
  let!(:breweries) { create_list(:brewery, 25) }
  let(:brewery_id) { breweries.first.id }

  describe "GET /breweries" do
    context "when no params are passed" do
      before { get "/breweries" }

      it "returns breweries" do
        expect(json).not_to be_empty
        expect(json.size).to eq(20)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

      it "returns Cache-Control headers" do
        expect(response.headers["Cache-Control"]).to eq(
          "max-age=86400, public"
        )
      end
    end

    context "when page params are passed" do
      before { get "/breweries", params: { page: 2 } }

      it "returns an offset of breweries" do
        expect(json.size).to eq(5)
      end
    end
  end

  describe "GET /breweries/:id" do
    before { get "/breweries/#{brewery_id}" }

    context "when the record exists" do
      it "returns the brewery" do
        expect(json).not_to be_empty
        expect(json["id"]).to eq(brewery_id)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the record does not exist" do
      let(:brewery_id) { 100 }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Brewery/)
      end
    end
  end

  describe "POST /breweries" do
    let(:valid_attributes) { { name: "Awesome Brewery" } }

    context "when the request is valid" do
      before { post "/breweries", params: valid_attributes }

      it "creates a todo" do
        expect(json["name"]).to eq("Awesome Brewery")
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request is invalid" do
      before { post "/breweries", params: { name: "" } }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end

      it "returns a validation failure message" do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe "PUT /breweries/:id" do
    let(:valid_attributes) { { name: "Another Brewery" } }

    context "when the record exists" do
      before { put "/breweries/#{brewery_id}", params: valid_attributes }

      it "updates the record" do
        expect(response.body).to be_empty
      end

      it "returns status code 204" do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe "DELETE /breweries/:id" do
    before { delete "/breweries/#{brewery_id}" }

    it "returns status code 204" do
      expect(response).to have_http_status(204)
    end
  end
end
