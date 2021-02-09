# frozen_string_literal: true

require 'rails_helper'

describe PingStatisticsRequestParams do
  let(:value_object) { described_class.new(params) }
  let(:params) { {} }

  describe '#valid?' do
    subject { value_object.valid? }

    it { is_expected.to eq false }

    it 'adds error message' do
      subject

      expect(value_object.errors).not_to be_blank
    end

    context 'when host and port are specified' do
      before do
        params.merge!(host: '0.0.0.0', port: 30)
      end

      it { is_expected.to eq false }

      it 'adds error message' do
        subject

        expect(value_object.errors).not_to be_blank
      end

      context 'when timeframe is specified' do
        before do
          params.merge!(timeframe_starts_at: '1612888444')
        end

        it { is_expected.to eq true }

        it 'leaves errors blank' do
          subject

          expect(value_object.errors).to be_blank
        end
      end
    end

    context 'when timeframe is specified' do
      before do
        params.merge!(timeframe_starts_at: '1612888444')
      end

      it { is_expected.to eq false }

      it 'adds error message' do
        subject

        expect(value_object.errors).not_to be_blank
      end
    end
  end

  describe '#to_h' do
    subject { value_object.to_h }

    it 'returns blank parameters' do
      expect(subject).to eq({})
    end

    context 'with valid parameters' do
      before do
        params.merge!(host: '8.8.8.8', port: 80, timeframe_starts_at: '1612888444')
      end

      it 'sets parameters' do
        expect(subject.slice(:host, :port)).to eq({ host: '8.8.8.8', port: 80 })
        expect(subject[:timeframe_starts_at].class).to eq DateTime
        expect(subject[:timeframe_ends_at].class).to eq DateTime
      end
    end
  end
end
