# Rails Project Manager

A real-time team collaboration tool built with Rails 8 and Hotwire, featuring projects, tasks, and live comments.

**[Live Demo](https://rails-pm.onrender.com)**

## Highlights

- **Teams** — Create teams with multi-role permissions (owner/admin/member)
- **Projects** — Status tracking (planning/in_progress/completed)
- **Tasks** — Priority levels, assignment, due dates
- **Real-time comments** — Turbo Streams for live updates
- **Dashboard** — Overview of teams and recent tasks

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Ruby on Rails 8.1 |
| Language | Ruby 3.4 |
| Database | SQLite (dev and prod) |
| Real-time | Hotwire (Turbo Streams) |
| Auth | Devise 5.0 |
| Pagination | Pagy |
| Frontend | Tailwind CSS, Importmap, Stimulus |
| Testing | RSpec, FactoryBot, Shoulda Matchers |
| CI | GitHub Actions |
| Deploy | Docker + Render |

## Quick Start

```bash
git clone https://github.com/ar1vit0r/rails-pm.git
cd rails-pm
bundle install
bin/rails db:create db:migrate db:seed
bin/dev
```

Open [http://localhost:3000](http://localhost:3000).

**Admin login:** `admin@example.com` / `password`
**User login:** `user@example.com` / `password`

## Testing

```bash
bundle exec rspec
```

71 examples across model and request specs.

## Deployment

Hosted on [Render](https://render.com), configured via the Render dashboard. Push to `main` to deploy.

## Skills Demonstrated

MVC architecture, RESTful routing, ActiveRecord associations (6 models), Devise authentication, multi-role authorization (owner/admin/member), Hotwire/Turbo Streams for real-time updates, Stimulus controllers, database migrations, Docker containerization, CI/CD pipelines, and production deployment.

## License

MIT
