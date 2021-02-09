# frozen_string_literal: true

require 'rails_helper'

describe PingStatistics do
  let!(:ping_result_1) { create :ping_result, duration: 3.2 }
  let!(:ping_result_2) { create :ping_result, duration: 1.2 }
  let!(:ping_result_3) { create :ping_result, duration: 0.4 }
  let!(:ping_result_4) { create :ping_result, duration: nil, error: 'timeout' }
  let!(:ping_result_5) { create :ping_result, duration: 0.2 }
  let!(:ping_result_6) { create :ping_result, duration: nil, error: 'timeout' }

  let(:value_object) { described_class.new(PingResult.all) }

  describe '#mean' do
    subject { value_object.mean }

    it 'returns mean average duration across success pings' do
      expect(subject).to eq 1.25
    end
  end

  describe '#min' do
    subject { value_object.min }

    it 'returns minimum value' do
      expect(subject).to eq 0.2
    end
  end

  describe '#max' do
    subject { value_object.max }

    it 'returns maximum value' do
      expect(subject).to eq 3.2
    end
  end

  describe '#median' do
    subject { value_object.median }

    it 'returns median duration across success pings' do
      expect(subject).to eq 0.8
    end
  end

  describe '#standard_deviation' do
    subject { value_object.standard_deviation }

    it 'returns standard deviation of success pings' do
      expect(subject).to eq 1.186
    end
  end

  describe '#loss_percentage' do
    subject { value_object.loss_percentage }

    it 'returns percenage of lost packets' do
      expect(subject).to eq 33.333
    end
  end
end
