# frozen_string_literal: true

module V1
  module Breweries
    # BreweryController class
    class BreweriesController < ApplicationController
      SORT_ORDER = %w[asc desc].freeze
      DDOS_ATTACK = ENV['DDOS_ATTACK'] == 'true'

      before_action :set_brewery, only: %i[show update destroy]
      before_action :validate_params, only: %i[index meta autocomplete search]

      # FILTER: /breweries?by_country=scotland
      has_scope :by_country, only: %i[index meta]
      # FILTER: /breweries?by_city=san%20diego
      has_scope :by_city, only: %i[index meta]
      # FILTER: /breweries?by_name=almanac
      has_scope :by_name, only: %i[index meta]
      # FILTER: /breweries?by_state=california
      has_scope :by_state, only: %i[index meta]
      # FILTER: /breweries?by_type=micro
      has_scope :by_type, only: %i[index meta]
      # FILTER /breweries?by_postal=44107
      has_scope :by_postal, only: %i[index meta]
      # FILTER /breweries?by_ids=1,2,3
      has_scope :by_ids, only: %i[index meta]
      # FILTER /breweries?by_dist=38.8977,77.0365
      has_scope :by_dist, only: %i[index meta]
      # FILTER /breweries?exclude_types=micro,nano
      has_scope :exclude_types, only: %i[index meta]

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

      # GET /breweries/meta
      def meta
        expires_in 1.day, public: true

        @breweries = apply_scopes(Brewery).all

        # Returning everything as string for now because Ruby is annoying
        json_response({
                        total: @breweries.size.to_s,
                        page: params[:page] || 1.to_s,
                        per_page: params[:per_page] || Kaminari.config.default_per_page.to_s
                      })
      end

      # GET /breweries/:id
      def show
        expires_in 1.day, public: true
        json_response(@brewery)
      end

      # GET /breweries/random
      def random
        expires_in 1.day, public: true
        size = params[:size].to_i.zero? ? 1 : params[:size].to_i

        # ActiveRecord random record: https://stackoverflow.com/a/25577054
        @breweries = Brewery.order(Arel.sql('RANDOM()')).limit([size, MAX_PER_PAGE].min)

        json_response(@breweries)
      end

      # GET /breweries/autocomplete
      def autocomplete
        expires_in 1.day, public: true

        @breweries =
          if DDOS_ATTACK
            { message: 'This endpoint is temporarily disabled.' }
          else
            Brewery.search(
              params[:query],
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
              params[:query],
              page: params[:page],
              per_page: params[:per_page]
            )
          end

        json_response(@breweries)
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

      def validate_params
        errors = []
        params.each do |key, value|
          next if %w[controller action].include?(key)

          # Convert underscores to spaces in params (for convenience)
          value.gsub!('_', ' ') unless value.nil? || !value.instance_of?(String)

          case key
          when 'by_type'
            unless BREWERY_TYPES.include?(value)
              errors.push("Brewery type must include one of these types: #{BREWERY_TYPES}")
            end
          when 'by_dist'
            unless value.split(',').map(&:to_f).size == 2
              errors.push("You must provide latitude and longitude for the 'by_dist' query param")
            end
          end
        end

        return json_response({ errors: }, :bad_request) if errors.size.positive?
      end
    end
  end
end
