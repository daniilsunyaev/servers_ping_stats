# frozen_string_literal: true

class HostMonitoring < ApplicationRecord
  validates :host, :port, presence: true
end
