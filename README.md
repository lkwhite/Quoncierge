# Quoncierge

Automate initializing reproducible **Quarto + Jupyter + GitHub** projects with a simple script.

## 🚀 TL;DR

```bash
git clone https://github.com/lkwhite/Quoncierge.git
cd Quoncierge
bash setup_light.sh my-project    # Minimal setup
# OR: bash setup_full.sh my-project  # Full workflow with helpers
```

Set your GitHub username/email in the script first. Done!

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

### Feature Comparison: Light vs Full

| Feature | Light (v0.1) | Full (v0.2) |
|---------|--------------|-------------|
| **Philosophy** | Minimal scaffold | Opinionated workflow |
| **Python venv** | ✅ Yes | ✅ Yes |
| **Jupyter kernel** | ✅ Project-local | ✅ Project-local |
| **Quarto config** | ✅ `_quarto.yml` | ✅ Enhanced `_quarto.yml` |
| **Git init** | ✅ Yes | ✅ Yes |
| **GitHub repo** | ✅ Optional (via `gh`) | ✅ Optional (via `gh`) |
| **`.gitignore`** | ✅ Basic | ✅ Enhanced |
| **`requirements.txt`** | ✅ Yes | ✅ Yes |
| **Directory structure** | ❌ None (you choose) | ✅ `notebooks/`, `data/`, `outputs/`, `bin/` |
| **Helper functions** | ❌ No | ✅ Python + R helpers for saving outputs |
| **Auto-organized outputs** | ❌ No | ✅ By notebook: `outputs/<notebook>/figures/` etc. |
| **Starter notebook** | ❌ No | ✅ `YYYYMMDD-init-analysis.qmd` with examples |
| **Notebook templates** | ❌ No | ✅ R and Python templates |
| **`qnew` utility** | ❌ No | ✅ `bin/qnew` creates notebooks from templates |
| **Pre-commit hooks** | ❌ No | ✅ Blocks large files (>50MB) in outputs/ |
| **R support** | ❌ Python-only | ✅ Optional R + reticulate for mixed workflows |
| **Positron IDE launch** | ✅ Optional | ✅ Optional |
| **Setup time** | ~2 min | ~3 min |
| **Learning curve** | Minimal | Moderate |
| **Best for** | Quick starts, minimal projects | Multi-notebook projects, reproducibility |

### Light Mode Summary

Core essentials only:
-   `.venv/` with core Python packages and local Jupyter kernel

-   `_quarto.yml` pinned to that kernel

-   `.gitignore` and `requirements.txt`

-   Git initialized and pushed to GitHub (if `gh` installed)

### Full Mode Summary

Everything in Light PLUS:

-   **Organized structure**: `notebooks/`, `data/`, `outputs/`, `bin/` organizational structure by default

-   Dynamic helpers (`save_plot`, `savetbl`, `log`, etc.) auto-routing outputs by notebook stem

-   Starter notebook (`YYYYMMDD-init-analysis.qmd`) with examples

-   `bin/qnew` to automate new notebook creation

-   Pre-commit hook to block files \>50 MB in `outputs/` (preventing large file issues with GitHub)

## 🚀 Usage

**Requirements:**

| Requirement | Minimum Version | Required? | Installation |
|-------------|----------------|-----------|--------------|
| **Python** | 3.8+ | ✅ Yes | [python.org/downloads](https://www.python.org/downloads/) |
| **Quarto CLI** | 1.3+ | ✅ Yes | macOS: `brew install --cask quarto`<br>Other: [quarto.org/docs/get-started](https://quarto.org/docs/get-started/) |
| **GitHub CLI** | 2.0+ | ⚠️ Recommended | macOS: `brew install gh`<br>Other: [cli.github.com](https://cli.github.com/) |
| **Positron** | Latest | ⭕ Optional | [github.com/posit-dev/positron](https://github.com/posit-dev/positron) |
| **R** (Full mode) | 4.0+ | ⭕ Optional | [r-project.org](https://www.r-project.org/) |

**Notes:**
- **GitHub CLI**: Not required for local projects, but needed for automatic GitHub repo creation. Without `gh`, you'll still get a local Git repository.
- **Python**: `python3 --version` should show 3.8 or higher. The script uses `python3` by default.
- **Quarto**: Verify with `quarto --version`. Must be in your `$PATH`.
- **Positron**: Only needed if you want automatic IDE launching. The script will skip this step if Positron is not installed.
- **R**: Only needed for Full mode if you want to use R notebooks. Light mode is Python-only.

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

**What success looks like:**

You should see output similar to:
```
✓ Creating project directory: my-analysis-project
✓ Creating Python virtual environment
✓ Installing core packages (numpy, pandas, matplotlib, ...)
✓ Registering Jupyter kernel: my-analysis-project
✓ Creating _quarto.yml configuration
✓ Creating .gitignore and requirements.txt
✓ Initializing Git repository
✓ Creating GitHub repository (private)
✓ Pushing to GitHub
✓ Setup complete! Your project is ready at: my-analysis-project/
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

**What success looks like:**

You should see output similar to:
```
✓ Creating project directory: my-analysis-project
✓ Creating Python virtual environment
✓ Installing Python packages (numpy, pandas, matplotlib, ...)
✓ Installing R packages (optional: reticulate, ggplot2, ...)
✓ Registering Jupyter kernel: my-analysis-project
✓ Creating directory structure (notebooks/, data/, outputs/, bin/)
✓ Creating helper functions (_quoncierge/)
✓ Creating starter notebook: YYYYMMDD-init-analysis.qmd
✓ Creating qnew utility in bin/
✓ Setting up pre-commit hook
✓ Creating _quarto.yml configuration
✓ Initializing Git repository
✓ Creating GitHub repository (private)
✓ Pushing to GitHub
✓ Setup complete! Try: cd my-analysis-project && quarto render notebooks/YYYYMMDD-init-analysis.qmd
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

## 📚 Helper Functions Reference (Full Mode)

Full mode provides convenience functions that automatically organize outputs by notebook. These helpers are available in `notebooks/_quoncierge/_helpers.py` (Python) and `notebooks/_quoncierge/_helpers.R` (R).

### Python Helpers

Import in your notebook:
```python
from notebooks._quoncierge._helpers import savefig, savetbl, saveartifact, log
```

**`savefig(name, fig=None, dpi=300)`**
- Saves a matplotlib figure to `outputs/<notebook-stem>/figures/<name>`
- `name`: Filename (e.g., `"plot.png"`)
- `fig`: Matplotlib figure object (defaults to current pyplot figure)
- `dpi`: Resolution (default: 300)
- Example:
  ```python
  import matplotlib.pyplot as plt
  plt.plot([1, 2, 3], [4, 5, 6])
  savefig("my_plot.png")  # → outputs/YYYYMMDD-analysis/figures/my_plot.png
  ```

**`savetbl(df, name)`**
- Saves a pandas DataFrame to `outputs/<notebook-stem>/tables/<name>`
- Automatically detects format: `.parquet` uses parquet, otherwise CSV
- Example:
  ```python
  import pandas as pd
  df = pd.DataFrame({"x": [1, 2, 3], "y": [4, 5, 6]})
  savetbl(df, "results.csv")       # → CSV format
  savetbl(df, "results.parquet")   # → Parquet format
  ```

**`saveartifact(bytes_or_str, name, binary=None)`**
- Saves arbitrary data to `outputs/<notebook-stem>/artifacts/<name>`
- Automatically detects binary vs. text mode
- Example:
  ```python
  # Save text
  saveartifact("model config: {...}", "config.txt")
  # Save binary
  with open("model.pkl", "rb") as f:
      saveartifact(f.read(), "model.pkl")
  ```

**`log(message, name="run.log")`**
- Appends a log message to `outputs/<notebook-stem>/logs/<name>`
- Example:
  ```python
  log("Starting analysis")
  log("Processed 1000 rows")
  log("Custom log entry", name="custom.log")
  ```

### R Helpers

Source in your notebook:
```r
source("notebooks/_quoncierge/_helpers.R")
```

**`save_plot(p, name, width=6, height=4, dpi=300)`**
- Saves a ggplot2 plot to `outputs/<notebook-stem>/figures/<name>`
- Example:
  ```r
  library(ggplot2)
  p <- ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()
  save_plot(p, "scatter.png")  # → outputs/YYYYMMDD-analysis/figures/scatter.png
  ```

**`save_table(df, name)`**
- Saves a data frame to `outputs/<notebook-stem>/tables/<name>`
- Automatically detects format: `.parquet` uses Arrow, otherwise CSV via readr
- Example:
  ```r
  save_table(mtcars, "results.csv")
  save_table(mtcars, "results.parquet")
  ```

**`save_artifact(x, name)`**
- Saves text or raw data to `outputs/<notebook-stem>/artifacts/<name>`
- Example:
  ```r
  save_artifact("Model summary: ...", "summary.txt")
  ```

**`log_msg(message, name="run.log")`**
- Appends a log message to `outputs/<notebook-stem>/logs/<name>`
- Example:
  ```r
  log_msg("Analysis started")
  log_msg("Step 1 complete")
  ```

### Automatic Notebook Detection

Helpers automatically detect the current notebook name (`NB_STEM`) using:
1. **Manual override**: Set `NB_STEM` variable in your notebook
   ```python
   NB_STEM = "20241107-my-analysis"  # Python
   ```
   ```r
   NB_STEM <- "20241107-my-analysis"  # R
   ```
2. **Quarto environment**: `QUARTO_INPUT_FILE` (preferred, works in preview)
3. **knitr**: Current input file during render
4. **Editor context**: Active document in Positron/RStudio
5. **Command line**: `--file=` argument to Rscript

If auto-detection fails, set `NB_STEM` manually in a setup chunk.

### Output Organization

All helpers automatically create this structure:
```
outputs/
└── <notebook-stem>/
    ├── figures/      # savefig() / save_plot()
    ├── tables/       # savetbl() / save_table()
    ├── artifacts/    # saveartifact() / save_artifact()
    └── logs/         # log() / log_msg()
```

This keeps outputs organized per-notebook, making it easy to:
- Find results from specific analyses
- Clean up outputs for a single notebook
- Track what each notebook generates
- Avoid filename conflicts between notebooks

## 📝 Notebook Templates (Full Mode)

Full mode includes a template system for quickly creating new notebooks with pre-configured helper functions.

### Template Files

Located in `notebooks/_quoncierge/templates/`:
- **`_template-py.qmd`**: Python notebook template
- **`_template-r.qmd`**: R notebook template

### Using Templates

Create new notebooks from templates using the `bin/qnew` utility:

```bash
# Create R notebook (default)
bin/qnew my-analysis

# Create Python notebook explicitly
bin/qnew --py feature-analysis

# Create R notebook explicitly
bin/qnew --r quality-control
```

The utility automatically:
1. Creates a date-prefixed filename: `YYYYMMDD-your-slug.qmd`
2. Copies the appropriate template
3. Sets the title to your slug
4. Places it in `notebooks/`

### Python Template Structure

```markdown
---
title: "New Analysis (Python)"
format: html
toc: true
---

## Setup

```{python}
# Optional: set NB_STEM ONLY if auto-detection fails
# NB_STEM = "YYYYMMDD-my-analysis"

from notebooks._quoncierge._helpers import savefig, savetbl, saveartifact, log
```

## Quickstart: save outputs

```{python}
import pandas as pd, matplotlib.pyplot as plt

df = pd.DataFrame({"class": ["a","b","c","d"], "n": [3,7,2,5]})
fig, ax = plt.subplots()
df.plot.bar(x="class", y="n", ax=ax)
savefig("class_counts.png")     # → outputs/<this-notebook>/figures/
savetbl(df, "class_counts.csv") # → outputs/<this-notebook>/tables/
log("Python quickstart ok")
```

## Your analysis

```{python}
# ...
```
```

### R Template Structure

```markdown
---
title: "New Analysis (R)"
format: html
toc: true
---

## Setup

```{r}
# Optional: set NB_STEM only if auto-detection fails
# NB_STEM <- "YYYYMMDD-my-analysis"

source("notebooks/_quoncierge/_helpers.R")
library(ggplot2)
```

## Quickstart: save outputs

```{r}
df <- data.frame(
  class = c("a","b","c","d"),
  n = c(3,7,2,5)
)
p <- ggplot(df, aes(x=class, y=n)) + geom_col()
save_plot(p, "class_counts.png")  # → outputs/<this-notebook>/figures/
save_table(df, "class_counts.csv") # → outputs/<this-notebook>/tables/
log_msg("R quickstart ok")
```

## Your analysis

```{r}
# ...
```
```

### Customizing Templates

Edit template files to match your preferred workflow:

**Add standard imports:**
```python
# Add to Python template
import numpy as np
import seaborn as sns
sns.set_theme()
```

**Add standard setup:**
```r
# Add to R template
library(tidyverse)
theme_set(theme_minimal())
options(repr.plot.width=10, repr.plot.height=6)
```

**Add custom sections:**
```markdown
## Data Loading

```{python}
# Your standard data loading code
```

## EDA

```{python}
# Your standard EDA code
```
```

### Template Best Practices

✅ **Do:**
- Include helper function imports in setup chunk
- Show example usage of helpers in quickstart section
- Keep templates minimal - users can add more
- Document any optional settings (like NB_STEM)
- Use consistent formatting and style

❌ **Don't:**
- Hard-code specific analysis steps
- Include large amounts of boilerplate
- Set NB_STEM unless auto-detection fails
- Include project-specific code

### Template Variables

When `bin/qnew my-analysis` runs, it:
- **Slug**: Converts input to lowercase-with-dashes: `my-analysis`
- **Date tag**: Adds current date: `20241107`
- **Stem**: Combines them: `20241107-my-analysis`
- **Title**: Sets in YAML frontmatter: `title: "my-analysis"`

### Advanced: Creating Custom Templates

Add your own templates:

1. Create a new template file:
   ```bash
   cp notebooks/_quoncierge/templates/_template-py.qmd \
      notebooks/_quoncierge/templates/_template-custom.qmd
   ```

2. Modify `bin/qnew` to support your template:
   ```bash
   # Add a new flag like --custom
   case "$mode" in
     custom) cp "notebooks/_quoncierge/templates/_template-custom.qmd" "$dest" ;;
     # ... existing cases
   esac
   ```

3. Use your custom template:
   ```bash
   bin/qnew --custom my-special-analysis
   ```

### Troubleshooting Templates

**Template not found:**
- Verify templates exist: `ls notebooks/_quoncierge/templates/`
- Check `bin/qnew` is executable: `chmod +x bin/qnew`

**Wrong template applied:**
- Use explicit flag: `--py` or `--r`
- Check which templates exist in your project

**Title not set correctly:**
- sed might not be available on your system
- Manually edit the created notebook's YAML frontmatter

**NB_STEM not detected:**
- Make sure you're using Quarto 1.3+ (sets `QUARTO_INPUT_FILE`)
- Manually set `NB_STEM` in first cell if needed

## ❓ FAQ

### Which mode should I choose: Light or Full?

**Choose Light if:**
- You want minimal setup with maximum flexibility
- You prefer to organize your project your own way
- You're comfortable manually creating directories and notebooks
- You don't need automatic output routing

**Choose Full if:**
- You want an opinionated, batteries-included workflow
- You like automatic organization of outputs by notebook
- You want helper functions to save plots, tables, and logs
- You're working on multiple notebooks and want to keep outputs separated

**TL;DR:** Light = minimal scaffold. Full = complete workflow with helpers.

### Can I switch from Light to Full later?

Not easily. The modes create different directory structures and include different helpers. If you start with Light and later want Full features, you would need to:
1. Manually create the `notebooks/`, `data/`, `outputs/`, `bin/` directories
2. Copy the helper files from a Full project's `notebooks/_quoncierge/` directory
3. Set up the `bin/qnew` utility
4. Add the pre-commit hook

It's recommended to choose the mode that fits your workflow from the start.

### Can I use Quoncierge without GitHub?

Yes! If you don't have the GitHub CLI (`gh`) installed, Quoncierge will:
- Create a local Git repository
- Skip creating a remote GitHub repository
- Skip the push step
- Everything else works normally

You can still push to GitHub manually later using standard Git commands.

### Can I customize the Python packages that get installed?

Yes! Edit the package installation line in the setup script you're using:
- **Light mode**: Edit `setup_light.sh` around line 50
- **Full mode**: Edit `setup_full.sh` around line 238

Look for the line:
```bash
pip install numpy pandas matplotlib seaborn scikit-learn scipy biopython
```

Change it to include your preferred packages.

### How do I update my project's Python environment later?

After installing new packages with `pip install <package>`:
```bash
source .venv/bin/activate
pip install <new-package>
pip freeze > requirements.txt  # Update the requirements file
```

To recreate the environment on another machine:
```bash
source .venv/bin/activate
pip install -r requirements.txt
```

### Can I use conda/mamba instead of venv?

Yes, but you'll need to modify the scripts. The scripts use Python's built-in `venv` for simplicity and minimal dependencies. If you prefer conda/mamba:
1. Replace the `python3 -m venv .venv` line with your conda environment creation
2. Update the activation commands
3. Ensure Quarto can still find the Jupyter kernel

See the "Why venv instead of conda/mamba?" section in the README for more context.

### Why are my notebook outputs not being organized automatically?

This is a Full mode feature. If you're using Light mode, you need to organize outputs yourself.

In Full mode, if outputs aren't being auto-organized:
1. Check that you've imported/sourced the helpers: `from notebooks._quoncierge._helpers import *`
2. Verify the `NB_STEM` is being detected correctly
3. Try manually setting `NB_STEM` in a setup chunk
4. Ensure you're calling the helper functions (`savefig()`, not `plt.savefig()`)

### Can I use Quoncierge with R only (no Python)?

Not currently. Quoncierge requires Python for the Jupyter kernel setup. However, in Full mode, you can work primarily in R:
- Use R notebooks via `bin/qnew --r my-analysis`
- Use R helper functions (`save_plot()`, `save_table()`, etc.)
- The Python environment is still created but you don't have to use it

### How do I upgrade/update an existing Quoncierge project?

Quoncierge creates a project but doesn't manage it afterward. To get new features:
1. For helper functions: Copy the updated `_helpers.py` and `_helpers.R` files from a new project
2. For other features: Manually add them by comparing your project with a newly created one
3. Check the CHANGELOG.md to see what's new

Quoncierge is primarily a project generator, not a project manager.

### Will Quoncierge be deprecated?

As noted in the README, Quoncierge may become unnecessary as Positron IDE evolves and potentially incorporates similar functionality natively. The project is under active development as of October 2025, and will continue to be maintained as long as it provides value not covered by other tools.

### Can I contribute or suggest features?

Absolutely! See CONTRIBUTING.md for guidelines. Open an issue to:
- Report bugs
- Suggest features
- Ask questions
- Share how you're using Quoncierge

Pull requests are welcome for bug fixes and features that align with the Light/Full philosophy.

## 🛠 Configuration Variables

Both setup scripts have configuration variables at the top that you should customize before running:

### Required Configuration

**GITHUB_USERNAME** (Line 38-39 in both scripts)
```bash
GITHUB_USERNAME="username"  # CHANGE to your GitHub username
```
- Your GitHub username for Git commits and repo creation
- Required if you want GitHub integration

**GITHUB_EMAIL** (Line 39-40 in both scripts)
```bash
GITHUB_EMAIL="youremail@institution.edu"  # CHANGE to your email
```
- Your email address for Git commits
- Should match your GitHub account email

### Optional Configuration

**OPEN_WITH_POSITRON** (Line 40-41 in both scripts)
```bash
OPEN_WITH_POSITRON=true  # Set to false to skip Positron launch
```
- `true`: Automatically launch the project in Positron IDE after setup
- `false`: Skip Positron launch

**CORE_PACKAGES** (Line 56-64 in `setup_light.sh`)
```bash
CORE_PACKAGES=(
  numpy
  pandas
  matplotlib
  seaborn
  scikit-learn
  scipy
  biopython
)
```
- Array of Python packages to install in the virtual environment
- Edit this list to add or remove packages for your workflow
- In `setup_full.sh`, this is a direct `pip install` line (around line 238)

### Advanced Customization

Beyond these variables, you can also modify:

**GitHub Visibility** (around line 180 in both scripts)
```bash
gh repo create "$PROJECT_NAME" --private --source=. --remote=origin
```
- Change `--private` to `--public` to make repositories public by default

**Quarto Configuration**
- Edit the `_quarto.yml` generation section to customize Quarto settings
- Modify freeze behavior, execution options, or output formats

**Project Structure** (Full mode only)
```bash
mkdir -p notebooks data outputs bin
```
- Modify directory names or add additional directories

**Helper Functions** (Full mode only)
- Edit the Python and R helper functions in the `_helpers.py` and `_helpers.R` sections
- Customize output paths, default parameters, or add new helpers

**Templates** (Full mode only)
- Modify the `_template-py.qmd` and `_template-r.qmd` sections
- Customize the starter notebook structure

### Updating Your Environment

After creating a project, you can still customize it:

**Add Python packages:**
```bash
source .venv/bin/activate
pip install <new-package>
pip freeze > requirements.txt  # Update requirements file
```

**Modify helper functions:**
- Edit `notebooks/_quoncierge/_helpers.py` (Python helpers)
- Edit `notebooks/_quoncierge/_helpers.R` (R helpers)

**Customize templates:**
- Edit `notebooks/_quoncierge/templates/_template-py.qmd`
- Edit `notebooks/_quoncierge/templates/_template-r.qmd`

## 🤔Why venv instead of conda/mamba?

This project uses Python’s built-in [`venv`](https://docs.python.org/3/library/venv.html) for environment management to keep things simple, fast, and cross-platform with minimal setup friction.

-   No need to install Conda or Mamba.
-   Works cleanly with Quarto and Python kernels without extra configuration.
-   Easier to manage in lightweight or CI contexts.

If you prefer `conda` or `mamba`, you're welcome to adapt the environment setup — just ensure the Quarto CLI and a working Python kernel are available in your environment.

## 🌐 Claude Code Integration

Quoncierge includes built-in support for [Claude Code](https://docs.claude.com/en/docs/claude-code), Anthropic's official CLI tool, especially for web-based development sessions.

### What's Included

The `.claude/` directory contains:
- **`settings.json`**: Configures a SessionStart hook
- **`hooks/session-start.sh`**: Automatically runs when starting a Claude Code web session

### What the Hook Does

When you open Quoncierge in Claude Code on the web, the SessionStart hook automatically:
1. Detects that it's running in a remote environment
2. Installs ShellCheck for bash script linting
3. Sets up the development environment

This ensures that development tools are available in web sessions without manual setup.

### Hook Script

The hook only runs in remote environments (web sessions), not locally:

```bash
# Only run in remote environments (Claude Code on the web)
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi
```

### Development Benefits

With Claude Code integration:
- ✅ Automatic tool installation in web sessions
- ✅ Script validation with ShellCheck
- ✅ Consistent development environment
- ✅ No manual setup required

### Customizing the Hook

To add your own development tools, edit `.claude/hooks/session-start.sh`:

```bash
# Add additional tools
if ! command -v your-tool &> /dev/null; then
  echo "Installing your-tool..."
  apt-get install -y -qq your-tool > /dev/null 2>&1
  echo "✓ your-tool installed"
fi
```

### Local Development

The hook is designed not to interfere with local development:
- It only runs when `CLAUDE_CODE_REMOTE=true`
- Local Claude Code sessions skip the hook
- You can develop normally without Claude Code

For more information about hooks and Claude Code, see:
- [Claude Code documentation](https://docs.claude.com/en/docs/claude-code)
- [Claude Code hooks guide](https://docs.claude.com/en/docs/claude-code/hooks)

## 🔧 Troubleshooting

### `gh: command not found`

**Problem:** The script fails with `gh: command not found` or skips GitHub repository creation.

**Solution:**
1. Install the GitHub CLI: https://cli.github.com/
   - macOS: `brew install gh`
   - Linux: See [GitHub CLI installation guide](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)
   - Windows: Download from https://cli.github.com/
2. Authenticate: `gh auth login`
3. Re-run the setup script

**Alternative:** If you don't want to use GitHub, you can still use Quoncierge for local projects. The script will skip GitHub operations but create everything else.

### Python version conflicts

**Problem:** `python3: command not found` or incompatible Python version.

**Solution:**
- Ensure Python 3.8+ is installed: `python3 --version`
- On some systems, try `python` instead of `python3`
- Install Python 3 from https://www.python.org/downloads/

### Quarto not found

**Problem:** The script can't find the Quarto CLI.

**Solution:**
1. Install Quarto from https://quarto.org/docs/get-started/
   - macOS: `brew install --cask quarto`
   - Windows/Linux: Download installer from Quarto website
2. Verify installation: `quarto --version`
3. Ensure Quarto is in your `$PATH`

### Jupyter kernel not appearing in Quarto

**Problem:** After setup, Quarto doesn't recognize the project kernel.

**Solution:**
1. Verify kernel installation: `jupyter kernelspec list`
2. Check `_quarto.yml` has the correct kernel name
3. Restart your IDE/editor
4. Try rendering manually: `quarto render notebook.qmd`

### Permission denied errors

**Problem:** Script fails with permission errors when creating files or directories.

**Solution:**
- Ensure you have write permissions in the current directory
- Don't run the script with `sudo` (it should work as a regular user)
- Check that the target project directory doesn't already exist

### Git authentication issues

**Problem:** Git push fails with authentication errors.

**Solution:**
1. Configure Git credentials:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```
2. For GitHub: Use `gh auth login` to authenticate
3. For SSH: Set up SSH keys (https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

## 📜 License, Feedback, and Citations

Quoncierge is licensed under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) license. You’re free to share and adapt this work, even commercially, as long as you give appropriate credit.

If you adapt or improve this script for your own workflows, feel free to open a pull request or share a link. Quoncierge is under active development as of October 2025, with the expectation that it may end up deprecated as Positron features continue to be built out. If you have a question or a comment, feel free to create an issue.

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15833439.svg)](https://doi.org/10.5281/zenodo.15833439)

This repository is archived on Zenodo. If you'd like to cite it, you can use the DOI above.