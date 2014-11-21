FactoryGirl.define do
  factory :notification do
    type :foo
    deliver_via [:action_mailer]
  end
end
