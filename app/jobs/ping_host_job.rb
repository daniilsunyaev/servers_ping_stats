# frozen_string_literal: true

class PingHostJob < ApplicationJob
  queue_as :default

  def perform(host)
    ping_instance = Net::Ping::External.new(host)
    ping_instance.ping

    PingResult.create(
      host: host, duration: ping_instance.duration, error: ping_instance.exception, warning: ping_instance.warning
    )
  end
end
