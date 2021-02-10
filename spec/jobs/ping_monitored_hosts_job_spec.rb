# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingMonitoredHostsJob, type: :job do
  describe '.perform_now' do
    subject { described_class.perform_now }

    let!(:ended_monitoring) { create :host_monitoring, host: '8.8.8.8', ended_at: 1.day.ago, created_at: 10.days.ago }
    let!(:active_monitoring) { create :host_monitoring, host: '8.8.8.8', ended_at: nil }
    let!(:another_active_monitoring) { create :host_monitoring, host: '7.7.7.7', ended_at: nil }
    let!(:another_ended_monitoring) do
      create :host_monitoring, host: '127.0.0.1', ended_at: 2.days.ago, created_at: 1.month.ago
    end

    let(:delayed_job) { instance_double ActiveJob::ConfiguredJob }
    it 'reschedules itself' do
      expect(described_class).to receive(:set) { delayed_job }
      expect(delayed_job).to receive(:perform_later)

      subject
    end

    it 'schedules pinging for active monitorings only' do
      expect(PingHostJob).to receive(:perform_later).with('8.8.8.8').once
      expect(PingHostJob).to receive(:perform_later).with('7.7.7.7').once
      expect(PingHostJob).not_to receive(:perform_later).with('7.7.7.7')

      subject
    end
  end
end
