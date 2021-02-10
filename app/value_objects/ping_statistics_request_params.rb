# frozen_string_literal: true

class PingStatisticsRequestParams
  attr_reader :action_controller_params, :errors

  BLANK_ERROR = "Can't be blank"
  TOO_LONG_TIMEFRAME_ERROR = 'Specified timeframe should less than 30 days'

  REQUIRED_PARAMS = %i[host timeframe_starts_at].freeze
  MAX_TIMEFRAME = 30.days

  def initialize(action_controller_params)
    @action_controller_params = action_controller_params
    @errors = {}
  end

  def valid?
    validate_required_params_presence
    validate_max_time_range

    errors.blank?
  end

  def to_h
    return {} unless valid?

    {
      host: host,
      port: port,
      timeframe_starts_at: timeframe_starts_at,
      timeframe_ends_at: timeframe_ends_at
    }
  end

  private

  def validate_required_params_presence
    REQUIRED_PARAMS.each do |required_param|
      errors[required_param] = BLANK_ERROR if send(required_param).blank?
    end
  end

  def validate_max_time_range
    return if timeframe_starts_at.blank?
    return if timeframe_ends_at - timeframe_starts_at < MAX_TIMEFRAME

    errors[:base] = TOO_LONG_TIMEFRAME_ERROR
  end

  def host
    action_controller_params[:host]
  end

  def port
    action_controller_params[:port]
  end

  def timeframe_starts_at
    return unless action_controller_params.key?(:timeframe_starts_at)

    DateTime.strptime(action_controller_params[:timeframe_starts_at], '%s')
  end

  def timeframe_ends_at
    if action_controller_params.key?(:timeframe_ends_at)
      DateTime.strptime(action_controller_params[:timeframe_ends_at], '%s')
    else
      DateTime.current
    end
  end
end
