FactoryGirl.define do
  factory :delivery, class: Notification::Delivery do
    notification
    receiver
  end
end
