# frozen_string_literal: true

class BreweriesController < ApplicationController
  before_action :set_brewery, only: %i[show update destroy]

  # GET /breweries
  def index
    expires_in 1.day, public: true
    @breweries = Brewery.page params[:page]
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
