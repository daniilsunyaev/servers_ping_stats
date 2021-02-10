# frozen_string_literal: true

class HostMonitoring < ApplicationRecord
  validates :host, presence: true
  validate :host_is_not_monitored, if: :active?

  HOST_IS_ALREADY_TAKEN_ERROR = 'Host is already monitored'

  scope :active, -> { where(ended_at: nil) }

  def active?
    ended_at.nil?
  end

  private

  def host_is_not_monitored
    return if HostMonitoring.active.find_by(host: host).blank?

    errors.add(:host, HOST_IS_ALREADY_TAKEN_ERROR)
  end
end
