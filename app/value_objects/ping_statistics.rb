# frozen_string_literal: true

require 'descriptive_statistics/safe'

class PingStatistics
  attr_reader :relation

  def initialize(relation)
    @relation = relation
  end

  def mean
    successful_durations_data.mean.round(3)
  end

  def min
    successful_durations_data.min.round(3)
  end

  def max
    successful_durations_data.max.round(3)
  end

  def median
    successful_durations_data.median.round(3)
  end

  def standard_deviation
    successful_durations_data.standard_deviation.round(3)
  end

  def loss_percentage
    (100.0 * (1 - successful_durations.size.to_f / ping_durations.size)).round(3)
  end

  private

  def successful_durations_data
    @successful_durations_data ||= DescriptiveStatistics::Stats.new(successful_durations)
  end

  def successful_durations
    @successful_durations ||= ping_durations.compact
  end

  def ping_durations
    @ping_durations ||= relation.pluck(:duration)
  end
end
