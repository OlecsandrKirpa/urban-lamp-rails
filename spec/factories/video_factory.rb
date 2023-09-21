# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    url { Faker::Internet.url }
    download_jid { nil }
    downloader { nil }
    downloader_args { nil }

    trait :with_playlist do
      playlist { create(:playlist, :with_user) }
    end

    trait :with_user do
      user { create(:user) }
    end

    trait :with_download_jid do
      download_jid { generate(:download_jid) }
    end
  end

  sequence :download_jid do |n|
    "download_jid_-#{SecureRandom.uuid}-#{n}"
  end
end
