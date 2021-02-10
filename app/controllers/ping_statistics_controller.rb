# frozen_string_literal: true

class PingStatisticsController < ActionController::API
  NOT_FOUND_ERROR = "can't find any ping statistics over specified period"

  def show
    if !prepared_params.valid?
      render json: { errors: prepared_params.errors }, status: 422
    elsif ping_statistics.blank?
      render json: { errors: { base: NOT_FOUND_ERROR } }, status: 404
    else
      render json: ping_statistics
    end
  end

  private

  def ping_statistics
    @ping_statistics ||= PingStatistics.new(ping_results)
  end

  def ping_results
    @ping_results ||= TimeframePingResultsQuery.new(**prepared_params.to_h).query
  end

  def prepared_params
    @prepared_params ||= PingStatisticsRequestParams.new(statistics_params)
  end

  def statistics_params
    params.permit(:host, :timeframe_starts_at, :timeframe_ends_at)
  end
end
