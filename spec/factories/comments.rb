FactoryBot.define do
  factory :comment do
    body { "MyText" }
    user { nil }
    task { nil }
  end
end
