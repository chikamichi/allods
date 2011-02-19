User.blueprint do
  email    { Faker::Internet.email }
  password { 'test12' }
end
