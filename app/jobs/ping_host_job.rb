# frozen_string_literal: true

class PingHostJob < ApplicationJob
  TIMEOUT_SECONDS = 5

  queue_as :default

  def perform(host)
    # we can ignore port, it can be set to nil
    ping_instance = Net::Ping::External.new(host, nil, TIMEOUT_SECONDS)
    ping_instance.ping

    PingResult.create(
      host: host, duration: ping_instance.duration, error: ping_instance.exception, warning: ping_instance.warning
    )
  end
end
