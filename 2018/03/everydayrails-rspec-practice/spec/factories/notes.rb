FactoryGirl.define do
  factory :note do
    message "My importnat note."
    association :project
    user { project.owner }
  end
end
