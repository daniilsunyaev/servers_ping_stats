# frozen_string_literal: true

require 'rails_helper'

describe HostMonitorings::StopsController, type: :controller do
  describe '#create' do
    subject { post :create, params: params }

    context 'without params' do
      let(:params) { {} }

      it 'requires parameters to be set' do
        subject

        expect(response.status).to eq 422

        json_body = JSON.parse(response.body)

        expect(json_body['errors'].keys).to match_array(%w[host])
      end
    end

    context 'with host specified' do
      let(:params) do
        { host: '8.8.8.8' }
      end

      it 'fails to stop non-existant monitoring' do
        subject

        expect(response.status).to eq 422

        json_body = JSON.parse(response.body)

        expect(json_body['errors']['host']).not_to be_blank
      end

      context 'when host already monitored' do
        let!(:host_monitoring) { create :host_monitoring, host: '8.8.8.8' }

        it 'stop the host monitoring' do
          expect { subject }.to change { host_monitoring.reload.ended_at }.from(nil)
          expect(response.status).to eq 200
        end
      end
    end
  end
end
