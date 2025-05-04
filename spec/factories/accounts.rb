FactoryBot.define do
  factory :account do
    name { Faker::Team.name }
    slug { Faker::Internet.slug }
  end
end
