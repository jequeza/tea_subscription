FactoryBot.define do
  factory :tea do
    title { Faker::Tea.variety }
    description { Faker::Movie.quote }
    temperature { Faker::Number.between(from: 80, to: 100) }
    brew_time { Faker::Number.between(from: 1, to: 12) }
  end
end
