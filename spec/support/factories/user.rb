FactoryGirl.define do
  sequence :unique_email do |n|
    "owahab+postman-#{DateTime.now.to_i}-#{n}@gmail.com"
  end

  factory :user do
    email { generate(:unique_email) }
    name 'John Doe'
  end
  
  factory :user1, class: User do
    email { generate(:unique_email) }
    name 'Jane Smith'
  end
  
  factory :user2, class: User do
    email { generate(:unique_email) }
    name 'Jack Foe'
  end
end