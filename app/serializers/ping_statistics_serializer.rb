# frozen_string_literal: true

class PingStatisticsSerializer < ApplicationSerializer
  attributes :min, :max, :mean, :median, :standard_deviation, :loss_percentage
end
