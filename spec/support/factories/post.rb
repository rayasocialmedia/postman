FactoryGirl.define do
  factory :post do
    title 'The Quick Brown Fox Jumps Over The Lazy Dog'
    user
  end

  factory :post1, class: Post do
    title 'Another post: The Quick Brown Fox Jumps Over The Lazy Dog'
    user
  end
end