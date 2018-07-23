# frozen_string_literal: true

namespace :breweries do
  desc 'Import Brewers Association for US States'
  task import_brewers_association: :environment do
    ImportBrewersAssociation.perform
  end
end
