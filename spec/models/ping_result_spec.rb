# frozen_string_literal: true

require 'rails_helper'

describe PingResult, type: :model do
  it { is_expected.to validate_presence_of(:host) }
  it { is_expected.to validate_presence_of(:port) }
end
