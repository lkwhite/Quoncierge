#!/usr/bin/env bash
set -euo pipefail

# ============================================
# setup.sh — Quarto + Jupyter + GitHub Project Initializer
#
# USAGE:
#   bash setup.sh <project-name-or-path>
#
# WHAT THIS DOES
# - Creates a Quarto-compatible project
# - Sets up project-local Python venv with Jupyter kernel (stored under .venv)
# - Registers that kernel (so Quarto/Positron can see it)
# - Creates: notebooks/, data/, outputs/, bin/
# - Installs dynamic save helpers for R and Python (auto-detect NB_STEM from the notebook filename;
#   still honors a manual NB_STEM if you set it)
# - Provides R and Python templates that *show* how to use save helpers immediately
# - Creates a starter notebook (R) under notebooks/YYYYMMDD-init-analysis.qmd
# - Writes _quarto.yml and notebooks/_metadata.yml
# - Adds .gitignore (data/ ignored; typical clutter ignored)
# - Installs a pre-commit hook to block committing files >50MB *under outputs/*
# - (Optional) Creates a private GitHub repo via `gh` and pushes
# - (Optional) Opens the project in Positron
# ============================================

RAW_PROJECT_PATH="${1:-}"
if [ -z "$RAW_PROJECT_PATH" ]; then
  echo "Usage: bash setup.sh <project-name-or-path>"
  exit 1
fi

PROJECT_NAME="$(basename "$RAW_PROJECT_PATH")"
# Kernel name must be simple; display-name can be pretty
KERNEL_NAME="$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9._-' '-')"
KERNEL_DISPLAY="Python ($PROJECT_NAME)"

# --- EDIT THESE ---
GITHUB_USERNAME="username"           # <-- CHANGE to your GitHub username
GITHUB_EMAIL="youremail@institution" # <-- CHANGE to your GitHub-associated email
OPEN_WITH_POSITRON=true              # set to false to skip launch

# --- REQUIRE: Quarto CLI ---
if ! command -v quarto >/dev/null 2>&1; then
  echo "❌ Quarto CLI not found. Install from https://quarto.org/docs/get-started/"
  echo "   Mac:    brew install --cask quarto"
  echo "   Win:    choco install quarto"
  echo "   Linux:  see Quarto docs"
  exit 1
fi

# --- CREATE PROJECT DIR ---
mkdir -p "$RAW_PROJECT_PATH"
cd "$RAW_PROJECT_PATH"

# --- PROJECT DIRS ---
mkdir -p notebooks data outputs
mkdir -p bin
mkdir -p notebooks/_quoncierge/templates

# --- INTERNAL NOTEBOOK HELPERS (dynamic NB_STEM) ---

# Python helpers
cat > notebooks/_quoncierge/_helpers.py <<'EOF'
# Quoncierge notebook helpers (Python)
import os
from typing import Optional

def _detect_nb_stem() -> str:
    """
    Best-effort detection of the current notebook/file stem when running under Quarto.
    Priority:
      1) Respect a user-defined NB_STEM (and ignore placeholder)
      2) QUARTO_INPUT_FILE env (present in recent Quarto versions)
      3) papermill-style envs (PAPERMILL_INPUT_PATH / INPUT_PATH)
      4) Fallback: raise with guidance
    """
    nb_stem = globals().get("NB_STEM")
    if isinstance(nb_stem, str) and nb_stem and nb_stem != "NB_STEM_PLACEHOLDER":
        return nb_stem

    q_input = os.environ.get("QUARTO_INPUT_FILE")
    if q_input:
        return os.path.splitext(os.path.basename(q_input))[0]

    for key in ("PAPERMILL_INPUT_PATH", "INPUT_PATH"):
        p = os.environ.get(key)
        if p:
            return os.path.splitext(os.path.basename(p))[0]

    raise RuntimeError(
        "Could not determine NB_STEM automatically.\n"
        "Define NB_STEM = 'YYYYMMDD-my-analysis' in a setup cell, or\n"
        "update Quarto so QUARTO_INPUT_FILE is available."
    )

def _root() -> str:
    return os.path.join("outputs", _detect_nb_stem())

def savefig(name: str, fig=None, dpi: int = 300):
    import matplotlib.pyplot as plt  # lazy import
    path = os.path.join(_root(), "figures", name)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    (fig or plt).savefig(path, dpi=dpi, bbox_inches="tight")
    print(f"saved {path}")

def savetbl(df, name: str):
    path = os.path.join(_root(), "tables", name)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    if name.lower().endswith(".parquet"):
        df.to_parquet(path, index=False)
    else:
        df.to_csv(path, index=False)
    print(f"saved {path}")

def saveartifact(bytes_or_str, name: str, binary: Optional[bool] = None):
    path = os.path.join(_root(), "artifacts", name)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    if binary is None:
        binary = isinstance(bytes_or_str, (bytes, bytearray))
    mode = "wb" if binary else "w"
    with open(path, mode) as f:
        f.write(bytes_or_str)
    print(f"saved {path}")

def log(message: str, name: str = "run.log"):
    path = os.path.join(_root(), "logs", name)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "a") as f:
        f.write(message.rstrip() + "\n")
EOF

# R helpers
cat > notebooks/_quoncierge/_helpers.R <<'EOF'
# Quoncierge notebook helpers (R)

.detect_nb_stem <- function() {
  # 1) Respect NB_STEM if user set it (and not placeholder)
  if (exists("NB_STEM", envir = .GlobalEnv, inherits = FALSE)) {
    val <- get("NB_STEM", envir = .GlobalEnv, inherits = FALSE)
    if (!is.null(val) && nzchar(val) && val != "NB_STEM_PLACEHOLDER") return(val)
  }

  # 2) Quarto (recent) sets QUARTO_INPUT_FILE (works even in preview)
  q <- Sys.getenv("QUARTO_INPUT_FILE", unset = NA)
  if (!is.na(q) && nzchar(q)) {
    return(tools::file_path_sans_ext(basename(q)))
  }

  # 3) knitr path (works during render/knit)
  if (requireNamespace("knitr", quietly = TRUE)) {
    inp <- tryCatch(knitr::current_input(), error = function(e) NULL)
    if (!is.null(inp) && nzchar(inp)) {
      return(tools::file_path_sans_ext(basename(inp)))
    }
  }

  # 4) Editor context (interactive Positron/RStudio)
  if (requireNamespace("rstudioapi", quietly = TRUE)) {
    ctx <- tryCatch(rstudioapi::getActiveDocumentContext(), error = function(e) NULL)
    if (!is.null(ctx) && !is.null(ctx$path) && nzchar(ctx$path)) {
      return(tools::file_path_sans_ext(basename(ctx$path)))
    }
  }

  # 5) Command-line knit
  args <- commandArgs(trailingOnly = FALSE)
  hit <- grep("^--file=", args, value = TRUE)
  if (length(hit) == 1) {
    f <- sub("^--file=", "", hit)
    if (nzchar(f)) return(tools::file_path_sans_ext(basename(f)))
  }

  stop('Could not determine NB_STEM. Set NB_STEM <- "YYYYMMDD-my-analysis" in a setup chunk.')
}


.root <- function() file.path("outputs", .detect_nb_stem())

save_plot <- function(p, name, width=6, height=4, dpi=300) {
  path <- file.path(.root(), "figures", name)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  ggplot2::ggsave(path, plot = p, width = width, height = height, dpi = dpi)
  message("saved ", path)
}

save_table <- function(df, name) {
  path <- file.path(.root(), "tables", name)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  if (grepl("\\.parquet$", tolower(name))) {
    arrow::write_parquet(df, path)
  } else {
    readr::write_csv(df, path)
  }
  message("saved ", path)
}

save_artifact <- function(x, name) {
  path <- file.path(.root(), "artifacts", name)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  if (is.raw(x)) {
    con <- file(path, "wb"); on.exit(close(con), add=TRUE); writeBin(x, con)
  } else {
    readr::write_file(as.character(x), path)
  }
  message("saved ", path)
}

log_msg <- function(message, name="run.log") {
  path <- file.path(.root(), "logs", name)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  cat(paste0(message, "\n"), file = path, append = TRUE)
}
EOF

# --- OPTIONAL: R packages to support mixed-language interactive use ---
if command -v Rscript >/dev/null 2>&1; then
  Rscript -e 'pkgs <- c("reticulate","ggplot2","readr","arrow");
              inst <- rownames(installed.packages());
              need <- setdiff(pkgs, inst);
              if(length(need)) install.packages(need, repos="https://cloud.r-project.org")'
fi

# --- GIT IDENTITY ---
git config --global user.name  "$GITHUB_USERNAME"
git config --global user.email "$GITHUB_EMAIL"

# --- PYTHON VENV + CORE PACKAGES ---
python3 -m venv .venv
# shellcheck disable=SC1091
source .venv/bin/activate

pip install --upgrade pip
pip install jupyter ipykernel
# IMPORTANT: --prefix MUST be .venv so Quarto in Positron can see the kernel
python -m ipykernel install --name="$KERNEL_NAME" --display-name="$KERNEL_DISPLAY" --prefix=".venv"

# Optional DS stack (edit to taste)
pip install numpy pandas matplotlib seaborn scikit-learn scipy biopython

# --- QUARTO CONFIG: pin kernel + freeze ---
cat > _quarto.yml <<EOF
project:
  type: default
  resources:
    - notebooks/_quoncierge/_helpers.py
    - notebooks/_quoncierge/_helpers.R
    - notebooks/_metadata.yml

execute:
  kernel: $KERNEL_NAME
  freeze: auto

format:
  html: default

metadata-files:
  - notebooks/_metadata.yml
EOF

# --- bin/qnew utility (R by default if template present; else Python) ---
cat > bin/qnew <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
# Usage: bin/qnew [--r|--py] <slug words...>
mode="auto"
if [[ "${1:-}" == "--r" || "${1:-}" == "--py" ]]; then
  mode="${1#--}"; shift
fi
if [[ $# -lt 1 ]]; then
  echo "Usage: bin/qnew [--r|--py] <slug>"; exit 1
fi
slug="$(echo "$*" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
date_tag="$(date +%Y%m%d)"
stem="${date_tag}-${slug}"
dest="notebooks/${stem}.qmd"
if [[ -e "$dest" ]]; then
  echo "Refusing to overwrite existing ${dest}" >&2
  exit 2
fi

tpl_py="notebooks/_quoncierge/templates/_template-py.qmd"
tpl_r="notebooks/_quoncierge/templates/_template-r.qmd"

choose_py() { cp "$tpl_py" "$dest"; echo "Created Python notebook: $dest"; }
choose_r()  { cp "$tpl_r" "$dest"; echo "Created R notebook: $dest"; }

case "$mode" in
  py) choose_py ;;
  r)  if [[ -f "$tpl_r" ]]; then choose_r; else echo "R template not found; creating Python notebook instead." >&2; choose_py; fi ;;
  auto) if [[ -f "$tpl_r" ]]; then choose_r; else choose_py; fi ;;
esac

# best-effort: set title to the slug on the first title line
if command -v sed >/dev/null 2>&1; then
  sed -i.bak -E "1,10s/^title:.*/title: \"${slug}\"/;" "$dest" || true
  rm -f "${dest}.bak"
fi
EOF
chmod +x bin/qnew

# --- Notebooks metadata defaults ---
cat > notebooks/_metadata.yml <<'EOF'
# Defaults applied to all notebooks under notebooks/
toc: true
number-sections: false

execute:
  freeze: auto
  echo: true
  warning: false
  message: false
EOF

# --- Templates (show save_* usage; no NB_STEM hard-coding) ---
cat > notebooks/_quoncierge/templates/_template-py.qmd <<'EOF'
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
savefig("class_counts.png")     # -> outputs/<this-notebook>/figures/
savetbl(df, "class_counts.csv") # -> outputs/<this-notebook>/tables/
log("Python quickstart ok")
```

## Your analysis

```{python}
# ...
```
EOF

cat > notebooks/_quoncierge/templates/_template-r.qmd <<'EOF'
---
title: "New Analysis (R)"
format: html
toc: true
---

## Setup

```{r}
# Optional: set NB_STEM ONLY if auto-detection fails
# NB_STEM <- "YYYYMMDD-my-analysis"

# Optional: point reticulate at the project venv if you plan to mix R+Python
venv_py <- if (.Platform$OS.type == "windows") ".venv/Scripts/python.exe" else ".venv/bin/python"
if (file.exists(venv_py)) Sys.setenv(RETICULATE_PYTHON = normalizePath(venv_py, winslash = "/"))

# Load helpers (auto-detects NB_STEM from this file name)
source("notebooks/_quoncierge/_helpers.R")
```

## Quickstart: save outputs

```{r}
library(ggplot2); library(dplyr)
df <- ggplot2::mpg |>
  count(class, name = "n")

p <- ggplot(df, aes(class, n)) + geom_col() + coord_flip()
save_plot(p, "class_counts.png")     # -> outputs/<this-notebook>/figures/
save_table(df, "class_counts.csv")   # -> outputs/<this-notebook>/tables/
log_msg("R quickstart ok")
```

## Your analysis

```{r}
# ...
```
EOF

# --- .gitignore (track outputs/, ignore data/ and clutter) ---
cat > .gitignore <<'EOF'
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

# Project structure
data/
EOF

# --- STARTER NOTEBOOK in notebooks/ (R) ---
DATE=$(date +%Y%m%d)
STARTER_NOTE="notebooks/${DATE}-init-analysis.qmd"

cat > "$STARTER_NOTE" <<'EOF'
---
title: "Init Analysis"
format: html
toc: true
---

> This project was initialized by **Quoncierge**.  
> Outputs are saved under `outputs/<this-file-name-without-ext>/{figures,tables,artifacts,logs}`.

## Setup (R)

```{r}
# Optional: set NB_STEM ONLY if auto-detection fails
# NB_STEM <- "YYYYMMDD-init-analysis"

source("notebooks/_quoncierge/_helpers.R")
```

## Quick check (R)

```{r}
library(ggplot2)
df <- data.frame(x = 1:3, y = c(2,4,6))

# Save a table + figure using the helpers
save_table(df, "example-r.csv")
p <- ggplot(df, aes(x,y)) + geom_point() + geom_line()
save_plot(p, "example-r.png")

log_msg("R starter ran successfully")
```

---

### Create another notebook

From the project root, use the `qnew` helper:

- `bin/qnew baseline-qc` → creates `notebooks/YYYYMMDD-baseline-qc.qmd` (R template by default)  
- `bin/qnew --py feature-scan` → creates a Python notebook  
- `bin/qnew --r qc-report` → creates an R notebook

EOF

# --- README (short) ---
cat > README.md <<EOF
# $PROJECT_NAME

Initialized with **Quoncierge** (light org mode).

## Structure
- \`notebooks/\` — your analysis notebooks (named like \`YYYYMMDD_slug.qmd\`)
- \`data/\` — inputs and intermediates (git-ignored by default)
- \`outputs/\` — generated plots, tables, logs, and artifacts (tracked; hook blocks >50MB)

## Environment
- Project-local Python venv in \`.venv\`
- Registered Jupyter kernel: \`$KERNEL_DISPLAY\`

## Tips
- Keep large raw data in \`data/\`. Use \`outputs/\` for derived artifacts you want tracked.
- If auto-detection of NB_STEM ever fails, set it at the top of a notebook:
  - R: \`NB_STEM <- "YYYYMMDD-my-analysis"\`
  - Py: \`NB_STEM = "YYYYMMDD-my-analysis"\`
EOF

# --- Freeze dependencies ---
pip freeze > requirements.txt

# --- PRE-COMMIT HOOK: block committing >50MB files *under outputs/* ---
mkdir -p .git/hooks
cat > .git/hooks/pre-commit <<'EOF'
#!/usr/bin/env bash
# Block committing files >= 50MB under outputs/ (GitHub's soft limit)
limit=$((50 * 1024 * 1024))
fail=0

while IFS= read -r -d '' file; do
  case "$file" in
    outputs/*)
      if [ -f "$file" ]; then
        size=$(wc -c < "$file")
        if [ "$size" -ge "$limit" ]; then
          echo "❌ $file is ${size} bytes (>= 50MB). Commit blocked."
          echo "   Keep large artifacts out of git. Use data/ or external storage."
          fail=1
        fi
      fi
      ;;
  esac
done < <(git diff --cached --name-only -z)

[ "$fail" -eq 0 ] || exit 1
exit 0
EOF
chmod +x .git/hooks/pre-commit

# --- GIT INIT + FIRST COMMIT ---
git init -b main
git add .
git commit -m "Initial commit"

# --- GitHub: create remote and push (optional) ---
if command -v gh >/dev/null 2>&1; then
  git branch -M main
  gh repo create "$PROJECT_NAME" --private --source=. --remote=origin --push --confirm || {
    echo "⚠️ GitHub repo creation/push skipped or failed."
  }
else
  echo "⚠️ GitHub CLI (gh) not found. Skipping remote creation."
  echo "   Install: https://cli.github.com/ and run: gh auth login"
fi

# --- Open in Positron (if configured and available) ---
if $OPEN_WITH_POSITRON && command -v positron >/dev/null 2>&1; then
  positron .
else
  echo "✅ Project ready at: $(pwd)"
fi
