FactoryBot.define do
  factory :account do
    name { Faker::Team.name }
  end
end 