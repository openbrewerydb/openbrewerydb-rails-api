# frozen_string_literal: true

namespace :breweries do
  namespace :import do
    desc 'Import Brewers Association data'
    task brewers_association: :environment do
      Import::BrewersAssociation.perform
    end
  end
end
