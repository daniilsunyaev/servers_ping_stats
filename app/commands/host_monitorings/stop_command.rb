module HostMonitorings
  class StopCommand
    include Interactor

    RECORD_NOT_PERSISTED_ERROR = 'Record is not persisted'
    MONITORING_FINISHED_ERROR = 'Host monitoring already stoped'

    delegate :host_monitoring, to: :context

    def call
      context.fail!(error: RECORD_NOT_PERSISTED_ERROR) unless host_monitoring.persisted?
      context.fail!(error: MONITORING_FINISHED_ERROR) if host_monitoring.ended_at.present?

      host_monitoring.update(ended_at: Time.current)
    end
  end
end
