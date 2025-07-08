# Quoncierge

Automate initializing reproducible **Quarto + Jupyter + GitHub** projects with a simple script.

## ⏩ TLDR Use
Quoncierge is aimed at users who want a lightweight, reproducible Python + Quarto setup with zero config — especially those transitioning from RStudio or `.Rmd` workflows to Positron and `.qmd` notebooks. It minimizes terminal steps so you can start coding right away.

Edit `setup.sh` to add your GitHub details. Then run `bash setup.sh <project-name>`, and get to coding in Positron!

## 🧠 Motivation

I built Quoncierge after beta testing [Positron](https://posit-dev.github.io/positron/). As a long-time Rstudio/Rprojects user switching to .qmd notebooks and Quarto projects, I ran into frustrating limitations when trying to launch a new project that *just worked* without manual setup and troubleshooting.

The current experience for setting up a new Python + Quarto project in Positron is fragmented. Quoncierge automates and smooths over the pain points of environment creation, kernel registration, and GitHub linkage — bringing .qmd notebooks closer to plug-and-play for data science work, with bioinformatics users in mind.

## ⚙️ What Quoncierge does

Quoncierge is a setup script that:

- Creates a new project folder (Quarto-compatible)
- Sets up a local Python virtual environment (`.venv`)
- Installs `jupyter`, `ipykernel`, `quarto`, and commonly-used scientific Python packages
- Registers a project-local Jupyter kernel
- Initializes a Quarto project with `README.md` and `.gitignore`
- Freezes environment requirements to `requirements.txt`
- Initializes a Git repo, creates a GitHub repo, and pushes the first commit
- (Optionally) launches the project in [Positron](https://posit-dev.github.io/positron/)

## ❌ What Quoncierge does *not* do

- It doesn't configure or manage Conda/Mamba environments (see [why venv](#why-venv-instead-of-condamamba)).
- It doesn't manage multi-language Quarto documents (R + Python), though [support for this is planned](https://github.com/lkwhite/Quoncierge/issues/2).

## ⚠️ Why setup can be confusing

Even though Python + Jupyter + Quarto are all widely used, getting them to work *together* in a reproducible way still takes several manual steps:

- Python environments (like `venv`, `conda`, or `mamba`) typically need to be created explicitly for each project.
- Jupyter and `ipykernel` must be installed **inside** the active environment to run notebooks from that environment.
- Kernels need to be manually registered if you're using a virtual environment that isn't globally visible.
- Quarto projects aren't automatically Git-tracked or linked to GitHub; you need to set that up yourself.
- IDEs like Positron currently don't infer all this context or register project-local Jupyter kernels automatically.

For newer users, it's not always clear why these steps are required or what breaks when they’re skipped. Quoncierge wraps these tasks into one reproducible setup flow that's friendlier to the type of users I typically work with, who do not want to add making sense of a kernel/environment/interpreter stack to their to-do list. 

## 🚀 Usage

You must have:
- Python 3
- GitHub CLI (`gh`) installed and authenticated
- Quarto CLI installed (on MacOS: `brew install --cask quarto`; Windows & Linux folks [Quarto instructions here](https://quarto.org/docs/get-started/))
- (Optional) Positron installed and in your `$PATH`

💡 Tip: To launch a project in Positron from the command line, the positron command must be in your system PATH. You can add this from within Positron itself by opening the IDE, pressing `Cmd+Shift+P` (on Mac) or `Ctrl+Shift+P` (on Windows/Linux) to open the Command Palette. Type "Install Shell Command" and select Install the 'positron' command line tool. After running this, you should be able to launch projects from the terminal using `positron .`

Clone this repo:

```bash
git clone https://github.com/lkwhite/Quoncierge.git
cd Quoncierge
```

Edit the top of setup.sh to insert your GitHub username and email.

Then run
```bash
bash setup.sh <project-name>
```

This creates a new folder with the given name, initializes the project, and (if positron is in your path) launches it directly.

## 📁 Output Files

Each project will contain:

- `.venv/` — Python virtual environment
- `.qmd` notebook(s) — ready to use with Jupyter and Quarto
- `README.md` — basic documentation scaffold
- `.gitignore` — preconfigured to ignore common clutter, including `.venv/`
- `requirements.txt` — pinned Python environment
- `.quarto/` and `_quarto.yml` — Quarto project metadata
- GitHub repository — auto-created with remote tracking set

## 🧪 Example

```bash
bash setup.sh my-analysis-project
```

Creates a folder my-analysis-project/ with a working Quarto + Jupyter setup, pushes it to GitHub, and opens it in Positron (if installed and in $PATH).

## 🛠 Customizing Your Setup

You can edit `setup.sh` to:

- Add or remove core Python packages
- Make projects public instead of private
- Customize the starting `.qmd`, README, or Quarto YAML

💡 If you install new Python packages, you can update your environment with:

```bash
pip freeze > requirements.txt
```

## 🤔Why venv instead of conda/mamba?

This project uses Python’s built-in [`venv`](https://docs.python.org/3/library/venv.html) for environment management to keep things simple, fast, and cross-platform with minimal setup friction. 

- No need to install Conda or Mamba.
- Works cleanly with Quarto and Python kernels without extra configuration.
- Easier to manage in lightweight or CI contexts.

If you prefer `conda` or `mamba`, you're welcome to adapt the environment setup — just ensure the Quarto CLI and a working Python kernel are available in your environment.


## 📜 License, Feedback, and Citations

Quoncierge is licensed under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) license. You’re free to share and adapt this work, even commercially, as long as you give appropriate credit.

If you adapt or improve this script for your own workflows, feel free to open a pull request or share a link.

Quoncierge is under active development as of July 2025, with the expectation that it may end up deprecated as Positron features continue to be built out. If you have a question or a comment, feel free to create an issue.

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15833439.svg)](https://doi.org/10.5281/zenodo.15833439)

This repository is archived on Zenodo. If you'd like to cite it, you can use the DOI above.


