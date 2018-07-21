# frozen_string_literal: true

class Brewery < ApplicationRecord
  validates :name, presence: true
end
