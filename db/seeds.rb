admin = User.create!(
  email: "admin@example.com",
  password: "password",
  role: "admin"
)

user = User.create!(
  email: "user@example.com",
  password: "password",
  role: "user"
)

team = Team.create!(name: "Development Team", description: "Main development team")
team.memberships.create!(user: admin, role: "owner")
team.memberships.create!(user: user, role: "member")

project = team.projects.create!(
  name: "Website Redesign",
  description: "Redesign the company website with modern UI/UX",
  status: "in_progress",
  user: admin,
  deadline: Date.today + 30
)

Task.create!([
  { title: "Design mockups", description: "Create Figma mockups for all pages", status: "done", priority: "high", project: project, user: admin },
  { title: "Set up CI/CD", description: "Configure GitHub Actions for deployment", status: "in_progress", priority: "medium", project: project, user: user },
  { title: "Write tests", description: "Add RSpec tests for all models", status: "todo", priority: "medium", project: project, user: user },
  { title: "Deploy to production", description: "Deploy the final version to Render", status: "todo", priority: "high", project: project, user: admin }
])

puts "Seeded admin (admin@example.com), user (user@example.com), 1 team, 1 project, 4 tasks"
