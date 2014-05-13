# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

25.times do
  Project.create(
    title: Faker::Company.bs,
    description: "#{Faker::Company.bs} from #{Faker::Company.catch_phrase} #{Faker::Company.suffix}",
    user_id: 1
  )
end
