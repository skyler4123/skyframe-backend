# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'faker'

# Clear existing data in development
if Rails.env.development?
  puts "🗑️  Clearing existing data..."
  User.destroy_all
  puts "✅ Data cleared!"
end

puts "🌱 Starting to seed users..."

# Create admin user
admin_user = User.find_or_create_by(email: 'admin@example.com') do |user|
  user.password = 'AdminPassword123!'
  user.verified = true
end

puts "👤 Created admin user: #{admin_user.email}"

# Create test users
test_users = [
  { email: 'john.doe@example.com', verified: true },
  { email: 'jane.smith@example.com', verified: true },
  { email: 'unverified@example.com', verified: false }
]

test_users.each do |user_attrs|
  user = User.find_or_create_by(email: user_attrs[:email]) do |u|
    u.password = 'TestPassword123!'
    u.verified = user_attrs[:verified]
  end
  puts "👤 Created test user: #{user.email} (verified: #{user.verified})"
end

# Create random users with Faker
puts "🎲 Creating random users with Faker..."

25.times do |i|
  email = Faker::Internet.unique.email
  
  # Ensure email doesn't already exist
  next if User.exists?(email: email)
  
  user = User.create!(
    email: email,
    password: 'FakerPassword123!',
    verified: [true, false].sample # Randomly verified or not
  )
  
  print "👤 Created user #{i + 1}: #{user.email} (verified: #{user.verified})\n" if (i + 1) % 5 == 0
end

# Create users with specific patterns for testing
puts "🧪 Creating users for testing scenarios..."

# Users with different email domains
domains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'company.com', 'startup.io']
domains.each do |domain|
  email = "#{Faker::Internet.username}@#{domain}"
  next if User.exists?(email: email)
  
  User.create!(
    email: email,
    password: 'DomainTest123!',
    verified: true
  )
  puts "📧 Created user with #{domain}: #{email}"
end

# Create users with edge cases
edge_case_emails = [
  'user+tag@example.com',
  'user.with.dots@example.com',
  'user_with_underscores@example.com'
]

edge_case_emails.each do |email|
  next if User.exists?(email: email)
  
  User.create!(
    email: email,
    password: 'EdgeCase123!',
    verified: true
  )
  puts "🔍 Created edge case user: #{email}"
end

total_users = User.count
verified_users = User.where(verified: true).count
unverified_users = User.where(verified: false).count

puts "\n✨ Seeding completed!"
puts "📊 Summary:"
puts "   Total users: #{total_users}"
puts "   Verified users: #{verified_users}"
puts "   Unverified users: #{unverified_users}"
puts "🎉 Happy coding!"
