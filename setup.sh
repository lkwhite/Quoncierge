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
RAW_PROJECT_PATH=$1
PROJECT_NAME=$(basename "$RAW_PROJECT_PATH")
KERNEL_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9._-' '-') # remove disallowed chars
GITHUB_USERNAME="username"  # CHANGE this to your GitHub username
GITHUB_EMAIL="youremail@institution.edu"  # CHANGE this to your GitHub-associated email
OPEN_WITH_POSITRON=true  # Set to false to skip Positron launch

# === CHECK FOR QUARTO CLI ===
if ! command -v quarto &> /dev/null; then
  echo "❌ Quarto CLI is not installed."
  echo "👉 Install it from https://quarto.org/docs/get-started/"
  echo "   • Mac (Homebrew): brew install --cask quarto"
  echo "   • Windows (Chocolatey): choco install quarto"
  echo "   • Linux: see install instructions on the Quarto site"
  echo ""
  echo "Once installed, re-run this script:"
  echo "    bash setup.sh $PROJECT_NAME"
  exit 1
fi

# === CORE PYTHON PACKAGES ===
CORE_PACKAGES=(
  numpy
  pandas
  matplotlib
  seaborn
  scikit-learn
  scipy
  biopython
)

# === CHECK FOR NAME ===
if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: bash setup.sh <project-name>"
  exit 1
fi

# === CREATE PROJECT DIRECTORY ===
mkdir "$RAW_PROJECT_PATH" || echo "Directory already exists"
cd "$RAW_PROJECT_PATH" || exit 1

# === SET UP GIT CONFIG ===
git config --global user.name "$GITHUB_USERNAME"
git config --global user.email "$GITHUB_EMAIL"

# === CREATE VENV ===
python3 -m venv .venv
source .venv/bin/activate

# === INSTALL DEPENDENCIES ===
pip install --upgrade pip
pip install jupyter ipykernel
pip install "${CORE_PACKAGES[@]}"

# === REGISTER PROJECT-LOCAL JUPYTER KERNEL ===
python -m ipykernel install --name="$PROJECT_NAME" --display-name="Python ($PROJECT_NAME)" --prefix=".venv"

# === INITIALIZE QUARTO PROJECT ===
quarto create-project .

# === CREATE CUSTOM YML ===
cat <<EOF > _quarto.yml
project:
  type: default

execute:
  kernel: $KERNEL_NAME
  freeze: auto

format: html
title: "$PROJECT_NAME"
EOF

# === GENERATE README.md ===
cat <<EOF > README.md
# $PROJECT_NAME

📝 *This is a placeholder README. Replace this with a description of your project — what it does, what problem it solves, or what you're exploring.*

---

## Getting Started

This project uses a self-contained Python environment in \`.venv\` and a Quarto configuration that includes all required settings for reproducible analysis.

### 🔧 To activate the environment (only needed outside Positron):
\`\`\`bash
source .venv/bin/activate
\`\`\`

---

## Python Environment

The following core packages were installed at setup:
EOF

# Append core packages
for pkg in "${CORE_PACKAGES[@]}"; do
  echo "- \`$pkg\`" >> README.md
done

cat <<EOF >> README.md

You can view the complete environment in [\`requirements.txt\`](requirements.txt).

### 🧪 Installing more packages

If you're working *outside* Positron (e.g., in the terminal):

\`\`\`bash
source .venv/bin/activate
pip install my-new-package
pip freeze > requirements.txt  # optional, but keeps your environment reproducible
\`\`\`

> 💡 If you're using Positron, you can also install packages inside the built-in terminal, then restart the kernel if needed.

---

## About This Template

This project was initialized using [**Quoncierge**](https://github.com/lkwhite/Quoncierge), a lightweight starter for Quarto projects in Positron.
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
git init -b main
git add .
git commit -m "Initial commit"

# === CREATE GITHUB REPO ===
if command -v gh &> /dev/null; then
  gh repo create "$GITHUB_USERNAME/$PROJECT_NAME" \
    --source=. \
    --private \
    --push \
    --remote=origin \
    --confirm
else
  echo "⚠️ GitHub CLI (gh) not found. Skipping GitHub repo creation."
fi

# === OPEN IN POSITRON IF AVAILABLE ===
if $OPEN_WITH_POSITRON && command -v positron &> /dev/null; then
  positron .
else
  echo "You can open the project manually if desired."
fi

