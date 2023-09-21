# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Configs' do
  context 'should have this configs' do
    context 'max_download_attempts' do
      subject { Config.max_download_attempts }

      it { should_not be_nil }
      it { should be_a(Integer) }
      it { should be > 0 }
      it { should be < 1_000 }
    end
  end
end
