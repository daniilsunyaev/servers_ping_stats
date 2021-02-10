# frozen_string_literal: true

module HostMonitorings
  class StopCommand
    include Interactor

    MONITORING_FINISHED_ERROR = 'Host monitoring already stoped'
    MONITORING_NOT_STARTED_ERROR = 'Host monitoring not started, nothing to stop'

    delegate :host_monitoring, to: :context

    def call
      context.fail!(error: MONITORING_NOT_STARTED_ERROR) if host_monitoring.blank? || !host_monitoring.persisted?
      context.fail!(error: MONITORING_FINISHED_ERROR) if host_monitoring.ended_at.present?

      host_monitoring.update(ended_at: Time.current)
    end
  end
end
