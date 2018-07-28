# frozen_string_literal: true

class BreweriesController < ApplicationController
  before_action :set_brewery, only: %i[show update destroy]

  # FILTER: /breweries?by_city=san%20diego
  has_scope :by_city, only: :index
  # FILTER: /breweries?by_name=almanac
  has_scope :by_name, only: :index
  # FILTER: /breweries?by_state=california
  has_scope :by_state, only: :index
  # FILTER: /breweries?by_type=micro
  has_scope :by_type, only: :index

  # GET /breweries
  def index
    expires_in 1.day, public: true
    @breweries = apply_scopes(Brewery).page(params[:page])
    json_response(@breweries)
  end

  # POST /breweries
  def create
    @brewery = Brewery.create!(brewery_params)
    json_response(@brewery, :created)
  end

  # GET /breweries/:id
  def show
    json_response(@brewery)
  end

  # PUT /breweries/:id
  def update
    @brewery.update(brewery_params)
    head :no_content
  end

  # DELETE /breweries/:id
  def destroy
    @brewery.destroy
    head :no_content
  end

  private

    def brewery_params
      params.permit(
        :name,
        :address,
        :city,
        :state,
        :postal_code,
        :phone,
        :website_url,
        :brewery_type
      )
    end

    def set_brewery
      @brewery = Brewery.find(params[:id])
    end
end
