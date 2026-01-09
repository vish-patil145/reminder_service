# Clear existing data (optional - uncomment if you want to start fresh each time)
# Task.destroy_all
# User.destroy_all

# Find or create users
user1 = User.find_or_create_by!(email_address: 'you@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end

user2 = User.find_or_create_by!(email_address: 'manish@yopmail.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end

puts "Users ready: #{user1.email_address}, #{user2.email_address}"

# Clear existing tasks for these users to avoid duplicates
Task.where(creator: [ user1, user2 ]).destroy_all

# Create sample tasks
tasks = Task.create!([
  {
    title: 'Call the Driver',
    description: 'Reminder to call the driver at 10:35 AM',
    scheduled_at: Time.current.change(hour: 10, min: 35),
    creator: user1,
    assignee: user1,
    status: 'pending'
  },
  {
    title: 'Fill Water in Tank',
    description: 'Remember to fill water in the tank',
    scheduled_at: Time.current.change(hour: 14, min: 0),
    creator: user1,
    assignee: user2,
    status: 'pending'
  },
  {
    title: 'Visit Contractor House',
    description: 'Visit contractor house for some work discussion',
    scheduled_at: Time.current.change(hour: 16, min: 30),
    creator: user1,
    assignee: user1,
    status: 'pending'
  },
  {
    title: 'Shop Item Pickup',
    description: 'Visit the shop to pickup ordered items',
    scheduled_at: Time.current.change(hour: 18, min: 0),
    creator: user1,
    assignee: user2,
    status: 'pending'
  }
])

puts "✅ Seed completed successfully!"
puts "Created #{User.count} users and #{Task.count} tasks"
puts "\nYou can login with:"
puts "  Email: you@example.com"
puts "  Password: password"
puts "\n  or"
puts "\n  Email: manish@yopmail.com"
puts "  Password: password"
