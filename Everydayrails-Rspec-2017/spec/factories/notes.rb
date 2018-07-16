FactoryBot.define do
  factory :note do
    message "Dummy content ........."
		association :project
		user {project.owner} # use the same user as created for project
  end
end
