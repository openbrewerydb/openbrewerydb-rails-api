# frozen_string_literal: true

module Ahoy
  # Ahoy Event model class
  class Event < ApplicationRecord
    include Ahoy::QueryMethods

    self.table_name = 'ahoy_events'

    belongs_to :visit
  end
end
