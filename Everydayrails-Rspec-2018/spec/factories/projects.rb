FactoryBot.define do
  factory :project do
    sequence(:name) { |i| "Project #{i}"}
    description "Test project"
    due_on 1.week.from_now
    association :owner

    # DRY the project factories using 'inheritance'
    # the objects need to nested within the object they inherit from
    # only define the attributes which change
    factory :project_due_yesterday do
      due_on 1.day.ago
    end
    
    factory :project_due_today do
      due_on Date.today
    end
    
    factory :project_due_tomorrow do
      due_on 1.day.from_now
    end

    # DRY the project factories using 'traits'
    trait :due_yesterday do
      due_on 1.day.ago
    end
    
    trait :due_today do
      due_on Date.today
    end
    
    trait :due_tomorrow do
      due_on 1.day.from_now
    end

    # use a 'callback' to create a list of notes on the project
    # following it's creation
    trait :with_notes do
      after(:create) { |project| create_list(:note, 5, project: project)}
    end

    trait :with_tasks do
      after(:create) { |project| create_list(:task, 5, project: project)}
    end
  end

  # create multiple factories of the same model
  # factory :project_due_yesterday, class: Project do
  #   sequence(:name) { |n| "Test Project #{n}" }
  #   description "Sample project for testing purposes"
  #   due_on 1.day.ago
  #   association :owner
  # end
  
  # factory :project_due_today, class: Project do
  #   sequence(:name) { |n| "Test Project #{n}" }
  #   description "Sample project for testing purposes"
  #   due_on Date.today
  #   association :owner
  # end
  
  # factory :project_due_tomorrow, class: Project do
  #   sequence(:name) { |n| "Test Project #{n}" }
  #   description "Sample project for testing purposes"
  #   due_on 1.day.from_now
  #   association :owner
  # end
end
