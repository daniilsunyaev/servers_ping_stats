# frozen_string_literal: true

require 'rails_helper'

describe PingStatisticsController, type: :controller do
  describe '#show' do
    subject { get :show, params: params }

    context 'without params' do
      let(:params) { {} }

      it 'requires parameters to be set' do
        subject

        expect(response.status).to eq 422

        json_body = JSON.parse(response.body)

        expect(json_body['errors'].keys).to match_array(%w[host timeframe_starts_at])
      end
    end

    context 'with host  specified' do
      let(:params) do
        { host: '8.8.8.8' }
      end

      it 'requires parameters to be set' do
        subject

        expect(response.status).to eq 422

        json_body = JSON.parse(response.body)

        expect(json_body['errors'].keys).to match_array ['timeframe_starts_at']
      end

      context 'with timeframe specified' do
        let(:timeframe_starts_at) { 1.hour.ago }
        let(:timeframe_ends_at) { 30.minutes.ago }

        before do
          params.merge!(timeframe_starts_at: timeframe_starts_at.to_i, timeframe_ends_at: timeframe_ends_at.to_i)
        end

        it 'does not finds anything' do
          subject

          expect(response.status).to eq 404

          json_body = JSON.parse(response.body)

          expect(json_body['errors'].keys).to match_array ['base']
        end

        context 'with some ping results existing' do
          let!(:ping_result) do
            create :ping_result,
                   host: '8.8.8.8',
                   duration: 0.5,
                   created_at: 45.minutes.ago
          end

          let!(:failed_ping_result) do
            create :ping_result,
                   host: '8.8.8.8',
                   duration: nil,
                   created_at: 45.minutes.ago
          end

          let!(:another_ping_result) do
            create :ping_result,
                   host: '1.1.1.1',
                   duration: 0.05,
                   created_at: 45.minutes.ago
          end

          it 'returns ping stats over specified interval' do
            subject

            expect(response.status).to eq 200

            json_body = JSON.parse(response.body)

            expect(json_body['mean']).to eq 0.5
            expect(json_body['min']).to eq 0.5
            expect(json_body['max']).to eq 0.5
            expect(json_body['median']).to eq 0.5
            expect(json_body['standard_deviation']).to eq 0.0
            expect(json_body['loss_percentage']).to eq 50.0
          end
        end
      end
    end
  end
end
