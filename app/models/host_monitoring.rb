class HostMonitoring < ApplicationRecord
  validates :host, :port, presence: true
end
