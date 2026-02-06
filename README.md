# Trackmania Record watcher

Trackmania record watcher: users register, add maps to watch, and get daily email notifications when new records appear. Driver notifications for position changes. Single Node/Express backend, React (Vite) frontend, Postgres (Neon), deployed on Hetzner with Docker.

---

## Tech stack

| Layer    | Stack |
|----------|--------|
| Frontend | React, TypeScript, Vite, Tailwind |
| Backend  | Node, Express; request handlers in `backend/src/lambda/` (named after AWS Lambda style but run in-process, no serverless) |
| DB       | PostgreSQL (Neon); schema in `backend/sql/init.sql` |
| Email    | Gmail SMTP (nodemailer, port 587) |
| Prod     | Hetzner VPS, Docker Compose, nginx reverse proxy (port 80 only) |

---

## Docs (start here)

- **[ARCHITECTURE.md](ARCHITECTURE.md)** – How the app works: routes, request handlers, cron (Phase 1/2/3), data stores, flows (auth, map search, daily emails).
- **[DEPLOY.md](DEPLOY.md)** – Deploy to Hetzner: account, server, GitHub Secrets, workflow.
- **[firstimeserversetup.md](firstimeserversetup.md)** – One-time server setup: Docker, clone, `.env`, deploy script.
- **Backend env:** [backend/ENV.md](backend/ENV.md) – All env vars and where they’re used.

---

## Run locally

1. **DB:** Create a Neon project, run `backend/sql/init.sql` once. For schema changes on an existing DB, run the Migrations section at the bottom of `init.sql`.
2. **Backend:** `cd backend` → create `.env` (see [backend/ENV.md](backend/ENV.md)) → `npm install` → `npm start` (port 3000).
3. **Frontend:** `cd frontend` → `npm install` → `npm run dev`. Vite proxies `/api` to `http://localhost:3000`.

Or with Docker (Neon in `.env` at repo root): `docker compose up -d` → app on port 80, API on 3000.

---

## Repo layout

```
backend/          – Node/Express; entry: src/server.js → src/app.js
  src/lambda/      – Request handlers (login, cron, etc.); named "lambda" from AWS port but run in-process
  sql/init.sql    – Postgres schema (run once per Neon DB)
frontend/         – React + Vite; same-origin /api in prod
deploy/           – deploy.sh, nginx reverse-proxy config
compose.yaml      – Local Docker (backend + frontend, Neon in .env)
compose.prod.yaml – Prod (reverse-proxy + backend + frontend, port 80)
.github/workflows/deploy-hetzner.yml – Push to main → SSH, .env from ENV_FILE_B64, deploy
```

---

## Prod at a glance

- **Host:** Hetzner Cloud VPS (e.g. CX23). One server, Docker Compose.
- **Secrets:** `~/app/.env` on server (or GitHub Secrets → `ENV_FILE_B64` + workflow).
- **Cron:** `POST /api/v1/cron/daily` with `CRON_SECRET` (header or `?secret=`). Use cron-job.org or similar once per day.
- **Email:** Gmail App Password; SMTP port 587 (many providers block 465).

Use [ARCHITECTURE.md](ARCHITECTURE.md) for flows and [DEPLOY.md](DEPLOY.md) for step-by-step deploy.
