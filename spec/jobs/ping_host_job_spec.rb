# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingHostJob, type: :job do
  describe '.perform_now' do
    subject { described_class.perform_now(host) }

    let(:host) { '8.8.8.8' }

    before do
      allow(Net::Ping::External).to receive(:new).with(host) { external_ping }
    end

    context 'when host is available' do
      let(:external_ping) do
        instance_double(
          Net::Ping::External,
          ping: true,
          duration: 0.024,
          host: host,
          exception: nil,
          warning: 'some warning message'
        )
      end

      it 'saves ping result' do
        expect { subject }.to change(PingResult, :count).by(1)
        expect(PingResult.last.attributes.slice(*%w[duration host error warning]))
          .to eq({
            duration: 0.024, host: host, error: nil, warning: 'some warning message'
          }.stringify_keys)
      end
    end

    context 'when host is not available' do
      let(:external_ping) do
        instance_double(
          Net::Ping::External,
          ping: false,
          duration: nil,
          host: host,
          exception: 'some error message',
          warning: nil
        )
      end

      it 'saves ping result' do
        expect { subject }.to change(PingResult, :count).by(1)
        expect(PingResult.last.attributes.slice(*%w[duration host error warning]))
          .to eq({
            duration: nil, host: host, error: 'some error message', warning: nil
          }.stringify_keys)
      end
    end
  end
end
