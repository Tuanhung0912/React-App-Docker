# React + Vite Frontend

This project is a React frontend application built with [Vite](https://vite.dev/) — a fast, modern build tool for web development.

## Tech Stack

- **React** 18
- **Vite** 6
- **Docker** with multi-stage build (Nginx for production)

## Project Structure

```
frontend/
├── index.html            # Entry HTML (Vite serves from root)
├── vite.config.js        # Vite configuration
├── package.json
├── Dockerfile            # Production build (multi-stage → Nginx)
├── Dockerfile.dev        # Development container
├── docker-compose.yml    # Dev + Test services
├── public/               # Static assets (favicon, manifest, etc.)
│   ├── favicon.ico
│   ├── logo192.png
│   ├── logo512.png
│   ├── manifest.json
│   └── robots.txt
└── src/
    ├── main.jsx          # Application entry point
    ├── App.jsx           # Root component
    ├── App.css
    ├── index.css
    └── logo.svg
```

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

## Learn More

- [Vite Documentation](https://vite.dev/guide/)
- [React Documentation](https://react.dev/)
- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react/README.md)
