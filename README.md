# Quoncierge

Automate initializing reproducible **Quarto + Jupyter + GitHub** projects with a simple script.

## ⏩ TLDR Use

Edit `setup.sh` to add your GitHub details. Then run `bash setup.sh <project-name>`, and get to coding in Positron!

## 🧠 Motivation

Quoncierge is for people who work primarily in **interactive notebooks for exploratory data analysis (EDA)** — often coming from **RStudio / R Projects** — and who don’t want to think about kernels, environments, or GitHub intricacies.

Even though Python, R, Jupyter, and Quarto are widely used, making them work *together* usually requires:

-   creating and activating project-local environments

-   installing Jupyter + registering kernels

-   configuring Quarto to see those kernels

-   setting up Git/GitHub with the right ignores and limits

For users focused on analysis, this is unnecessary friction.

**Quoncierge automates all of it**: you run one command and get a ready-to-go project with R + Python support, helpers for saving outputs, and a GitHub repo already in place. The design goal is to give you *just enough structure* to stay reproducible without forcing a heavyweight template or deep knowledge of the Python/R/Quarto stack.

Development aims to be **use-case agnostic**, but is informed by the needs of **biologists picking up bioinformatics on the side (and those teaching them)**, where quick reproducibility and low setup overhead are especially important.

## ⚙️ What Quoncierge does

Quoncierge is a single script that:

-   Creates a Quarto-compatible project folder

-   Sets up a local Python environment (`.venv`) and registers a Jupyter kernel

-   Installs core packages for R and Python notebooks

-   Adds lightweight structure: `notebooks/`, `data/`, `outputs/`

-   Generates a starter notebook with working Python + R examples

-   Provides a `bin/qnew` helper to create new notebooks (`YYYYMMDD-slug.qmd`)

-   Configures `.gitignore` and a pre-commit hook to block files \>50 MB

-   Initializes Git and pushes a private GitHub repo

-   (Optionally) launches the project in [Positron](https://posit-dev.github.io/positron/)

## 🚀 Usage

You must have:

-   Python 3

-   GitHub CLI (`gh`) installed and authenticated

-   Quarto CLI installed (on MacOS: `brew install --cask quarto`; Windows & Linux folks [Quarto instructions here](https://quarto.org/docs/get-started/))

-   (Optional) Positron installed and in your `$PATH`

💡 Tip: To launch the project in Positron from the command line, the positron command must be in your system PATH. You can add this from within Positron itself by opening the IDE, pressing `Cmd+Shift+P` (on Mac) or `Ctrl+Shift+P` (on Windows/Linux) to open the Command Palette. Type "Install Shell Command" and select Install the 'positron' command line tool. After running this, you should be able to launch projects from the terminal using `positron .`

Clone this repo:

``` bash
git clone https://github.com/lkwhite/Quoncierge.git
cd Quoncierge
```

Edit the top of setup.sh to insert your GitHub username and email.

Then run

``` bash
bash setup.sh <project-name>
```

This creates a new folder with the given name, initializes the project, and (if positron is in your path) launches it directly.

## 📁 Output Files

New Quoncierge projects contain:

-   `.venv/` — project-local Python environment

-   `notebooks/` — your analysis notebooks (`YYYYMMDD-slug.qmd`)

    -   includes `_helpers.py` and `_helpers.R` (save helpers)

    -   includes `_metadata.yml` (default execution options)

-   `data/` — raw and intermediate data (ignored by git)

-   `outputs/` — auto-organized results for each notebook (`figures/`, `tables/`, `artifacts/`, `logs/`)

-   `bin/qnew` — helper script to create new notebooks with date + slug naming

-   `.gitignore`, `README.md`, `requirements.txt`, `_quarto.yml` — project metadata and configuration

-   GitHub repository — auto-created with remote tracking

## 🛠 Customizing Your Setup

You can edit `setup.sh` to:

-   Add or remove core Python packages
-   Make projects public instead of private
-   Customize the starting `.qmd`, README, or Quarto YAML

💡 If you install new Python packages, you can update your environment with:

``` bash
pip freeze > requirements.txt
```

## 🧪 Example

Initialize a new project:

```         
bash setup.sh my-analysis-project
```

This creates a folder `my-analysis-project/` with Quarto + Jupyter set up, pushes it to GitHub, and opens it in Positron (if installed and on your `$PATH`).

Inside you’ll find a starter notebook:

```         
notebooks/YYYYMMDD-init-analysis.qmd
```

Running it will generate example outputs in:

```         
outputs/YYYYMMDD-init-analysis/{figures,tables,artifacts,logs}
```

To add more notebooks, use the `qnew` helper:

```         
bin/qnew baseline-qc        # creates notebooks/YYYYMMDD-baseline-qc.qmd (R by default)
bin/qnew --py feature-scan  # creates a Python notebook
bin/qnew --r qc-report      # creates an R notebook
```

Each notebook automatically saves its figures, tables, artifacts, and logs to a matching subfolder under `outputs/`.

## 🤔Why venv instead of conda/mamba?

This project uses Python’s built-in [`venv`](https://docs.python.org/3/library/venv.html) for environment management to keep things simple, fast, and cross-platform with minimal setup friction.

-   No need to install Conda or Mamba.
-   Works cleanly with Quarto and Python kernels without extra configuration.
-   Easier to manage in lightweight or CI contexts.

If you prefer `conda` or `mamba`, you're welcome to adapt the environment setup — just ensure the Quarto CLI and a working Python kernel are available in your environment.

## 📜 License, Feedback, and Citations

Quoncierge is licensed under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) license. You’re free to share and adapt this work, even commercially, as long as you give appropriate credit.

If you adapt or improve this script for your own workflows, feel free to open a pull request or share a link. Quoncierge is under active development as of October 2025, with the expectation that it may end up deprecated as Positron features continue to be built out. If you have a question or a comment, feel free to create an issue.

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15833439.svg)](https://doi.org/10.5281/zenodo.15833439)

This repository is archived on Zenodo. If you'd like to cite it, you can use the DOI above.