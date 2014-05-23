# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Category.create(
    category: 'Web',
    description: 'Projects involving web design, development, and strategy'
)


Category.create(
    category: 'Revenue',
    description: 'Projects involving revenue strategy'
)

Category.create(
    category: 'Marketing',
    description: 'Projects involving marketing strategy and execution'
)

Category.create(
    category: 'Legal',
    description: 'Projects involving legal help'
)

Cause.create(
    cause: 'Animal services',
    description: 'Projects involving animals'
)

Cause.create(
    cause: 'Professional associations',
    description: 'Projects involving industry/professional associations'
)

Cause.create(
    cause: 'Social and community',
    description: 'Projects involving helping social- and community-based activities'
)

Cause.create(
    cause: 'Arts and culture',
    description: 'Projects involving arts and culture'
)

Cause.create(
    cause: 'Religious services',
    description: 'Projects involving religious services'
)

Location.create(
    location: 'Downtown Toronto',
    description: 'Financial district and around'
)

Location.create(
    location: 'Scarborough',
    description: 'East of DVP'
)


Location.create(
    location: 'Etobicoke',
    description: 'West of Toronto'
)

Location.create(
    location: 'Mississauga',
    description: 'Mississauga'
)

Location.create(
    location: 'North York',
    description: 'North of Toronto'
)


200.times do
  Project.create(
    title: Faker::Company.bs,
    description: "#{Faker::Company.bs} from #{Faker::Company.catch_phrase} #{Faker::Company.suffix}",
    user_id: 1,
    category_id: (1..4).to_a.sample,
    cause_id: (1..5).to_a.sample,
    location_id: (1..5).to_a.sample,
    statuses: 'active',
    number_of_positions: (1..3).to_a.sample,
    deliverable: "#{Faker::Company.bs}",
    overseer: "#{Faker::Name.first_name} #{Faker::Name.last_name} #{Faker::Name.suffix}",
    why_we_need_this: "#{Faker::Company.bs}",
    perks: "#{Faker::Company.bs}",
    requirements: "#{Faker::Company.bs}"
  )
end
