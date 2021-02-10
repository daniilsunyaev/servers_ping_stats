# frozen_string_literal: true

class PingResult < ApplicationRecord
  validates :host, presence: true
end
