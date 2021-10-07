# frozen_string_literal: true

# BreweryController class
class BreweriesController < ApplicationController
  SORT_ORDER = %w[asc desc].freeze
  DDOS_ATTACK = ENV['DDOS_ATTACK'] == 'true'

  before_action :set_brewery, only: %i[show update destroy]
  before_action :track_analytics

  # FILTER: /breweries?by_country=scotland
  has_scope :by_country, only: :index
  # FILTER: /breweries?by_city=san%20diego
  has_scope :by_city, only: :index
  # FILTER: /breweries?by_name=almanac
  has_scope :by_name, only: :index
  # FILTER: /breweries?by_state=california
  has_scope :by_state, only: :index
  # FILTER: /breweries?by_type=micro
  has_scope :by_type, only: :index
  # FILTER /breweries?by_postal=44107
  has_scope :by_postal, only: :index
  # FILTER /breweries?by_ids=1,2,3
  has_scope :by_ids, only: :index
  # FILTER /breweries?by_dist=38.8977,77.0365
  has_scope :by_dist, only: :index
  # FILTER /breweries?exclude_types=micro,nano
  has_scope :exclude_types, only: :index

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

    @breweries =
      if DDOS_ATTACK
        { message: 'This endpoint is temporarily disabled.' }
      else
        Brewery.search(
          format_query(params[:query]),
          fields: %w[name city state],
          match: :word_start,
          limit: 15,
          load: false,
          misspellings: { below: 2 }
        ).map { |b| { id: b.obdb_id, name: b.name } }
      end
    json_response(@breweries)
  end

  # GET /breweries/search
  def search
    expires_in 1.day, public: true

    @breweries =
      if DDOS_ATTACK
        { message: 'This endpoint is temporarily disabled.' }
      else
        Brewery.search(
          format_query(params[:query]),
          page: params[:page],
          per_page: params[:per_page]
        )
      end

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
      :name, :street, :city, :state, :postal_code, :phone, :country,
      :website_url, :brewery_type
    )
  end

  # A list of the param names that can be used for ordering the model list.
  # For example it retrieves a list of breweries in descending order of type.
  # Within a specific type, names are ordered first
  # order_params
  # GET /breweries?sort=type_desc,name
  # order_params # => { brewery_type: :desc, name: :asc }
  # Brewery.order(brewery_type: :desc, name: :asc)
  #
  def order_params
    return unless params[:sort]

    ordering = {}
    sorted_params = params[:sort].split(',')

    sorted_params.each do |attr|
      attr, sort_m = attr.split(':')
      sort_method = SORT_ORDER.include?(sort_m) ? sort_m : 'asc'
      attr = 'brewery_type' if attr == 'type'

      ordering[attr] = sort_method.to_sym if Brewery.attribute_names.include?(attr)
    end

    ordering
  end

  def set_brewery
    @brewery = Brewery.find_by!(obdb_id: params[:id])
  end

  def track_analytics
    ahoy.track action_name, params
  end

  # Allow _ to be a separator
  def format_query(query)
    query.gsub('_', ' ')
  end
end
