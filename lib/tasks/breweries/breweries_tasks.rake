# frozen_string_literal: true

namespace :breweries do
  namespace :import do
    desc 'Import OpenBreweryDb data'
    task breweries: :environment do
      Import::Breweries.perform
    end
  end

  desc 'Convert any state abbreviations into full state (one-time task)'
  task update_state_abbreviations: :environment do
    UpdateStateAbbreviations.perform
  end

  desc 'Process Geocodes for all Breweries'
  task update_geocodes: :environment do
    UpdateGeocodes.perform
  end
end
