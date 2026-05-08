# Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

The page will reload when you make changes.\
You may also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.\
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.\
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.\
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `npm run eject`

**Note: this is a one-way operation. Once you `eject`, you can't go back!**

If you aren't satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you're on your own.

You don't have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn't feel obligated to use this feature. However we understand that this tool wouldn't be useful if you couldn't customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).

### Code Splitting

This section has moved here: [https://facebook.github.io/create-react-app/docs/code-splitting](https://facebook.github.io/create-react-app/docs/code-splitting)

### Analyzing the Bundle Size

This section has moved here: [https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size](https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size)

### Making a Progressive Web App

This section has moved here: [https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app](https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app)

### Advanced Configuration

This section has moved here: [https://facebook.github.io/create-react-app/docs/advanced-configuration](https://facebook.github.io/create-react-app/docs/advanced-configuration)

### Deployment

This section has moved here: [https://facebook.github.io/create-react-app/docs/deployment](https://facebook.github.io/create-react-app/docs/deployment)

### `npm run build` fails to minify

This section has moved here: [https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify](https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify)

## Setup

Follow these steps to set up the project locally. This assumes you have Node.js and npm installed. For containerized runs, Docker is optional but recommended.

1. Install project dependencies:

```bash
npm install
```

2. (Optional) If you plan to run the app with Docker, ensure Docker Desktop (Windows/macOS) or Docker Engine (Linux) is installed and running.

## Run locally

Start the development server:

```bash
npm start
# Then open http://localhost:3000 in your browser
```

Build the app for production:

```bash
npm run build
```

## Docker (example)

This project includes a development Dockerfile (`Dockerfile.dev`). Below are example commands to build and run the app in Docker. Adapt paths and options to your environment.

Build a development image using `Dockerfile.dev`:

```bash
docker build -t reactapp:dev -f Dockerfile.dev .
```

Run the development container and map port 3000:

On Windows (PowerShell/CMD):
```powershell
docker run --rm -it -p 3000:3000 -v %cd%:/app -w /app reactapp:dev
```

On Linux/macOS:
```bash
docker run --rm -it -p 3000:3000 -v $(pwd):/app -w /app reactapp:dev
```

Notes:
- Volume mounts (`-v`) let the container reflect local code changes. Remove the `-v` option for a static image run.
- Replace `%cd%` with `$(pwd)` on non-Windows systems.

Example: build and run a production image (serve `build/` with a static server):

```bash
npm run build
docker build -t reactapp:latest .
docker run --rm -p 80:80 reactapp:latest
```

Troubleshooting:
- If port 3000 is already in use, change the host port mapping (for example `-p 3001:3000`).
- On Windows, allow Docker Desktop access to drive mounts if using volume mounts.
- For permission errors when building or mounting volumes, try running commands with appropriate privileges.

