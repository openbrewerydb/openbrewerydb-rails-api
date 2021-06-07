# frozen_string_literal: true

module Import
  class Breweries

    attr_reader :log

    def initialize
      @log = ActiveSupport::Logger.new('log/import_breweries.log')
      @dry_run = ENV['DRY_RUN'].present? ? ENV['DRY_RUN'].casecmp('true').zero? : false
      @counter = { added: 0, failed: 0, skipped: 0, total: 0 }
      @path_to_json = 'https://raw.githubusercontent.com/openbrewerydb/openbrewerydb/master/breweries.json'
      @path_to_sql = 'https://raw.githubusercontent.com/openbrewerydb/openbrewerydb/master/breweries.sql'
    end

    def self.perform
      new.perform
    end

    def perform
      start_time = Time.now
      puts "\nTask started at #{start_time}"
      @log.info "Task started at #{start_time}"
      
      puts "\n!!!!! DRY RUN !!!!!\nNO DATA WILL BE IMPORTED\n" if @dry_run
      
      if ENV['TRUNCATE']&.upcase == 'TRUE'
        import_breweries_sql
      else
        puts "Updating breweries\n"
        import_breweries
      end
      
      output_summary
      
      end_time = Time.now
      duration = (start_time - end_time).round(2).abs
      puts "\nTask finished at #{end_time} and lasted #{duration} seconds."
      @log.info "Task finished at #{end_time} and lasted #{duration} seconds."
      @log.close
    end

    private

    def import_breweries
      puts "#{Time.now} : Getting raw breweries file - json".blue
      connection = Faraday::Connection.new @path_to_json
      response = connection.get
      body = JSON.parse(response.body.as_json, symbolize_names: true)
      puts "#{Time.now} : Got file: #{response.status}".blue
      puts "#{Time.now} : Got #{body.size} breweries".blue

      if response.status != 200
        @log.info "Could not get breweries. Exiting task"
        abort("Could not get breweries. Exiting task")
      end

      breweries = body.map do |brewery|
        if Brewery.where(obdb_id: brewery.dig(:obdb_id)).present?
          @counter[:skipped] += 1
          next
        end

        @counter[:added] += 1

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

      if breweries.empty?
        puts "#{Time.now} : No breweries to map, exiting"
        return
      end

      # filter out nils. In ruby-2.7, we can use filter_map instead of map above.
      breweries.filter! { |brewery| brewery.present? }

      puts "#{Time.now} : Mapped breweries".green
      
      if @dry_run
        @counter[:added] = 0 
        @counter[:skipped] += breweries.size 
      else
        puts "#{Time.now} : Saving breweries".blue
        ActiveRecord::Base.transaction do
          new_breweries = Brewery.create!(breweries)
        end
      end
    end

    def import_breweries_sql
      puts "#{Time.now} : Getting raw breweries file - sql".blue
      connection = Faraday::Connection.new @path_to_sql
      response = connection.get
      puts "#{Time.now} : Got file: #{response.status}".blue

      unless @dry_run
        puts "#{Time.now} : Truncating table before import".blue
        ActiveRecord::Base.connection.truncate(:breweries)
      end
      puts "#{Time.now} : # of Breweries (before import): #{Brewery.count}".green
      
      unless @dry_run
        puts "#{Time.now} : Inserting to Breweries by SQL"
        ActiveRecord::Base.connection.insert(response.body.to_s)
      end

      # check db
      @counter[:added] = Brewery.count
      puts "#{Time.now} : # of Breweries (after import): #{@counter[:added]}".green
    end
    
    def output_summary
      puts "\n---------------\nTotal: #{@counter[:total]}".white
      puts "Added: #{@counter[:added]}".green
      puts "Skipped: #{@counter[:skipped]}".blue
      puts "Failed: #{@counter[:failed]}".red
      puts '----------------'.white
    end
  end
end
