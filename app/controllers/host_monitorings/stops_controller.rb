# frozen_string_literal: true

module HostMonitorings
  class StopsController < ActionController::API
    def create
      if stop_monitoring.success?
        render json: host_monitoring, status: 200
      else
        render json: { errors: { host: stop_monitoring.error } }, status: 422
      end
    end

    private

    def stop_monitoring
      HostMonitorings::StopCommand.call(host_monitoring: host_monitoring)
    end

    def host_monitoring
      @host_monitoring ||= HostMonitoring.active.find_by(host_monitoring_params)
    end

    def host_monitoring_params
      params.permit(:host)
    end
  end
end
