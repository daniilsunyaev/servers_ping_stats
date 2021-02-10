# frozen_string_literal: true

class HostMonitoringsController < ActionController::API
  def create
    if host_monitoring.save
      render json: host_monitoring, status: 201
    else
      render json: { errors: host_monitoring.errors }, status: 422
    end
  end

  private

  def host_monitoring
    @host_monitoring ||= HostMonitoring.new(host_monitoring_params)
  end

  def host_monitoring_params
    params.permit(:host)
  end
end
