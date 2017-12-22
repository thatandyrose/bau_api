FactoryBot.define do
  factory :rota_assignment do
    slot 'am'
    developer
    date Date.today
  end
end
