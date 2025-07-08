# Quoncierge

Automate initializing reproducible **Quarto + Jupyter + GitHub** projects.

## ⏩ TLDR Use
Edit `setup.sh` to add your GitHub details. Run `bash setup.sh <project-name>`, and get to coding in Positron!

## 🧠 Motivation

I built Quoncierge after beta testing [Positron](https://posit-dev.github.io/positron/), the next-generation IDE from the creators of RStudio. While it supports running R and Python in the same notebook using `.qmd` files, I ran into frustrating limitations when trying to launch a new Quarto project that *just worked* without manual setup and troubleshooting.

The current experience for setting up a new Python + Quarto project in Positron is fragmented. Quoncierge automates and smooths over the pain points of environment creation, kernel registration, and GitHub linkage — bringing .qmd notebooks closer to plug-and-play for bioinformatics and data science work.

## ⚙️ What it does

Quoncierge is a setup script that:

- Creates a new project folder (Quarto-compatible)
- Sets up a local Python virtual environment (`.venv`)
- Installs `jupyter`, `ipykernel`, `quarto`, and commonly-used scientific Python packages
- Registers a project-local Jupyter kernel
- Initializes a Quarto project with `README.md` and `.gitignore`
- Freezes environment requirements to `requirements.txt`
- Initializes a Git repo, creates a GitHub repo, and pushes the first commit
- (Optionally) launches the project in [Positron](https://posit-dev.github.io/positron/)

## ⚠️ Why setup can be confusing

Even though Python + Jupyter + Quarto are all widely used, getting them to work *together* in a reproducible way still takes several manual steps:

- Python environments (like `venv`, `conda`, or `mamba`) typically need to be created explicitly for each project.
- Jupyter and `ipykernel` must be installed **inside** the active environment to run notebooks from that environment.
- Kernels need to be manually registered if you're using a virtual environment that isn't globally visible.
- Quarto projects aren't automatically Git-tracked or linked to GitHub; you need to set that up yourself.
- IDEs like Positron currently don't infer all this context or register project-local Jupyter kernels automatically.

For newer users, it's not always clear why these steps are required or what breaks when they’re skipped. Quoncierge wraps these tasks into one reproducible setup flow that's friendlier to the type of users I typically work with (busy scientists jumping between wet lab experiments and bioinformatics data analysis).

## 🚀 Usage

You must have:
- Python 3
- GitHub CLI (`gh`) installed and authenticated
- Quarto CLI installed (`brew install --cask quarto`)
- (Optional) Positron installed and in your `$PATH`

💡 Tip: To launch the project in Positron from the command line, the positron command must be in your system PATH.
You can add this from within Positron itself by opening the IDE, pressing `Cmd+Shift+P` (on Mac) or `Ctrl+Shift+P` (on Windows/Linux) to open the Command Palette. Type "Install Shell Command" and select Install the 'positron' command line tool. After running this, you should be able to launch projects from the terminal using `positron .`

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

## 📜 License

Quoncierge is licensed under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) license. You’re free to share and adapt this work, even commercially, as long as you give appropriate credit.

If you adapt or improve this script for your own workflows, feel free to open a pull request or share a link!

