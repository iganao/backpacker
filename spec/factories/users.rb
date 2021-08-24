FactoryBot.define do
  factory :user do
    nickname              {'test'}
    email                 {'test@test'}
    password              {'a00000'}
    password_confirmation {password}
  end
end