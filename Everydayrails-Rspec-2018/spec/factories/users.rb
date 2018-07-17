FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name 'Tom'
    last_name 'Jones'
    sequence(:email) { |i| "test#{i}@example.com"}
    password 'password'
  end
end
