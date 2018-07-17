FactoryBot.define do
  factory :note do
    message 'New note'
    association :project # belongs_to
    user { project.owner } # use the same user
  end
end
