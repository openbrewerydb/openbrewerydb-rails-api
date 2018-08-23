# frozen_string_literal: true

class BreweriesController < ApplicationController
  SORT_ORDER = { '+': :asc, '-': :desc }.freeze

  # Since this is an API, we're uninterested in tracking pageviews
  skip_before_action :track_ahoy_visit
  before_action :track_event

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
    @breweries =
      apply_scopes(Brewery)
      .order(order_params)
      .page(params[:page])
      .per(params[:per_page])
    json_response(@breweries)
  end

  # GET /breweries/:id
  def show
    expires_in 1.day, public: true
    json_response(@brewery)
  end

  # GET /breweries/autocomplete
  def autocomplete
    expires_in 1.day, public: true
    @breweries = Brewery.search(
      params[:query],
      fields: %w[name city state],
      match: :word_start,
      limit: 15,
      load: false,
      misspellings: { below: 2 }
    )
    json_response(@breweries.map { |b| { id: b.id, name: b.name } })
  end

  # GET /breweries/search
  def search
    expires_in 1.day, public: true
    @breweries = Brewery.search(
      params[:query],
      page: params[:page],
      per_page: params[:per_page]
    )
    json_response(@breweries)
  end

  # POST /breweries
  # NOTE: Disabled via /config/routes.rb
  def create
    @brewery = Brewery.create!(brewery_params)
    json_response(@brewery, :created)
  end

  # PUT /breweries/:id
  # NOTE: Disabled via /config/routes.rb
  def update
    @brewery.update(brewery_params)
    head :no_content
  end

  # DELETE /breweries/:id
  # NOTE: Disabled  via /config/routes.rb
  def destroy
    @brewery.destroy
    head :no_content
  end

  private

    def brewery_params
      params.permit(
        :name,
        :street,
        :city,
        :state,
        :postal_code,
        :phone,
        :country,
        :website_url,
        :brewery_type
      )
    end

    # A list of the param names that can be used for ordering the model list
    # For example it retrieves a list of breweries in descending order of type.
    # Within a specific type, names are ordered first
    #
    # GET /breweries?sort=-type,name
    # order_params # => { brewery_type: :desc, name: :asc }
    # Brewery.order(brewery_type: :desc, name: :asc)
    #
    def order_params
      return unless params[:sort]

      ordering = {}
      sorted_params = params[:sort].split(',')

      sorted_params.each do |attr|
        sort_sign = /^[+-]/.match?(attr) ? attr.slice!(0) : '+'
        attr = 'brewery_type' if attr == 'type'
        if Brewery.attribute_names.include?(attr)
          ordering[attr] = SORT_ORDER[sort_sign.to_sym]
        end
      end

      ordering
    end

    def set_brewery
      @brewery = Brewery.find(params[:id])
    end

    def track_event
      ahoy.track "#{controller_name}/#{action_name}", request.query_string
    end
end
