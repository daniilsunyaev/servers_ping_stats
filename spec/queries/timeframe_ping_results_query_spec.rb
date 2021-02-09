# frozen_string_literal: true

require 'rails_helper'

describe TimeframePingResultsQuery do
  let(:host) { '8.8.8.8' }
  let(:port) { 80 }
  let(:options) { {} }

  describe '#initialize' do
    subject { described_class.new(**options) }

    it 'tells that not all arguments are proveded' do
      expect { subject }.to raise_error ArgumentError
    end

    context 'with host and port specified' do
      before do
        options.merge!(host: host, port: port)
      end

      it 'tells that not all arguments are proveded' do
        expect { subject }.to raise_error ArgumentError
      end

      context 'with timeframe_starts_at specified' do
        before do
          options.merge!(timeframe_starts_at: 1.hour.ago)
        end

        it 'correctly instanciates an object' do
          expect { subject }.not_to raise_error
        end
      end
    end
  end

  describe '#query' do
    subject { described_class.new(**options).query }

    context 'with ping results set in the database' do
      let(:another_host) { '127.0.0.1' }
      let(:another_port) { 3000 }

      let!(:host_ping_result_1) do
        create :ping_result, created_at: 13.hours.ago, host: host, port: port
      end

      let!(:host_ping_result_2) do
        create :ping_result, created_at: 11.hours.ago, host: host, port: port
      end

      let!(:another_host_ping_result) do
        create :ping_result, created_at: 8.hours.ago, host: another_host, port: port
      end

      let!(:another_port_ping_result) do
        create :ping_result, created_at: 7.hours.ago, host: host, port: another_port
      end

      let!(:host_ping_result_3) do
        create :ping_result, created_at: 6.hours.ago, host: host, port: port
      end

      let!(:host_ping_result_4) do
        create :ping_result, created_at: 4.hours.ago, host: host, port: port
      end

      context 'with existing port/host/timeframe specified' do
        before do
          options.merge!({
                           host: host,
                           port: port,
                           timeframe_starts_at: 12.hours.ago,
                           timeframe_ends_at: 5.hours.ago
                         })
        end

        it 'returns ping results for given host and port in a given timeframe' do
          expect(subject).to match_array [host_ping_result_2, host_ping_result_3]
        end
      end

      context 'with non-existing port/host/timeframe specified' do
        before do
          options.merge!({
                           host: '0.0.0.0',
                           port: port,
                           timeframe_starts_at: 12.hours.ago,
                           timeframe_ends_at: 5.hours.ago
                         })
        end

        it 'returns nothing' do
          expect(subject).to match_array []
        end
      end
    end
  end
end
