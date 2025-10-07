# CI/CD Pipeline Demo (GitHub Actions)

This repository is a minimal, self-contained demonstration of a CI/CD pipeline using **GitHub Actions**.
It contains a small Flask application with unit tests, a Dockerfile, and a workflow that runs tests and builds a Docker image.

## Project Structure

```
ci-cd-demo-github-actions/
├── app.py
├── requirements.txt
├── Dockerfile
├── .dockerignore
├── tests/
│   └── test_app.py
└── .github/
    └── workflows/
        └── ci-cd.yml
```

## How it works

- `test` job:
  - Installs Python dependencies and runs `pytest`.
- `build` job:
  - Builds a Docker image using `docker/build-push-action`.
  - If you configure GitHub Secrets `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`, the workflow will log in and push the image to Docker Hub (on push to `main`).

In an ideal and real-world scenario, a CI/CD pipeline will contain much more information. It will vastly depend on the project and what type of service or application you are building.

An ideal CI/CD (Continuous Integration and Continuous Deployment) workflow provides a seamless, automated pipeline that ensures every code change moves from development to production quickly, reliably, and with minimal manual intervention. 

The process begins with Continuous Integration, where developers push code to a shared repository. Automated build and test pipelines are triggered immediately—running unit, integration, and linting checks to validate code quality and detect issues early. Once the code passes all tests, Continuous Deployment takes over, automatically packaging the application (often into a Docker image), pushing it to a container registry, and deploying it to the target environment (e.g., Kubernetes, AWS ECS, Azure Web Apps).

Robust CI/CD workflows also include environmental segregation—deploying first to staging environments for validation, followed by production upon approval or successful automated checks. Tools like GitHub Actions, Jenkins, GitLab CI, or CircleCI orchestrate these processes, integrating with cloud services, monitoring tools (e.g., Prometheus, Grafana), and alerting systems to provide visibility and feedback at every step.

The goal of an ideal CI/CD pipeline is to deliver software faster, safer, and more consistently, enabling teams to focus on innovation rather than manual deployment overhead—building a culture of automation, reliability, and continuous improvement.


By the way,
> **_NOTE:_** Have you thought about using an automated tool which manages your app deployments on the go? Look up ArgoCD - we strongly recommend using that if you are working in a Kubernetes environment.

## Local usage

1. Create a virtual environment and install dependencies:
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

2. Run tests:
   ```bash
   pytest -q
   ```

3. Build and run with Docker:
   ```bash
   docker build -t ci-cd-demo:latest .
   docker run -p 5000:5000 ci-cd-demo:latest
   ```

## Notes for clients / reviewers

- The GitHub Actions workflow is intentionally generic and safe to use in demos.
- To enable pushing to Docker Hub, add the following repository secrets in GitHub:
  - `DOCKERHUB_USERNAME`
  - `DOCKERHUB_TOKEN`

## Contact

For inquiries or custom DevOps work, contact: info@devfero.com OR dev@devfero.com


