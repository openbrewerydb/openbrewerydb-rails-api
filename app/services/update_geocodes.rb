# frozen_string_literal: true

# Task to update the geocoding on breweries in DB
class UpdateGeocodes
  def initialize
    @log = ActiveSupport::Logger.new('log/update_geocodes.log')
    @dry_run = ENV['DRY_RUN'].present? ? ENV['DRY_RUN'].casecmp('true').zero? : false
    @counter = { updated: 0, skipped: 0, failed: 0, total: 0 }
    @offset = ENV['OFFSET'].present? ? ENV['OFFSET'] : nil
  end

  def self.perform
    new.perform
  end

  def perform
    start_time = Time.now
    @log.info "Task started at #{start_time}"

    puts "\n!!!!! DRY RUN !!!!!\nNO DATA WILL BE CHANGED\n".yellow if @dry_run

    process_brewery_batches

    output_summary

    end_time = Time.now
    duration = (start_time - end_time).round(2).abs
    log_and_print("\nTask finished at #{end_time} and lasted #{duration}s.")
    @log.close
  end

  private

  def log_and_print(message)
    puts(message)
    @log.info(message.uncolorize)
  end

  def output_summary
    log_and_print("\n---------------\nTotal: #{@counter[:total]}".white)
    log_and_print("Updated: #{@counter[:updated]}".green)
    log_and_print("Skipped: #{@counter[:skipped]}".blue)
    log_and_print("Failed:  #{@counter[:failed]}".red)
    log_and_print('----------------'.white)
  end

  def process_brewery_batches
    Brewery.find_in_batches(start: @offset) do |group|
      process_breweries(group)
    end
  end

  def process_breweries(breweries = [])
    breweries.each do |brewery|
      @counter[:total] += 1

      puts "#{brewery.id}. #{brewery.name} - #{brewery.address}".blue

      if brewery.address_1.present? &&
         brewery.latitude.blank? &&
         brewery.address_1.match?(/[Ste]/)

        unless @dry_run
          if brewery.save
            puts "     #{brewery.latitude}, #{brewery.longitude}".green
            @counter[:updated] += 1
            sleep 1
          else
            puts "     #{brewery.name} failed to update!".red
            @counter[:failed] += 1
          end
        end
      else
        @counter[:skipped] += 1
        puts '     Skipped!'.red
      end
    end
  end
end
