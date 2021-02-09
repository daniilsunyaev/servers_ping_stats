# frozen_string_literal: true

FactoryBot.define do
  factory :ping_result do
    host { '8.8.8.8' }
    port { 80 }
  end
end
