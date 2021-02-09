require 'rails_helper'

describe HostMonitoring, type: :model do
  it { is_expected.to validate_presence_of(:host) }
  it { is_expected.to validate_presence_of(:port) }
end
