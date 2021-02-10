# frozen_string_literal: true

require 'rails_helper'

describe HostMonitorings::StopCommand do
  describe '.call' do
    subject { described_class.call(host_monitoring: host_monitoring) }

    context 'with active host monitoring' do
      let(:host_monitoring) { create :host_monitoring }

      it 'executes successfuly' do
        subject

        expect(subject.success?).to eq true
      end

      it 'stops active monitoring' do
        expect { subject }.to change(host_monitoring, :ended_at).from(nil)
      end
    end

    context 'with finished host monitoring' do
      let(:host_monitoring) { create :host_monitoring, ended_at: 1.day.ago }

      it 'does not execute successfuly' do
        subject

        expect(subject.success?).to eq false
      end

      it 'does not change monitoring' do
        expect { subject }.not_to change(host_monitoring, :updated_at)
      end
    end

    context 'with non-persisted host monitoring' do
      let(:host_monitoring) { build :host_monitoring, ended_at: 1.day.ago }

      it 'does not execute successfuly' do
        subject

        expect(subject.success?).to eq false
      end

      it 'does not change monitoring count' do
        expect { subject }.not_to change(HostMonitoring, :count)
      end
    end

    context 'when trying ot stop non-monitored host' do
      let(:host_monitoring) { nil }

      it 'does not execute successfuly' do
        subject

        expect(subject.success?).to eq false
      end

      it 'does not change monitoring count' do
        expect { subject }.not_to change(HostMonitoring, :count)
      end
    end
  end
end
