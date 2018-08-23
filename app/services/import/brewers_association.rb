# frozen_string_literal: true

module Import
  class BrewersAssociation
    ALL_STATES = %w[
      Alabama Alaska Arizona Arkansas California Colorado Connecticut Delaware
      District\ of\ Columbia Florida Georgia Hawaii Idaho Illinois Indiana Iowa
      Kansas Kentucky Louisiana Maine Maryland Massachusetts Michigan Minnesota
      Mississippi Missouri Montana Nebraska Nevada New\ Hampshire New\ Jersey
      New\ Mexico New\ York North\ Carolina North\ Dakota Ohio Oklahoma Oregon
      Pennsylvania Rhode\ Island South\ Carolina South\ Dakota Tennessee Texas
      Utah Vermont Virginia Washington West\ Virginia Wisconsin Wyoming
    ].freeze

    attr_reader :log

    def initialize
      @log = ActiveSupport::Logger.new('log/import_brewers_association.log')
      @states = ENV['STATE'].present? ? [ENV['STATE']] : ALL_STATES
      @dry_run = ENV['DRY_RUN'].present? ? ENV['DRY_RUN'].casecmp('true').zero? : false
      @states_count = @states.size
      @counter = { added: 0, failed: 0, skipped: 0, total: 0 }
    end

    # https://hackernoon.com/service-objects-in-ruby-on-rails-and-you-79ca8a1c946e
    def self.perform
      new.perform
    end

    def perform
      start_time = Time.now
      @log.info "Task started at #{start_time}"

      puts "\n!!!!! DRY RUN !!!!!\nNO DATA WILL BE IMPORTED\n" if @dry_run

      import_breweries

      output_summary

      end_time = Time.now
      duration = (start_time - end_time).round(2).abs
      puts "\nTask finished at #{end_time} and lasted #{duration} seconds."
      @log.info "Task finished at #{end_time} and lasted #{duration} seconds."
      @log.close
    end

    private

    def import_breweries
      @states.each_with_index do |state, state_index|
        message = "#{state_index + 1}/#{@states_count} #{file_path_for(state).basename}"

        unless File.exist?(file_path_for(state))
          @log.info "#{message} does not exist."
          puts "#{message} does not exist.".red
          next
        end

        @log.info "#{message} exists."
        puts "#{message} exists.".green

        # Open and parse HTML file
        doc = File.open(file_path_for(state)) { |f| Nokogiri::HTML(f) }

        # Grab the breweries
        breweries = doc.css('.brewery')
        breweries_count = breweries.size
        @counter[:total] += breweries_count
        puts "#{breweries_count} breweries found.".green

        # Import breweries
        breweries.each_with_index do |brewery, brewery_index|
          # Brewery Name
          brewery_name = brewery.css('.brewery-info .name').text.strip

          # Brewery Address
          brewery_address = brewery.css('.brewery-info .address').text.strip

          brewery_city_state_postal = brewery.css('.brewery-info .address + li').text
          brewery_city_state_postal = brewery_city_state_postal.split('|')[0].strip

          if (match = brewery_city_state_postal.match(/(.+), (.+) (.*)/i))
            brewery_city, brewery_state, brewery_postal_code = match.captures
          end

          # Brewery Phone
          brewery_phone = brewery.css('.brewery-info .telephone').text
          brewery_phone = brewery_phone.sub('Phone: ', '').strip.gsub(/[^0-9]/, '')

          # Brewery Type
          brewery_type = brewery.css('.brewery-info .brewery_type').text
          brewery_type = brewery_type.sub("\n", '').sub('Type: ', '').strip.downcase

          # Brewery URL
          brewery_url = brewery.css('.brewery-info .url a')
          brewery_url = brewery_url.any? ? brewery_url.attribute('href') : ''

          # Output
          puts "  #{brewery_index + 1}/#{breweries_count} : #{brewery_name} : #{brewery_type} : "\
                "#{brewery_address}, #{brewery_city}, #{brewery_state} #{brewery_postal_code} : "\
                "#{brewery_phone} : #{brewery_url}".blue

          # Check if brewery already exists
          brewery_exists = Brewery.where(
            name: brewery_name,
            street: brewery_address,
            city: brewery_city,
            state: brewery_state
          ).any?

          if brewery_exists
            puts '  Brewery already exists! Skipping import.'.blue
            @counter[:skipped] += 1
            next
          end

          if @dry_run
            @counter[:skipped] += 1
          else
            new_brewery = Brewery.create(
              name: brewery_name,
              street: brewery_address,
              city: brewery_city,
              state: brewery_state,
              postal_code: brewery_postal_code,
              website_url: brewery_url,
              phone: brewery_phone,
              brewery_type: brewery_type
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

    def file_path_for(state)
      raise InvalidState if state.empty?
      Rails.root.join(
        'lib',
        'import',
        'brewers_association',
        "#{state.parameterize.underscore}.html"
      )
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
