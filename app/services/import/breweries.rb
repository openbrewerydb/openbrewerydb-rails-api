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

      table_empty =
        if Brewery.size.positive?
          false
        else
          puts 'Brewery table empty'.blue
          true
        end

      body.each_with_index do |brewery, index|
        return if index >= 20
        obdb_id = brewery.dig(:obdb_id)
        brewery_name = brewery.dig(:name)
        brewery_address = brewery.dig(:street)
        brewery_city = brewery.dig(:city)
        brewery_state = brewery.dig(:state)

        
        unless table_empty
          puts 'table not empty, checking for brewery'.red
          # Check if brewery already exists
          brewery_exists = Brewery.where(
            name: brewery_name,
            street: brewery_address,
            city: brewery_city,
            state: brewery_state
          )
          
          if brewery_exists
            puts '  Brewery already exists! Skipping import.'.blue
            @counter[:skipped] += 1
            next
          end
        end
        
        if @dry_run
          @counter[:skipped] += 1
        else
          new_brewery = Brewery.create(
            obdb_id: obdb_id,
            name: brewery_name,
            street: brewery_address,
            city: brewery_city,
            state: brewery_state,
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
          )
          
          if new_brewery.save
            puts "  #{new_brewery.name} created with ID #{new_brewery.id}!".green
            @counter[:added] += 1
          else
            puts "  Error creating Brewery #{new_brewery.name} : "\
            "#{new_brewery.errors.messages.join('; ')}".red
            @counter[:failed] += 1
          end
        end
      end
    end
  end
end
