FactoryGirl.define do
  factory :delivery, class: Notify::Delivery do
    message
    receiver
  end
end
