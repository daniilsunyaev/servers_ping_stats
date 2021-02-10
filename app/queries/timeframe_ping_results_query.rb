# frozen_string_literal: true

class TimeframePingResultsQuery
  attr_reader :relation, :host, :port, :timeframe_starts_at, :timeframe_ends_at

  def initialize(relation = PingResult.all, host:, port: nil, timeframe_starts_at:, timeframe_ends_at: Time.current)
    @relation = relation
    @host = host
    @port = port
    @timeframe_starts_at = timeframe_starts_at
    @timeframe_ends_at = timeframe_ends_at
  end

  def query
    relation
      .where(host: host, port: port, created_at: timeframe_starts_at..timeframe_ends_at)
  end
end
