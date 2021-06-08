# frozen_string_literal: true

# Task to update the state abbreviations
class UpdateStateAbbreviations
  def initialize
    @log = ActiveSupport::Logger.new('log/update_state_abbreviations.log')
    @dry_run = ENV['DRY_RUN'].present? ? ENV['DRY_RUN'].casecmp('true').zero? : false
    @counter = { updated: 0, skipped: 0, failed: 0, total: 0 }
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
    Brewery.find_in_batches.with_index do |group, batch|
      log_and_print("Processing group ##{batch + 1}")
      process_breweries(group)
    end
  end

  def process_breweries(breweries = [])
    breweries.each do |brewery|
      update_state_abbreviation(brewery)
    end
  end

  def update_state_abbreviation(brewery)
    @counter[:total] += 1

    if brewery.state.blank?
      @counter[:failed] += 1
      return
    end

    # Check if brewery state is only two characters (ie, an abbreviation)
    if brewery.state.match?(/^[A-Za-z]{2}$/)
      unless @dry_run
        brewery.update_attribute(
          :state,
          STATE_ABBR_TO_NAME[brewery.state.upcase]
        )
      end
      @counter[:updated] += 1
    else
      @counter[:skipped] += 1
    end
  end
end

STATE_ABBR_TO_NAME = {
  'AL' => 'Alabama',
  'AK' => 'Alaska',
  'AS' => 'America Samoa',
  'AZ' => 'Arizona',
  'AR' => 'Arkansas',
  'CA' => 'California',
  'CO' => 'Colorado',
  'CT' => 'Connecticut',
  'DE' => 'Delaware',
  'DC' => 'District of Columbia',
  'FM' => 'Federated States Of Micronesia',
  'FL' => 'Florida',
  'GA' => 'Georgia',
  'GU' => 'Guam',
  'HI' => 'Hawaii',
  'ID' => 'Idaho',
  'IL' => 'Illinois',
  'IN' => 'Indiana',
  'IA' => 'Iowa',
  'KS' => 'Kansas',
  'KY' => 'Kentucky',
  'LA' => 'Louisiana',
  'ME' => 'Maine',
  'MH' => 'Marshall Islands',
  'MD' => 'Maryland',
  'MA' => 'Massachusetts',
  'MI' => 'Michigan',
  'MN' => 'Minnesota',
  'MS' => 'Mississippi',
  'MO' => 'Missouri',
  'MT' => 'Montana',
  'NE' => 'Nebraska',
  'NV' => 'Nevada',
  'NH' => 'New Hampshire',
  'NJ' => 'New Jersey',
  'NM' => 'New Mexico',
  'NY' => 'New York',
  'NC' => 'North Carolina',
  'ND' => 'North Dakota',
  'OH' => 'Ohio',
  'OK' => 'Oklahoma',
  'OR' => 'Oregon',
  'PW' => 'Palau',
  'PA' => 'Pennsylvania',
  'PR' => 'Puerto Rico',
  'RI' => 'Rhode Island',
  'SC' => 'South Carolina',
  'SD' => 'South Dakota',
  'TN' => 'Tennessee',
  'TX' => 'Texas',
  'UT' => 'Utah',
  'VT' => 'Vermont',
  'VI' => 'Virgin Island',
  'VA' => 'Virginia',
  'WA' => 'Washington',
  'WV' => 'West Virginia',
  'WI' => 'Wisconsin',
  'WY' => 'Wyoming'
}.freeze
