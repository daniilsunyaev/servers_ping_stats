# frozen_string_literal: true

require 'rails_helper'

describe HostMonitoring, type: :model do
  it { is_expected.to validate_presence_of(:host) }
end
