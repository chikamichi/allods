Character.blueprint do
  association :user

  nickname { Faker::Name.name }
  level { rand(42) }
end
