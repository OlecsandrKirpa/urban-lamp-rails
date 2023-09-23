# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { generate(:user_email) }
    password { Faker::Internet.password }
    username { generate(:user_username) }
  end

  sequence :user_email do |n|
    Faker::Internet.email.gsub(/@/, "#{n}@")
  end

  sequence :user_username do |n|
    "#{Faker::Internet.username}-#{n}-#{SecureRandom.hex(4)}"
  end
end
