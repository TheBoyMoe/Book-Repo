FactoryBot.define do
  factory :user do
    first_name 'Tom'
    last_name 'Smith'
		# create unique email address for each user
		sequence(:email) {|i| "testuser_#{i}@example.com"}
    password 'password'
  end
end
