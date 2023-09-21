# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { generate(:user_email) }
    password { Faker::Internet.password }
    username { Faker::Internet.username }
  end

  sequence :user_email do |n|
    Faker::Internet.email.gsub(/@/, "#{n}@")
  end
end
