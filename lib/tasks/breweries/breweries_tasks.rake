# frozen_string_literal: true

namespace :breweries do
  namespace :import do
    desc 'Import Brewers Association data'
    task brewers_association: :environment do
      Import::BrewersAssociation.perform
    end
  end

  desc 'Convert any state abbreviations into full state (one-time task)'
  task update_state_abbreviations: :environment do
    UpdateStateAbbreviations.perform
  end
end
