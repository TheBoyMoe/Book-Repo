FactoryBot.define do
  factory :note do
    message "Dummy content ........."
		association :project
		association :user
  end
end
