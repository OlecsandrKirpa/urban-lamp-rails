# frozen_string_literal: true

RSpec.shared_context 'faker utilities' do
  let(:faker) { Faker::Lorem }
  let(:faker_unique) { Faker::Lorem.unique }

  def faker_unique_reset
    faker_unique.reset
  end

  def faker_unique_string(number = 10)
    faker.characters(number: number)
  end
end
