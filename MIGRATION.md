# Migration Guide

This guide helps you migrate existing projects to use Quoncierge or adopt Quoncierge features in your current workflow.

## Table of Contents

- [Migrating from Standalone Jupyter/Quarto](#migrating-from-standalone-jupyterquarto)
- [Converting Existing Projects to Quoncierge Structure](#converting-existing-projects-to-quoncierge-structure)
- [Migrating from Light to Full Mode](#migrating-from-light-to-full-mode)
- [Migrating from conda/mamba to venv](#migrating-from-condamamba-to-venv)
- [Adopting Just the Helper Functions](#adopting-just-the-helper-functions)

---

## Migrating from Standalone Jupyter/Quarto

If you currently work with Jupyter notebooks or Quarto documents without a structured project setup, here's how to adopt Quoncierge:

### Option 1: Start Fresh with Quoncierge

**Best for:** New projects or projects you're willing to reorganize

1. **Create a new Quoncierge project:**
   ```bash
   cd /path/to/quoncierge
   bash setup_light.sh my-project  # or setup_full.sh
   ```

2. **Copy your existing notebooks:**
   ```bash
   cp /path/to/old/notebooks/*.ipynb my-project/notebooks/
   # or for .qmd files
   cp /path/to/old/notebooks/*.qmd my-project/notebooks/
   ```

3. **Convert .ipynb to .qmd (optional but recommended):**
   ```bash
   cd my-project
   quarto convert notebooks/my-notebook.ipynb
   ```

4. **Update kernel references:**
   - Open each notebook
   - Change the kernel to your new project kernel
   - In Jupyter/Positron: Kernel → Change Kernel → select "my-project"

5. **Update import paths if needed:**
   - If you had custom modules, move them to the project directory
   - Update relative imports accordingly

### Option 2: Add Quoncierge Features to Existing Project

**Best for:** Established projects you can't easily reorganize

1. **Create a venv and Jupyter kernel:**
   ```bash
   cd /path/to/existing-project
   python3 -m venv .venv
   source .venv/bin/activate
   pip install jupyter ipykernel
   python -m ipykernel install --name="my-project" --display-name="Python (my-project)" --prefix=".venv"
   ```

2. **Add Quarto configuration:**
   Create `_quarto.yml`:
   ```yaml
   project:
     type: default

   execute:
     freeze: auto

   jupyter:
     kernelspec:
       name: my-project
       language: python
       display_name: "Python (my-project)"
   ```

3. **Add .gitignore:**
   ```bash
   cat > .gitignore <<'EOF'
   .venv/
   .Rproj.user
   .Rhistory
   .RData
   .DS_Store
   /.quarto/
   /_site/
   __pycache__/
   *.pyc
   .ipynb_checkpoints/
   EOF
   ```

4. **Create requirements.txt:**
   ```bash
   pip freeze > requirements.txt
   ```

---

## Converting Existing Projects to Quoncierge Structure

If you want to fully adopt the Quoncierge structure for an existing project:

### Light Mode Structure

1. **Backup your project:**
   ```bash
   cp -r my-project my-project-backup
   ```

2. **Create the basic structure:**
   ```bash
   cd my-project
   mkdir -p .venv
   # Move notebooks to root or keep them where they are
   ```

3. **Set up venv and kernel:**
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install jupyter ipykernel
   python -m ipykernel install --name="my-project" --display-name="Python (my-project)" --prefix=".venv"
   ```

4. **Install your packages:**
   ```bash
   pip install numpy pandas matplotlib  # Add your packages
   pip freeze > requirements.txt
   ```

5. **Add _quarto.yml** (see template in Option 2 above)

### Full Mode Structure

1. **Backup your project:**
   ```bash
   cp -r my-project my-project-backup
   ```

2. **Create directory structure:**
   ```bash
   cd my-project
   mkdir -p notebooks data outputs bin
   mkdir -p notebooks/_quoncierge/templates
   ```

3. **Move existing notebooks:**
   ```bash
   mv *.ipynb notebooks/  # or *.qmd
   # Rename with date prefix if desired: YYYYMMDD-analysis.qmd
   ```

4. **Copy helper files from a Full template:**
   ```bash
   # Create a temporary Full project to get the helpers
   cd /tmp
   bash /path/to/quoncierge/setup_full.sh temp-project

   # Copy helpers to your project
   cp -r temp-project/notebooks/_quoncierge/* my-project/notebooks/_quoncierge/
   cp temp-project/bin/qnew my-project/bin/
   chmod +x my-project/bin/qnew
   ```

5. **Add pre-commit hook:**
   ```bash
   mkdir -p .git/hooks
   cat > .git/hooks/pre-commit <<'EOF'
   #!/bin/bash
   # Block committing files >50MB under outputs/
   large_files=$(find outputs -type f -size +50M 2>/dev/null)
   if [ -n "$large_files" ]; then
     echo "❌ Cannot commit: files >50MB detected in outputs/"
     echo "$large_files"
     exit 1
   fi
   EOF
   chmod +x .git/hooks/pre-commit
   ```

6. **Update your notebooks to use helpers:**
   Add to your notebook setup cells:
   ```python
   from notebooks._quoncierge._helpers import savefig, savetbl, saveartifact, log
   ```

---

## Migrating from Light to Full Mode

**Warning:** This is not a one-click migration. Consider whether you truly need Full mode features.

### Prerequisites

- Backup your project
- Be prepared to manually update notebook paths
- Understand that some manual work is required

### Steps

1. **Create directory structure:**
   ```bash
   cd my-light-project
   mkdir -p notebooks data outputs bin
   mkdir -p notebooks/_quoncierge/templates
   ```

2. **Move notebooks:**
   ```bash
   # If you had notebooks in the root
   mv *.qmd notebooks/

   # Rename with date prefix (optional but recommended)
   cd notebooks
   for file in *.qmd; do
     mv "$file" "$(date +%Y%m%d)-$file"
   done
   ```

3. **Copy Full mode features:**
   Create a temporary Full project and copy:
   - `notebooks/_quoncierge/_helpers.py`
   - `notebooks/_quoncierge/_helpers.R`
   - `notebooks/_quoncierge/templates/`
   - `bin/qnew`

4. **Update _quarto.yml:**
   Add resources:
   ```yaml
   project:
     type: default
     resources:
       - notebooks/_quoncierge/_helpers.py
       - notebooks/_quoncierge/_helpers.R
       - notebooks/_metadata.yml
   ```

5. **Create notebooks/_metadata.yml:**
   ```yaml
   toc: true
   number-sections: false
   execute:
     freeze: auto
     echo: true
     warning: false
     message: false
   ```

6. **Add pre-commit hook** (see Full mode structure section above)

7. **Update notebooks to use helpers**

---

## Migrating from conda/mamba to venv

If you're currently using conda/mamba and want to switch to Python's venv:

### Why Migrate?

- Simpler, faster environment creation
- No additional dependencies
- Better integration with Quarto
- Easier CI/CD setup

### Migration Steps

1. **Export current environment:**
   ```bash
   conda env export > conda_environment.yml
   # or
   conda list --export > requirements-conda.txt
   ```

2. **Create pip requirements:**
   ```bash
   # Convert conda exports to pip requirements
   grep -v "^#" requirements-conda.txt | sed 's/==/==/g' > requirements.txt
   # You may need to manually edit this file
   ```

3. **Deactivate conda:**
   ```bash
   conda deactivate
   ```

4. **Create venv:**
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```

5. **Install packages:**
   ```bash
   pip install -r requirements.txt
   # Fix any package name differences between conda and pip
   ```

6. **Register Jupyter kernel:**
   ```bash
   pip install jupyter ipykernel
   python -m ipykernel install --name="my-project" --display-name="Python (my-project)" --prefix=".venv"
   ```

7. **Update _quarto.yml** to reference new kernel

8. **Test thoroughly:**
   - Open all notebooks
   - Verify they run with the new kernel
   - Check all imports work

### Common Issues

- **Package name differences:** Some conda packages have different names in pip (e.g., `pytorch` vs `torch`)
- **Binary dependencies:** Some packages may need system libraries installed
- **Version incompatibilities:** You might need to adjust version constraints

---

## Adopting Just the Helper Functions

If you like the helper functions but don't want the full Quoncierge setup:

### Extract Helper Functions

1. **Create a Full project temporarily:**
   ```bash
   bash setup_full.sh temp-project
   ```

2. **Copy just the helpers:**
   ```bash
   cp temp-project/notebooks/_quoncierge/_helpers.py your-project/
   cp temp-project/notebooks/_quoncierge/_helpers.R your-project/
   ```

3. **Use in your notebooks:**
   ```python
   # Python
   from _helpers import savefig, savetbl, saveartifact, log
   ```

   ```r
   # R
   source("_helpers.R")
   ```

4. **Customize paths:**
   Edit the helpers to change output paths if needed. By default they expect:
   ```
   outputs/<notebook-stem>/figures/
   outputs/<notebook-stem>/tables/
   outputs/<notebook-stem>/artifacts/
   outputs/<notebook-stem>/logs/
   ```

### Minimal Helper Setup

If you don't need auto-detection, create simpler helpers:

```python
# simple_helpers.py
import os

OUTPUT_DIR = "outputs"

def savefig(name, fig=None, dpi=300):
    import matplotlib.pyplot as plt
    path = os.path.join(OUTPUT_DIR, "figures", name)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    (fig or plt).savefig(path, dpi=dpi, bbox_inches="tight")
    print(f"saved {path}")
```

---

## General Migration Tips

### Before Migrating

- ✅ Backup everything
- ✅ Commit all changes to Git
- ✅ Test in a copy of your project first
- ✅ Read through this entire guide
- ✅ Check that you have Python 3.8+ and Quarto installed

### During Migration

- 📝 Document what you change
- 🧪 Test each step before proceeding
- 🔍 Keep track of import path changes
- 💾 Create a requirements.txt of your current environment

### After Migration

- ✅ Test all notebooks run successfully
- ✅ Verify outputs are generated correctly
- ✅ Update documentation/README
- ✅ Share learnings with your team

### Getting Help

- Check the [FAQ](README.md#-faq) for common questions
- Review the [Troubleshooting](README.md#-troubleshooting) section
- Open an issue on GitHub if you encounter problems

---

## Summary Comparison

| Migration Type | Difficulty | Time | Recommended? |
|---------------|------------|------|--------------|
| New project → Quoncierge | ⭐ Easy | 5 min | ✅ Yes |
| Existing → Light structure | ⭐⭐ Moderate | 30 min | ✅ Yes |
| Existing → Full structure | ⭐⭐⭐ Complex | 2+ hours | ⚠️ Depends |
| Light → Full | ⭐⭐⭐ Complex | 1-2 hours | ⚠️ Only if needed |
| conda → venv | ⭐⭐ Moderate | 30 min | ✅ Yes |
| Just adopt helpers | ⭐ Easy | 10 min | ✅ Yes |

Choose the migration path that best fits your needs and available time!
