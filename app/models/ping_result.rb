# frozen_string_literal: true

class PingResult < ApplicationRecord
  validates :host, :port, presence: true
end
