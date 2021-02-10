# frozen_string_literal: true

class HostMonitoring < ApplicationRecord
  validates :host, presence: true
end
