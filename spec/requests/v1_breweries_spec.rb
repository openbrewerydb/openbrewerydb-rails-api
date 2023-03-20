# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Breweries API" do
  describe "GET /v1/breweries" do
    context "when no params are passed" do
      before do
        create_list(:brewery, 201)
        get "/v1/breweries"
      end

      # NOTE: Set in /config/initializers/kaminari_config.rb
      it "returns the default number of breweries" do
        expect(json.size).to eq(50)
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
        create_list(:brewery, 51)
        get "/v1/breweries", params: {
          by_state: nil,
          page: "invalid",
          sort: "*bob",
          id: 42,
          brewery: { id: 42 }
        }
      end

      it "returns a status of 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the default number of breweries" do
        expect(json.size).to eq(50)
      end
    end

    context "when page param is passed" do
      before do
        create_list(:brewery, 101)
        get "/v1/breweries", params: { page: 3 }
      end

      it "returns another page of breweries" do
        expect(json.size).to eq(1)
      end
    end

    context "when per_page param is passed" do
      before do
        create_list(:brewery, 205)
      end

      it "returns a limited number breweries" do
        get "/v1/breweries", params: { per_page: 5 }
        expect(json.size).to eq(5)
      end

      # NOTE: Set in /config/initializers/kaminari_config.rb
      it "does not exceed the maximum number of breweries per page" do
        get "/v1/breweries", params: { per_page: 201 }
        expect(json.size).to eq(200)
      end
    end

    context "when by_city param is passed" do
      before do
        create_list(:brewery, 1)
        create_list(:brewery, 1, city: "San Diego")
        create_list(:brewery, 1, city: "San Francisco")
        create_list(:brewery, 1, city: "Houston")
      end

      it "returns a filtered list of breweries" do
        get "/v1/breweries", params: { by_city: "Houston" }
        expect(json.size).to eq(1)
      end

      it "returns a filtered list with multiple" do
        get "/v1/breweries", params: { by_city: "San" }
        expect(json.size).to eq(2)
      end

      it "returns a filtered list with + as space" do
        get "/v1/breweries", params: { by_city: "San+Diego" }
        expect(json.size).to eq(1)
      end
    end

    context "when by_country param is passed" do
      before do
        create_list(:brewery, 1, country: "England")
        create_list(:brewery, 1, country: "South Korea")
      end

      it "returns a filtered list of breweries" do
        get "/v1/breweries", params: { by_country: "England" }
        expect(json.size).to eq(1)
      end

      it "handles '+' as a space in the query string" do
        get "/v1/breweries", params: { by_country: "South+Korea" }
        expect(json.size).to eq(1)
      end
    end

    context "when by_name param is passed" do
      before do
        create_list(:brewery, 1, name: "Broad Brook Brewing Company")
        create_list(:brewery, 1, name: "McHappy's Brewpub Extravaganza")
      end

      it "returns a filtered list of breweries" do
        get "/v1/breweries", params: { by_name: "mchappy" }
        expect(json.size).to eq(1)
      end

      it "handles '+' as a space in the query string" do
        get "/v1/breweries", params: { by_name: "broad+brook" }
        expect(json.size).to eq(1)
      end

      it "handles a space as a space in the query string" do
        get "/v1/breweries", params: { by_name: "broad brook" }
        expect(json.size).to eq(1)
      end
    end

    context "when by_state param is passed" do
      before do
        create_list(:brewery, 2, state: "New York")
        create(:brewery, state: "California")
        create(:brewery, state: "Delaware")
        create(:brewery, county_province: "dolnośląskie")
      end

      it "returns a filtered list of breweries" do
        get "/v1/breweries", params: { by_state: "california" }
        expect(json.size).to eq(1)
      end

      it "returns a filtered list of breweries with snake case" do
        get "/v1/breweries", params: { by_state: "new_york" }
        expect(json.size).to eq(2)
      end

      # Kebab-case doesn't seem to jive with sanitization
      it "returns empty list with kebab case" do
        get "/v1/breweries", params: { by_state: "new-york" }
        expect(json.size).to eq(0)
      end

      it "returns filtered list with + as space" do
        get "/v1/breweries", params: { by_state: "new+york" }
        expect(json.size).to eq(2)
      end

      it "returns empty list when abbreviation" do
        get "/v1/breweries", params: { by_state: "ny" }
        expect(json.size).to eq(0)
      end

      it "returns empty list when mispelled" do
        get "/v1/breweries", params: { by_state: "delwar" }
        expect(json.size).to eq(0)
      end

      it "returns a filtered list when utf-8" do
        get "/v1/breweries", params: { by_state: "dolnośląskie" }
        expect(json.size).to eq(1)
      end

      it "sanitizes for SQL LIKE \\" do
        get "/v1/breweries", params: { by_state: "Cali\\" }
        expect(response).to have_http_status(:ok)
      end

      it "sanitizes for SQL LIKE %" do
        get "/v1/breweries", params: { by_state: "Cali%" }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when by_type param is passed" do
      before do
        create_list(:brewery, 3, brewery_type: "planning")
      end

      it "returns a filtered list of breweries, when valid type" do
        get "/v1/breweries", params: { by_type: "planning" }
        expect(json.size).to eq(3)
      end

      it "throws a 400 error, when invalid type" do
        get "/v1/breweries", params: { by_type: "notvalid" }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when exclude_types param is passed" do
      before do
        create_list(:brewery, 2, brewery_type: "micro")
        create_list(:brewery, 2, brewery_type: "nano")
        create_list(:brewery, 3, brewery_type: "planned")
      end

      it "returns a filtered list of breweries - single" do
        get "/v1/breweries", params: { exclude_types: "micro" }
        expect(json.size).to eq(5)
      end

      it "returns a filtered list of breweries - multiple" do
        get "/v1/breweries", params: { exclude_types: "micro,nano" }
        expect(json.size).to eq(3)
      end
    end

    context "when postal param is passed" do
      before do
        create_list(:brewery, 5)
        create_list(:brewery, 3, postal_code: "44107")
        create_list(:brewery, 2, postal_code: "44107-5555")
        create_list(:brewery, 1, postal_code: "WC2N 5DU")
      end

      it "returns a filtered list of breweries for US postal codes" do
        get "/v1/breweries", params: { by_postal: "44107" }
        expect(json.size).to eq(5)
      end

      it "returns a filtered list of breweries for US postal code ZIP+4" do
        get "/v1/breweries", params: { by_postal: "44107-5555" }
        expect(json.size).to eq(2)
      end

      it "returns a filtered list of breweries for international postal codes" do
        get "/v1/breweries", params: { by_postal: "WC2N" }
        expect(json.size).to eq(1)
      end
    end

    context "when distance param is passed" do
      before do
        create_list(:brewery, 5)
      end

      it "returns 200 when valid params" do
        get "/v1/breweries", params: { by_dist: "74,-114" }
        expect(response).to have_http_status(:ok)
      end

      it "throws a 400 error when invalid params" do
        get "/v1/breweries", params: { by_dist: "1" }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when sort param is passed" do
      before do
        create(:brewery, name: "Alesmith", brewery_type: "micro")
        create(:brewery, name: "Ballast Point Brewing Company", brewery_type: "regional")
        create(:brewery, name: "Circle 9 Brewing", brewery_type: "micro")
        get "/v1/breweries", params: { sort: "type,name:desc" }
      end

      it "returns a sorted list of breweries" do
        expect(json.map { |brewery| brewery["name"] }).to eq(
          ["Circle 9 Brewing", "Alesmith", "Ballast Point Brewing Company"]
        )
      end
    end
  end

  describe "GET /v1/breweries/meta" do
    before do
      create(:brewery)
      create(:brewery, state: "dolnośląskie")
      create(:brewery, county_province: "dolnośląskie")
      create(:brewery, country: "Poland")
      create(:brewery, postal_code: "OBDB123")
    end

    it "returns status code 200" do
      get "/v1/breweries/meta"
      expect(response).to have_http_status(:ok)
    end

    it "returns meta data about all breweries" do
      get "/v1/breweries/meta"
      expect(json).to eq({ "total" => "5", "per_page" => "50", "page" => "1" })
    end

    it "returns meta data filtered by by_state" do
      get "/v1/breweries/meta", params: { by_state: "dolnośląskie" }
      expect(json).to eq({ "total" => "2", "per_page" => "50", "page" => "1" })
    end

    it "returns meta data filtered by by_country" do
      get "/v1/breweries/meta", params: { by_country: "Poland" }
      expect(json).to eq({ "total" => "1", "per_page" => "50", "page" => "1" })
    end

    it "returns meta data filtered by by_postal" do
      get "/v1/breweries/meta", params: { by_postal: "OBDB123" }
      expect(json).to eq({ "total" => "1", "per_page" => "50", "page" => "1" })
    end

    it "returns meta data with per_page" do
      get "/v1/breweries/meta", params: { per_page: 2 }
      expect(json).to eq({ "total" => "5", "per_page" => "2", "page" => "1" })
    end

    it "returns meta data with page" do
      get "/v1/breweries/meta", params: { per_page: 2, page: 3 }
      expect(json).to eq({ "total" => "5", "per_page" => "2", "page" => "3" })
    end
  end

  describe "GET /v1/breweries/random" do
    before do
      create_list(:brewery, 55)
    end

    it "returns a brewery" do
      get "/v1/breweries/random"
      expect(json.size).to eq(1)
    end

    it "returns status code 200" do
      get "/v1/breweries/random"
      expect(response).to have_http_status(:ok)
    end

    it "returns a number of breweries when size param" do
      get "/v1/breweries/random", params: { size: 3 }
      expect(json.size).to eq(3)
    end

    it "does not return more breweries than the max allowed" do
      get "/v1/breweries/random", params: { size: 51 }
      expect(json.size).to eq(50)
    end
  end

  describe "GET /v1/breweries/:id" do
    let!(:brewery) { create(:brewery) }
    let(:brewery_id) { brewery.obdb_id }

    before { get "/v1/breweries/#{brewery_id}" }

    context "when the record exists" do
      it "returns status code 200" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the record does not exist" do
      let(:brewery_id) { "fictional-brewery-nowhere" }

      it "returns status code 404" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Brewery/)
      end
    end
  end

  describe "POST /v1/breweries" do
    let(:valid_attributes) { { name: "Awesome Brewery" } }

    context "when the request is valid" do
      it "returns returns a routing error" do
        expect { post "/v1/breweries", params: valid_attributes }.to raise_error(
          ActionController::RoutingError
        )
      end
    end
  end

  describe "PUT /v1/breweries/:id" do
    let!(:brewery) { create(:brewery) }
    let(:valid_attributes) { { name: "Another Brewery" } }

    context "when the record exists" do
      it "returns a routing error" do
        expect do
          put "/v1/breweries/#{brewery.id}", params: valid_attributes
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe "DELETE /v1/breweries/:id" do
    let!(:brewery) { create(:brewery) }
    let(:valid_attributes) { { name: "Another Brewery" } }

    it "return a routing error" do
      expect { delete "/v1/breweries/#{brewery.id}" }.to raise_error(
        ActionController::RoutingError
      )
    end
  end
end
