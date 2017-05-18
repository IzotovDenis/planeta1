FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    name "DENISKA"
    email
    password "12345678"
    password_confirmation "12345678"
    role "user"
  end
end