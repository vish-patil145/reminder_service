# 🔔 Reminder Service

[![CI](https://github.com/your-username/reminder-service/actions/workflows/ci.yml/badge.svg)](https://github.com/your-username/reminder-service/actions)
[![Docker](https://img.shields.io/badge/docker-ready-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/r/your-username/reminder-service)
[![Ruby on Rails](https://img.shields.io/badge/Rails-8.0-CC0000?logo=rubyonrails&logoColor=white)](https://rubyonrails.org/)
[![Kubernetes](https://img.shields.io/badge/kubernetes-deployed-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> A scalable, event-driven reminder service built with Rails 8 — delivering scheduled notifications via Kafka messaging, Sidekiq background jobs, and Redis caching, deployed on Kubernetes.

---

## 📸 Demo

<!-- Replace with a real screenshot or GIF -->
![Reminder Service Dashboard](https://via.placeholder.com/900x400?text=Reminder+Service+Dashboard)

---

## 🏗️ Architecture

```
┌──────────────┐      ┌─────────────┐      ┌────────────────┐
│  Rails 8 API │─────▶│    Kafka    │─────▶│ Sidekiq Worker │
└──────────────┘      └─────────────┘      └────────────────┘
        │                                          │
        ▼                                          ▼
  ┌──────────┐                             ┌────────────┐
  │  Redis   │                             │ Notification│
  │  Cache   │                             │  Delivery  │
  └──────────┘                             └────────────┘
```

**Flow:**
1. API receives a reminder request
2. Event published to Kafka topic `reminders.scheduled`
3. Sidekiq consumer processes the event using Redis-backed queues
4. Notification dispatched at the scheduled time

---

## 🚀 Getting Started

### Prerequisites

- Ruby `3.3+`
- Docker & Docker Compose
- Kubernetes cluster (or [minikube](https://minikube.sigs.k8s.io/) for local)
- Kafka broker
- Redis `7+`

### Local Setup with Docker

```bash
# Clone the repository
git clone https://github.com/your-username/reminder-service.git
cd reminder-service

# Copy environment config
cp .env.example .env

# Start all services
docker compose up --build

# Run database migrations
docker compose exec web rails db:create db:migrate db:seed
```

The app will be available at `http://localhost:3000`.

---

## ⚙️ Configuration

Copy `.env.example` to `.env` and fill in the required values:

```env
# Rails
RAILS_ENV=development
SECRET_KEY_BASE=your_secret_key

# Database
DATABASE_URL=postgres://postgres:password@db:5432/reminder_service_dev

# Redis
REDIS_URL=redis://redis:6379/0

# Kafka
KAFKA_BROKERS=kafka:9092
KAFKA_TOPIC_REMINDERS=reminders.scheduled
KAFKA_GROUP_ID=reminder-service-consumers

# Sidekiq
SIDEKIQ_CONCURRENCY=5
```

---

## 📦 Stack

| Layer | Technology |
|---|---|
| Web Framework | Rails 8 |
| Background Jobs | Sidekiq |
| Cache / Queue Store | Redis 7 |
| Message Streaming | Apache Kafka |
| Containerisation | Docker + Docker Compose |
| Orchestration | Kubernetes |
| CI/CD | GitHub Actions |

---

## 🧪 Running Tests

```bash
# Run the full test suite
docker compose exec web bundle exec rspec

# Run with coverage
docker compose exec web bundle exec rspec --format documentation

# Run linter
docker compose exec web bundle exec rubocop
```

---

## 🔄 CI/CD Pipeline

Powered by **GitHub Actions** — defined in `.github/workflows/ci.yml`.

**Pipeline stages:**
1. **Lint** — RuboCop style checks
2. **Test** — RSpec test suite with Redis + Kafka service containers
3. **Build** — Docker image build & push to registry
4. **Deploy** — `kubectl apply` to Kubernetes cluster (on `main` branch only)

```yaml
# Trigger
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
```

---

## ☸️ Kubernetes Deployment

Manifests are located in `k8s/`.

```bash
# Apply all manifests
kubectl apply -f k8s/

# Check pod status
kubectl get pods -n reminder-service

# View logs
kubectl logs -f deployment/reminder-service-web -n reminder-service
```

**Key resources:**
- `k8s/deployment.yml` — Rails web + Sidekiq workers
- `k8s/service.yml` — LoadBalancer for the API
- `k8s/configmap.yml` — Non-secret environment config
- `k8s/secrets.yml` — Encrypted credentials (use Sealed Secrets or Vault)
- `k8s/hpa.yml` — Horizontal Pod Autoscaler

---

## 📁 Project Structure

```
reminder-service/
├── app/
│   ├── controllers/       # API endpoints
│   ├── jobs/              # Sidekiq job definitions
│   ├── models/            # ActiveRecord models
│   └── services/          # Business logic (Kafka producers etc.)
├── config/
│   ├── initializers/      # Sidekiq, Kafka, Redis setup
│   └── sidekiq.yml        # Queue configuration
├── k8s/                   # Kubernetes manifests
├── .github/
│   └── workflows/
│       └── ci.yml         # GitHub Actions pipeline
├── docker-compose.yml
├── Dockerfile
└── README.md
```

---

## 🛠️ Useful Commands

```bash
# Open Rails console
docker compose exec web rails console

# Sidekiq dashboard (mounted at /sidekiq in development)
open http://localhost:3000/sidekiq

# Tail Sidekiq logs
docker compose logs -f sidekiq

# Produce a test Kafka message
docker compose exec kafka kafka-console-producer \
  --topic reminders.scheduled \
  --bootstrap-server localhost:9092
```

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository
2. Create your branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'Add your feature'`
4. Push and open a Pull Request

Please run `rubocop` and `rspec` before submitting. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 📬 Contact

Made with ❤️ by [Your Name](https://github.com/your-username) · Open an [issue](https://github.com/your-username/reminder-service/issues) for bugs or feature requests.