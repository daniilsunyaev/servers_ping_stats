# frozen_string_literal: true

FactoryBot.define do
  factory :host_monitoring do
    host { '8.8.8.8' }
  end
end
