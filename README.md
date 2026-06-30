# React + Vite Frontend

This project is a React frontend application built with [Vite](https://vite.dev/) — a fast, modern build tool for web development.

## Tech Stack

- **React** 18
- **Vite** 6
- **Docker** with multi-stage build (Nginx for production)

## Setup

Follow these steps to set up the project locally. This assumes you have Node.js and npm installed. For containerized runs, Docker is optional but recommended.

1. Install project dependencies:

```bash
npm install
```

2. (Optional) If you plan to run the app with Docker, ensure Docker Desktop (Windows/macOS) or Docker Engine (Linux) is installed and running.

## Available Scripts

In the project directory, you can run:

### `npm run dev`

Runs the app in development mode.\
Open [http://localhost:5173](http://localhost:5173) to view it in your browser.

The page will hot-reload instantly when you make changes thanks to Vite's HMR (Hot Module Replacement).

### `npm run build`

Builds the app for production to the `dist` folder.\
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.\
Your app is ready to be deployed!

### `npm run preview`

Locally preview the production build. This serves the `dist` folder on a local static server.\
Useful to verify the production build before deploying.

## Run Locally

Start the development server:

```bash
npm run dev
# Then open http://localhost:5173 in your browser
```

Build the app for production:

```bash
npm run build
```

Preview the production build:

```bash
npm run preview
```

## Docker

This project includes Docker support for both development and production environments.

### Development with Docker Compose

The easiest way to run the development environment is with Docker Compose:

```bash
docker-compose up
```

This starts two services:

- **web** — Development server with hot-reload on [http://localhost:5173](http://localhost:5173)
- **test** — Runs the test suite

### Development Container (Manual)

Build a development image using `Dockerfile.dev`:

```bash
docker build -t reactapp:dev -f Dockerfile.dev .
```

Run the development container and map port 5173:

On Windows (PowerShell):

```powershell
docker run --rm -it -p 5173:5173 -v ${PWD}:/app -w /app reactapp:dev
```

On Linux/macOS:

```bash
docker run --rm -it -p 5173:5173 -v $(pwd):/app -w /app reactapp:dev
```

### Production Build

Build and run a production image (serves `dist/` with Nginx):

```bash
docker build -t reactapp:latest .
docker run --rm -p 80:80 reactapp:latest
```

Then open [http://localhost](http://localhost) in your browser.

### Docker Notes

- Volume mounts (`-v`) let the container reflect local code changes. Remove the `-v` option for a static image run.
- Vite's dev server is configured with `host: true` and `usePolling: true` in `vite.config.js` to work correctly inside Docker containers.
- If port 5173 is already in use, change the host port mapping (for example `-p 5174:5173`).
- On Windows, allow Docker Desktop access to drive mounts if using volume mounts.
- For permission errors when building or mounting volumes, try running commands with appropriate privileges.

## Environment Variables

Vite uses the `VITE_` prefix for environment variables that are exposed to the client-side code.

```bash
# .env
VITE_API_URL=http://localhost:8080/api
```

Access in code:

```js
const apiUrl = import.meta.env.VITE_API_URL;
```

> **Note:** Only variables prefixed with `VITE_` are exposed to your app. See the [Vite Env Variables docs](https://vite.dev/guide/env-and-mode) for more details.

## CI/CD Pipeline (GitHub Actions)

This project uses **GitHub Actions** for automated testing and deployment. The workflow is defined in `.github/workflows/deploy.yaml`.

### Pipeline Overview

```
Push to main
     ↓
┌── Job 1: test ──────────────────────────────┐
│  Build Docker image from Dockerfile.dev     │
│  Run "npm test" (Vitest) inside container   │
└─────────────┬───────────────────────────────┘
              ↓ (only if tests pass)
┌── Job 2: build-production ──────────────────┐
│  Build Docker image from Dockerfile (Nginx) │
│  Start container → curl verify it serves    │
└─────────────┬───────────────────────────────┘
              ↓ (only if build passes)
┌── Job 3: deploy-to-render ──────────────────┐
│  Call Render Deploy Hook URL                │
│  Render pulls latest code & redeploys       │
└─────────────────────────────────────────────┘
```

### Workflow Trigger

The workflow runs in two scenarios:

- **Push to `main`** — runs all 3 jobs (test → build → deploy)
- **Pull Request to `main`** — runs test + build only (no deploy), to validate code before merging

### deploy.yaml Explained

| Section                           | What it does                                                                                                                                     |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `on: push/pull_request`           | Triggers the workflow on pushes and PRs targeting the `main` branch                                                                              |
| **Job: test**                     | Builds `Dockerfile.dev` image, runs `npm test` with `CI=true` so Vitest runs once and exits                                                      |
| **Job: build-production**         | Builds the multi-stage `Dockerfile` (Node.js build → Nginx serve), then starts the container and uses `curl` to verify Nginx responds on port 80 |
| **Job: deploy-to-render**         | Calls the Render Deploy Hook URL (stored in GitHub Secrets) to trigger a production deployment. Only runs on push to main — never on PRs         |
| `needs:`                          | Ensures jobs run in order. `build-production` waits for `test`; `deploy-to-render` waits for both                                                |
| `if: github.event_name == 'push'` | Prevents deployment on Pull Request events                                                                                                       |

### Required GitHub Secrets

| Secret Name              | Where to get it                                   |
| ------------------------ | ------------------------------------------------- |
| `RENDER_DEPLOY_HOOK_URL` | Render Dashboard → Service Settings → Deploy Hook |

To add a secret: GitHub repo → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

---

## Deployment (Render.com)

This project is deployed to **[Render.com](https://render.com)** as a free alternative to AWS Elastic Beanstalk. Render builds the production `Dockerfile` (multi-stage with Nginx) and hosts it as a web service.

### Why Render?

| Feature                 | Render (Free)       | AWS Elastic Beanstalk    |
| ----------------------- | ------------------- | ------------------------ |
| Cost                    | **$0/month**        | Requires billing account |
| Docker support          | ✅                  | ✅                       |
| Auto-deploy from GitHub | ✅                  | ✅                       |
| SSL/HTTPS               | ✅ Free & automatic | ✅                       |
| Setup complexity        | Minimal             | Moderate                 |

### How it works

1. Render connects to the GitHub repository
2. When triggered (via Deploy Hook from GitHub Actions), Render pulls the latest code
3. Render builds the `Dockerfile` (Node.js build → Nginx)
4. The built container is deployed and served at a public URL

### Setup Render (Step by Step)

1. Go to [render.com](https://render.com) → Sign up with **GitHub**
2. Click **"New +"** → **"Web Service"**
3. Select your repo → Connect
4. Configure the service:

| Setting         | Value                                                        |
| --------------- | ------------------------------------------------------------ |
| Name            | `React-Frontend`                                             |
| Language        | `Docker`                                                     |
| Branch          | `main`                                                       |
| Region          | `Singapore (Southeast Asia)`                                 |
| Instance Type   | `Free`                                                       |
| Dockerfile Path | _(leave empty — defaults to `./Dockerfile`)_                 |
| Auto-Deploy     | **Set to "No"** (deployment is controlled by GitHub Actions) |

5. Click **"Deploy Web Service"**
6. After creation, go to **Settings** → copy the **Deploy Hook** URL
7. Add it as a GitHub Secret named `RENDER_DEPLOY_HOOK_URL`

### Free Tier Limitations

- Service **spins down after 15 minutes** of inactivity
- First request after spin-down takes **~30-50 seconds** (cold start)
- 512 MB RAM, 0.1 CPU
- 100 GB bandwidth/month
- No credit card required if registered with GitHub

---
