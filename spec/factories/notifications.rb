FactoryGirl.define do
  factory :notification do
    strategy :foo
    deliver_via [:action_mailer]
  end
end
