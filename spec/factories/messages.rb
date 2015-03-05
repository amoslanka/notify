FactoryGirl.define do
  factory :message, class: Notify::Message do
    strategy :foo
    deliver_via [:action_mailer]
  end
end
