# frozen_string_literal: true

class PingMonitoredHostsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  MONITORING_PERIOD = 30.seconds

  def perform
    PingMonitoredHostsJob.set(wait: MONITORING_PERIOD).perform_later

    HostMonitoring.active.find_each do |host_monitoring|
      PingHostJob.perform_later(host_monitoring.host)
    end
  end
end
