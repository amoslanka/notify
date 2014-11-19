FactoryGirl.define do
  # The user class comes from our dummy app.
  factory :receiver, class: "User" do
    email 'foo@bar.com'
  end
end
