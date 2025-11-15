# Changelog

All notable changes to Quoncierge will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project uses informal versioning with a "Light" (v0.1) and "Full" (v0.2) philosophy.

## [Unreleased]

### Changed
- Enhanced documentation with troubleshooting section
- Added success output examples
- Improved README with TL;DR section

## [v0.2] - 2025-11-07 - Claude Code Integration

### Added
- Claude Code web session support via SessionStart hook
- Automatic ShellCheck installation for web sessions
- `.claude/` directory with hooks configuration

### Changed
- Merged PR #6 for Claude Code integration

## [v0.2] - 2025-10-01 - Full Workflow (In Progress)

### Added
- **`setup_full.sh`**: Full-featured workflow script with:
  - Organized directory structure: `notebooks/`, `data/`, `outputs/`, `bin/`
  - Dynamic helper functions for R and Python:
    - `savefig()`/`save_plot()` - Auto-routes plots to `outputs/<notebook>/figures/`
    - `savetbl()`/`save_table()` - Auto-routes tables to `outputs/<notebook>/tables/`
    - `saveartifact()`/`save_artifact()` - Auto-routes files to `outputs/<notebook>/artifacts/`
    - `log()`/`log_msg()` - Logs to `outputs/<notebook>/logs/`
  - `bin/qnew` utility for creating new notebooks from templates
  - Pre-commit hook to prevent committing large files (>50MB) in `outputs/`
  - Starter notebook (`YYYYMMDD-init-analysis.qmd`) with working R+Python examples
  - Template system for R and Python notebooks
  - Mixed-language support (R + Python via reticulate)

### Changed
- **`setup.sh`** converted to shim that delegates to `setup_light.sh`
- README updated to document both Light and Full modes
- Steered users to choose between minimal (Light) and opinionated (Full) workflows

## [v0.1] - 2025-10-01 - Light Mode Split

### Added
- **`setup_light.sh`**: Minimal setup script extracted from original `setup.sh`
  - Creates Python virtual environment (`.venv/`)
  - Installs core packages: numpy, pandas, matplotlib, seaborn, scikit-learn, scipy, biopython
  - Registers project-local Jupyter kernel
  - Creates `_quarto.yml` configuration
  - Generates `.gitignore` and `requirements.txt`
  - Initializes Git repository
  - Creates private GitHub repo and pushes (if `gh` CLI available)
  - Optional Positron IDE launch

### Changed
- Split monolithic `setup.sh` into Light (minimal) and Full (opinionated) modes
- Maintained backward compatibility via shim approach

## [Initial Release] - 2025-07-08 - Monolithic Script

### Added
- Initial `setup.sh` script combining all functionality
- Python virtual environment setup
- Jupyter kernel registration
- Quarto configuration
- Git/GitHub integration
- README with project documentation
- DOI via Zenodo (10.5281/zenodo.15833439)
- Creative Commons Attribution 4.0 license
- Positron IDE integration

### Features
- Automatic project scaffolding
- Private GitHub repositories by default
- Quarto CLI detection
- Cross-platform support (macOS, Linux, Windows guidance)
- Minimal dependencies (Python 3, Quarto, GitHub CLI)

## [Initial Commit] - 2025-07-07

### Added
- Project initialization
- Basic README
- License file (CC BY 4.0)

---

## Version Philosophy

**Light (v0.1)**: Minimal Quarto + Python + GitHub scaffold. For users who want the basics without opinionated structure.

**Full (v0.2)**: Structured workflow with helpers and automated routing of notebook outputs. For users who want automatic saving by notebook, reproducibility scaffolding, and convenience helpers.

## Breaking Changes

None yet. The project maintains backward compatibility through the `setup.sh` shim.

## Deprecation Notice

As noted in the README, Quoncierge may be deprecated as Positron IDE features continue to evolve and potentially incorporate similar functionality natively.
