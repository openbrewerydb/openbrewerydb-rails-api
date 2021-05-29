# frozen_string_literal: true

module Import
  class Breweries

    attr_reader :log

    def initialize
      @log = ActiveSupport::Logger.new('log/import_breweries.log')
      @dry_run = ENV['DRY_RUN'].present? ? ENV['DRY_RUN'].casecmp('true').zero? : false
      @counter = { added: 0, failed: 0, skipped: 0, total: 0 }
      @path_to_json = 'https://raw.githubusercontent.com/openbrewerydb/openbrewerydb/master/breweries.json'
    end

    def self.perform
      new.perform
    end

    def perform
      start_time = Time.now
      puts "\nTask started at #{start_time}"
      @log.info "Task started at #{start_time}"
      
      puts "\n!!!!! DRY RUN !!!!!\nNO DATA WILL BE IMPORTED\n" if @dry_run
      
      import_breweries
      
      # output_summary
      
      end_time = Time.now
      duration = (start_time - end_time).round(2).abs
      puts "\nTask finished at #{end_time} and lasted #{duration} seconds."
      @log.info "Task finished at #{end_time} and lasted #{duration} seconds."
      @log.close
    end

    private

    def import_breweries
      connection = Faraday::Connection.new @path_to_json
      response = connection.get(nil)
      body = JSON.parse(response.body.as_json, symbolize_names: true)
      puts "Got file: #{response.status}"
      puts "Got #{body.size} breweries"

      if response.status != 200
        @log.info "Could not get breweries. Exiting task"
        abort("Could not get breweries. Exiting task")
      end

      breweries = body[0..19].map do |brewery|
        puts "#{Time.now} : Mapped brewery".green
        {
          obdb_id: brewery.dig(:obdb_id),
          name: brewery.dig(:name),
          street: brewery.dig(:street),
          city: brewery.dig(:city),
          state: brewery.dig(:state),
          country: brewery.dig(:country),
          postal_code: brewery.dig(:postal_code),
          website_url: brewery.dig(:website_url),
          phone: brewery.dig(:phone),
          brewery_type: brewery.dig(:brewery_type),
          address_2: brewery.dig(:address_2),
          address_3: brewery.dig(:address_3),
          county_province: brewery.dig(:county_province),
          longitude: brewery.dig(:longitude),
          latitude: brewery.dig(:latitude),
          tags: brewery.dig(:tags)
        }
      end
      
      puts "#{Time.now} : Saving breweries".blue
      ActiveRecord::Base.transaction do
        new_breweries = Brewery.create!(breweries)
      end
    end
  end
end
