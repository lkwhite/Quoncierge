# Quoncierge

Automate initializing reproducible **Quarto + Jupyter + GitHub** projects with a simple script.

## ⏩ Quick Start

Quoncierge provides **two setup scripts** depending on your needs:

-   **Light (v0.1 philosophy)** — minimal Quarto + Python + GitHub scaffold

    ```         
    bash setup_light.sh my-project
    # or: bash setup.sh my-project   # shim → light
    ```

    Creates a `.venv`, registers a Jupyter kernel, writes `_quarto.yml`, sets up Git/GitHub, and generates a minimal README.\
    *Intended if you just want the basics without opinionated structure.*

-   **Full (v0.2-in-progress)** — structured workflow with helpers and automated routing of notebook outputs

    ```         
    bash setup_full.sh my-project
    ```

    Adds `notebooks/`, `outputs/`, `bin/qnew`, R/Python helpers, a starter notebook, and a pre-commit hook.\
    *Intended if you want automatic saving by notebook, reproducibility scaffolding, and convenience helpers.*

## 🧠 Motivation

Quoncierge is for people who work primarily in interactive notebooks for exploratory data analysis (EDA) — often coming from RStudio / R Projects — and who don’t want to wrestle with kernels, environments, or GitHub setup.

Even though Python, R, Jupyter, and Quarto are widely used, combining them usually requires:

-   creating project-local environments

-   registering Jupyter kernels

-   configuring Quarto to see them

-   setting up Git/GitHub with the right ignores

For users focused on analysis, that’s unnecessary friction. Quoncierge automates it: one command, ready-to-go project.

## ⚙️ What Quoncierge does

### Light

-   `.venv/` with core Python packages and local Jupyter kernel

-   `_quarto.yml` pinned to that kernel

-   `.gitignore` and `requirements.txt`

-   Git initialized and pushed to GitHub (if `gh` installed)

### Full (feature additions on top of Light)

-   `notebooks/`, `data/`, `outputs/`, `bin/` organizational structure by default

-   Dynamic helpers (`save_plot`, `savetbl`, `log`, etc.) auto-routing outputs by notebook stem

-   Starter notebook (`YYYYMMDD-init-analysis.qmd`) with examples

-   `bin/qnew` to automate new notebook creation

-   Pre-commit hook to block files \>50 MB in `outputs/` (preventing large file issues with GitHub)

## 🚀 Usage

Requirements:

-   Python 3

-   GitHub CLI (`gh`) installed and authenticated

-   Quarto CLI installed (on MacOS: `brew install --cask quarto`; Windows & Linux folks [Quarto instructions here](https://quarto.org/docs/get-started/))

-   (Optional) Positron installed and in your `$PATH`

💡 Tip: To launch the project in Positron from the command line, the positron command must be in your system PATH. You can add this from within Positron itself by opening the IDE, pressing `Cmd+Shift+P` (on Mac) or `Ctrl+Shift+P` (on Windows/Linux) to open the Command Palette. Type "Install Shell Command" and select Install the 'positron' command line tool. After running this, you should be able to launch projects from the terminal using `positron .`

Clone this repo:

```         
git clone https://github.com/lkwhite/Quoncierge.git
cd Quoncierge
```

Set your GitHub username/email in the script, then run either `setup_light.sh` or `setup_full.sh`.

## 🧪 Example Usage

### Light

```         
bash setup_light.sh my-analysis-project
# or: bash setup.sh my-analysis-project
```

Creates a folder `my-analysis-project/` with:

```         
.venv/           # Python environment
_quarto.yml      # kernel pinned
requirements.txt # pinned environment
README.md        # minimal scaffold
.gitignore
```

You can start adding notebooks manually (`notebooks/` is not created for you in Light mode).

------------------------------------------------------------------------

### Full

```         
bash setup_full.sh my-analysis-project
```

Creates a folder `my-analysis-project/` with:

```         
.venv/
notebooks/
  YYYYMMDD-init-analysis.qmd   # starter notebook
  _quoncierge/                 # helpers + templates
data/                          # ignored by git
outputs/                       # auto-routed per notebook
bin/qnew                       # helper to create new notebooks
_quarto.yml
requirements.txt
README.md
.gitignore
.git/hooks/pre-commit
```

Inside `notebooks/YYYYMMDD-init-analysis.qmd` you’ll find working R + Python examples.\
Running it will generate outputs in:

```         
outputs/YYYYMMDD-init-analysis/{figures,tables,artifacts,logs}
```

To add more notebooks, use the `qnew` helper:

```         
bin/qnew baseline-qc        # R by default
bin/qnew --py feature-scan  # Python
bin/qnew --r qc-report      # R
```

Each notebook saves its figures, tables, artifacts, and logs into a matching subfolder under `outputs/`.

## 🛠 Customizing Your Setup

You can edit `setup.sh` to:

-   Add or remove core Python packages
-   Make projects public instead of private
-   Customize the starting `.qmd`, README, or Quarto YAML

💡 If you install new Python packages, you can update your environment with:

``` bash
pip freeze > requirements.txt
```

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