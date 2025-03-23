FactoryBot.define do
  factory :user do
    # name { Faker::FunnyName.name }
    email_address { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    # role { "user" }

    trait :with_accounts do
      transient do
        accounts_count { 1 }
      end

      after(:create) do |user, evaluator|
        create_list(:account, evaluator.accounts_count, users: [user])
      end
    end
  end
end