# frozen_string_literal: true

require 'rails_helper'

describe HostMonitoring, type: :model do
  it { is_expected.to validate_presence_of(:host) }

  context 'with several existing monitorings' do
    let!(:host_monitoring) { create :host_monitoring, host: '8.8.8.8' }
    let!(:finished_host_monitoring) { create :host_monitoring, host: '8.8.8.8', ended_at: 1.day.ago }
    let!(:another_finished_host_monitoring) { create :host_monitoring, host: '9.9.9.9', ended_at: 1.day.ago }

    it 'does not allow to pick existing active host' do
      expect(described_class.new(host: '8.8.8.8').valid?).to eq false
    end

    it 'does not allows to pick existing disabled host' do
      expect(described_class.new(host: '9.9.9.9').valid?).to eq true
    end
  end
end
