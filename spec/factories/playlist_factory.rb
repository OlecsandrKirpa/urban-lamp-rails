# frozen_string_literal: true

FactoryBot.define do
  factory :playlist do
    visibility { 'public' }

    trait :private do
      visibility { 'private' }
    end

    trait :public do
      visibility { 'public' }
    end

    trait :with_name do
      name { Faker::Music::RockBand.name }
    end

    trait :with_notes do
      notes { Faker::Lorem.paragraph }
    end

    trait :with_user do
      user { create(:user) }
    end

    trait :with_videos do
      videos { create_list(:video, 3) }
    end
  end
end
