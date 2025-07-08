#!/bin/bash

# ============================================
# setup.sh — Quarto + Jupyter + GitHub Project Initializer
#
# USAGE:
#   bash setup.sh <project-name>
#
# DESCRIPTION:
# This script automates the setup of a new Quarto project directory that:
#   - Creates a new folder with the given name (if it doesn’t exist)
#   - Initializes a Python virtual environment in `.venv`
#   - Installs Jupyter, Quarto, and other key packages
#   - Registers a project-local Jupyter kernel
#   - Initializes a Quarto project
#   - Initializes a Git repository and creates a first commit
#   - Creates a corresponding GitHub repository (via `gh`) and pushes the commit
#   - Optionally opens the project in Positron if available
#
# The project will be created in the directory where this script is run,
# unless a full or relative path is provided. For example:
#   bash setup.sh my-project        # creates ./my-project
#   bash setup.sh ~/Projects/test   # creates project in ~/Projects/test
#
# REQUIREMENTS:
#   - Python 3
#   - Quarto CLI
#   - GitHub CLI (`gh`) and authenticated GitHub session
#   - (Optional) Positron installed and in PATH for project launch
#
# Customize GITHUB_USERNAME and GITHUB_EMAIL below before use.
# ============================================

# === CONFIGURATION ===
PROJECT_NAME=$1
GITHUB_USERNAME="username"  # CHANGE this to your GitHub username
GITHUB_EMAIL="youremail@institution.edu"  # CHANGE this to your GitHub-associated email
OPEN_WITH_POSITRON=true  # Set to false to skip Positron launch

# === CHECK FOR NAME ===
if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: bash setup.sh <project-name>"
  exit 1
fi

# === CREATE PROJECT DIRECTORY ===
mkdir "$PROJECT_NAME" || echo "Directory already exists"
cd "$PROJECT_NAME" || exit 1

# === SET UP GIT CONFIG ===
git config --global user.name "$GITHUB_USERNAME"
git config --global user.email "$GITHUB_EMAIL"

# === CREATE VENV ===
python3 -m venv .venv
source .venv/bin/activate

# === INSTALL DEPENDENCIES ===
pip install --upgrade pip
pip install jupyter ipykernel quarto
pip install numpy pandas matplotlib seaborn scikit-learn biopython scipy

# === REGISTER PROJECT-LOCAL JUPYTER KERNEL ===
python -m ipykernel install --name="$PROJECT_NAME" --display-name="Python ($PROJECT_NAME)" --prefix=".venv"

# === INITIALIZE QUARTO PROJECT ===
quarto create-project .

# === GENERATE README.md ===
cat <<EOF > README.md
# $PROJECT_NAME

This project was initialized using [Quoncierge](https://github.com/lkwhite/Quoncierge) \`setup.sh\`.

## Getting started

To activate the Python environment:
\`\`\`bash
source .venv/bin/activate
\`\`\`

To open in Positron:
\`\`\`bash
positron .
\`\`\`

To run or preview Quarto documents:
\`\`\`bash
quarto preview
\`\`\`

## Python Environment

Python packages were pinned at time of setup (see \`requirements.txt\`).  
Install them with:

\`\`\`bash
pip install -r requirements.txt
\`\`\`
EOF

# === FREEZE DEPENDENCIES ===
pip freeze > requirements.txt

# === CREATE .gitignore ===
cat <<EOF > .gitignore
# Python
__pycache__/
*.py[cod]
.venv/
.env
*.egg-info/
.ipynb_checkpoints/

# Quarto
_publish/
*.html
*.pdf

# OS
.DS_Store
EOF

# === GIT INIT AND COMMIT ===
git init
git add .
git commit -m "Initial commit"

# === CREATE GITHUB REPO ===
if command -v gh &> /dev/null; then
  gh repo create "$GITHUB_USERNAME/$PROJECT_NAME" --source=. --private --push --remote=origin --confirm
else
  echo "⚠️ GitHub CLI (gh) not found. Skipping GitHub repo creation."
fi

# === OPEN IN POSITRON IF AVAILABLE ===
if $OPEN_WITH_POSITRON && command -v positron &> /dev/null; then
  positron .
else
  echo "You can open the project manually if desired."
fi

