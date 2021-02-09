class PingResult < ApplicationRecord
  validates :host, :port, presence: true
end
