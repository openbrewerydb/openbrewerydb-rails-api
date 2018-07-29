# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Breweries API", type: :request do
  describe "GET /breweries" do
    context "when no params are passed" do
      before do
        create_list(:brewery, 25)
        get "/breweries"
      end

      # NB: Set in /config/initializers/kaminari_config.rb
      it "returns the default number of breweries" do
        expect(json).not_to be_empty
        expect(json.size).to eq(20)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns Cache-Control headers" do
        expect(response.headers["Cache-Control"]).to eq(
          "max-age=86400, public"
        )
      end
    end

    context "when invalid params are passed" do
      before do
        create_list(:brewery, 25)
        get "/breweries", params: { page: "invalid", sort: "*bob" }
      end

      it "returns a status of 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the default number of breweries" do
        expect(json).not_to be_empty
        expect(json.size).to eq(20)
      end
    end

    context "when page param is passed" do
      before do
        create_list(:brewery, 25)
        get "/breweries", params: { page: 2 }
      end

      it "returns another page of breweries" do
        expect(json.size).to eq(5)
      end
    end

    context "when limit param is passed" do
      before do
        create_list(:brewery, 55)
      end

      it "returns a limited number breweries" do
        get "/breweries", params: { limit: 5 }
        expect(json.size).to eq(5)
      end

      # NB: Set in /config/initializers/kaminari_config.rb
      it "does not exceed the maximum number of breweries" do
        get "/breweries", params: { limit: 55 }
        expect(json.size).to eq(50)
      end
    end

    context "when by_city param is passed" do
      before do
        create_list(:brewery, 8)
        create_list(:brewery, 2, city: "San Diego")
        get "/breweries", params: { by_city: "san Diego" }
      end

      it "returns a filtered list of breweries" do
        expect(json.size).to eq(2)
      end
    end

    context "when by_name param is passed" do
      before do
        create_list(:brewery, 8)
        create_list(:brewery, 2, name: "McHappy's Brewpub Extravaganza")
        get "/breweries", params: { by_name: "mchappy" }
      end

      it "returns a filtered list of breweries" do
        expect(json.size).to eq(2)
      end
    end

    context "when by_state param is passed" do
      before do
        create_list(:brewery, 3, state: "Everystate")
        get "/breweries", params: { by_state: "everyState" }
      end

      it "returns a filtered list of breweries" do
        expect(json.size).to eq(3)
      end
    end

    context "when by_type param is passed" do
      before do
        create_list(:brewery, 3, brewery_type: "planned")
        get "/breweries", params: { by_type: "Planned" }
      end

      it "returns a filtered list of breweries" do
        expect(json.size).to eq(3)
      end
    end

    context "when sort param is passed" do
      before do
        create(
          :brewery,
          name: "Alesmith",
          brewery_type: "micro"
        )
        create(
          :brewery,
          name: "Ballast Point Brewing Company",
          brewery_type: "regional"
        )
        create(
          :brewery,
          name: "Circle 9 Brewing",
          brewery_type: "micro"
        )
        get "/breweries", params: { sort: "type,-name" }
      end

      it "returns a sorted list of breweries" do
        expect(json.map { |brewery| brewery["name"] }).to eq(
          [
            "Circle 9 Brewing",
            "Alesmith",
            "Ballast Point Brewing Company"
          ]
        )
      end
    end
  end

  describe "GET /breweries/:id" do
    let!(:breweries) { create_list(:brewery, 5) }
    let(:brewery_id) { breweries.first.id }

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

      it "creates a brewery" do
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
    let!(:brewery) { create(:brewery) }
    let(:valid_attributes) { { name: "Another Brewery" } }

    context "when the record exists" do
      before { put "/breweries/#{brewery.id}", params: valid_attributes }

      it "updates the record" do
        expect(response.body).to be_empty
      end

      it "returns status code 204" do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe "DELETE /breweries/:id" do
    let!(:brewery) { create(:brewery) }
    let(:valid_attributes) { { name: "Another Brewery" } }

    before { delete "/breweries/#{brewery.id}" }

    it "returns status code 204" do
      expect(response).to have_http_status(204)
    end
  end
end
