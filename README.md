# University Digital Notice Board

**Course:** CSC331 – DevOps for Cloud Computing  
**University:** COMSATS University Islamabad, Lahore Campus  
**Semester:** 6th | Batch: FALL 2023 | Section: C

---

## Project Overview

A static website serving as a **University Digital Notice Board** that displays academic announcements, examination schedules, and admission notices.

The CI/CD pipeline enforces:
1. **HTMLHint** – HTML quality linting
2. **Stylelint** – CSS quality linting
3. **Parcel** – Static site build
4. **Docker** – Image build and push to Docker Hub

A Docker image is only built and pushed **after** all lint and build stages pass.

---

## Project Structure

```
uni-notice-board/
├── .github/
│   └── workflows/
│       └── ci.yml          # 3-job GitHub Actions pipeline
├── src/
│   ├── index.html          # Homepage (Team Lead)
│   ├── notices.html        # Academic Notices (Member 1)
│   ├── exams.html          # Exam Schedules (Member 2)
│   ├── admissions.html     # Admission Updates (Member 3)
│   └── contact.html        # Contact Details (Member 4)
├── styles/
│   └── style.css           # Shared stylesheet
├── .dockerignore
├── .gitignore
├── .htmlhintrc
├── .stylelintrc.json
├── Dockerfile              # Multi-stage: Node builder + nginx
├── package.json
└── README.md
```

---

## CI Pipeline (3 Jobs)

```
Job 1: code-quality
  ├── Checkout Code
  ├── HTMLHint  →  lint all HTML files
  └── Stylelint →  lint style.css

Job 2: build-website  (needs: code-quality)
  ├── Checkout Code
  └── Parcel Build → outputs to /dist

Job 3: docker-publish  (needs: build-website)
  ├── Docker Build Image
  └── Docker Push to Docker Hub
```

---

## Branching Strategy

| Branch | Purpose |
|---|---|
| `main` | Production-ready code only |
| `develop` | Integration branch (protected) |
| `feature/homepage` | Team Lead – index.html |
| `feature/notices` | Member 1 – notices.html |
| `feature/exams` | Member 2 – exams.html |
| `feature/admissions` | Member 3 – admissions.html |
| `feature/contact` | Member 4 – contact.html |

> **Branch Protection Rule** on `develop`: PRs required, only Team Lead can merge.

---

## Local Setup

```bash
# Install dependencies
npm install

# Run HTML lint
npm run lint:html

# Run CSS lint
npm run lint:css

# Build with Parcel
npm run build

# Build Docker image locally
docker build -t uni-notice-board .

# Run Docker container locally
docker run -p 8080:80 uni-notice-board
# Visit: http://localhost:8080
```

---

## Required GitHub Secrets

| Secret | Value |
|---|---|
| `DOCKERHUB_USERNAME` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub access token (not password) |

---

## Docker Hub

Image: `<DOCKERHUB_USERNAME>/uni-notice-board:latest`
