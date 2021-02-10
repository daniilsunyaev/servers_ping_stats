# frozen_string_literal: true

require 'rails_helper'

describe HostMonitoringsController, type: :controller do
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

      it 'creates a host monitoring' do
        subject

        expect(response.status).to eq 201

        json_body = JSON.parse(response.body)

        expect(json_body['host']).to eq '8.8.8.8'
        expect(HostMonitoring.last.host).to eq '8.8.8.8'
      end

      context 'when host already monitored' do
        let!(:host_monitoring) { create :host_monitoring, host: '8.8.8.8' }

        it 'fails to create a host monitoring' do
          subject

          expect(response.status).to eq 422

          json_body = JSON.parse(response.body)

          expect(json_body['errors']['host']).not_to be_blank
        end
      end
    end
  end
end
