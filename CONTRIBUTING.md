# Contributing to Quoncierge

Thank you for your interest in contributing to Quoncierge! This document provides guidelines and information for contributors.

## 🎯 Project Philosophy

Quoncierge follows a **dual-mode philosophy**:

- **Light (v0.1)**: Minimal, unopinionated setup. Just the essentials.
- **Full (v0.2)**: Opinionated workflow with helpers, structure, and automation.

When contributing, please respect this separation. Features should clearly belong to one mode or the other, and breaking changes to Light mode should be avoided to maintain its simplicity.

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:
- Python 3.8 or higher
- Quarto CLI installed
- GitHub CLI (`gh`) installed and authenticated
- ShellCheck (for script validation): `brew install shellcheck` or see https://www.shellcheck.net/
- Basic familiarity with shell scripting

### Setting Up for Development

1. **Fork and clone the repository**:
   ```bash
   gh repo fork lkwhite/Quoncierge --clone
   cd Quoncierge
   ```

2. **Create a test project** to verify your changes:
   ```bash
   bash setup_light.sh test-project-light
   # or
   bash setup_full.sh test-project-full
   ```

3. **Test your changes** on a clean system if possible, or in a container.

## 🔧 Development Workflow

### Making Changes

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```

2. **Make your changes**:
   - Edit `setup_light.sh` for Light mode features
   - Edit `setup_full.sh` for Full mode features
   - Update `setup.sh` only if changing the shim logic
   - Keep scripts POSIX-compliant when possible

3. **Validate your scripts**:
   ```bash
   shellcheck setup_light.sh
   shellcheck setup_full.sh
   shellcheck setup.sh
   ```

4. **Test thoroughly**:
   - Test both Light and Full modes
   - Test with and without GitHub CLI
   - Test with and without Positron
   - Verify the generated project structure
   - Try rendering notebooks in Full mode

5. **Update documentation**:
   - Update README.md if adding/changing features
   - Update CHANGELOG.md with your changes
   - Add inline comments for complex logic
   - Update helper function documentation if applicable

### Testing Checklist

Before submitting a PR, verify:

- [ ] Script passes ShellCheck with no errors
- [ ] Light mode creates a minimal working project
- [ ] Full mode creates a complete working project with all features
- [ ] Generated projects can render Quarto notebooks successfully
- [ ] GitHub integration works (if `gh` is available)
- [ ] Positron launch works (if Positron is installed)
- [ ] Helper functions work correctly (Full mode)
- [ ] `bin/qnew` creates notebooks from templates (Full mode)
- [ ] Pre-commit hook prevents large file commits (Full mode)
- [ ] No breaking changes to existing workflows
- [ ] Documentation is updated

## 📝 Code Style Guidelines

### Shell Script Style

- Use 4-space indentation
- Use `"${variable}"` for variable expansion (with quotes and braces)
- Prefer `[[ ]]` over `[ ]` for conditionals when not requiring POSIX compliance
- Use meaningful variable names in `UPPER_CASE` for configuration
- Add comments explaining "why", not just "what"
- Keep functions modular and focused

### Example:
```bash
# Good
PROJECT_NAME="${1}"
if [[ -z "${PROJECT_NAME}" ]]; then
    echo "Error: Project name required"
    exit 1
fi

# Avoid
project=$1
if [ -z $project ]; then
    echo "Error: Project name required"
    exit 1
fi
```

### Comments

- Use header comments in scripts to explain purpose, usage, and requirements
- Add inline comments for complex logic, especially:
  - Notebook stem auto-detection logic
  - Helper function creation
  - Git hook setup
- Document configuration variables at the top of scripts

## 🐛 Reporting Bugs

When reporting bugs, please include:

1. **Quoncierge version/mode**: Light or Full, and which commit/version
2. **Environment**:
   - Operating system and version
   - Python version: `python3 --version`
   - Quarto version: `quarto --version`
   - GitHub CLI version: `gh --version`
3. **Steps to reproduce**: Exact command(s) you ran
4. **Expected behavior**: What you expected to happen
5. **Actual behavior**: What actually happened
6. **Error messages**: Full error output (use code blocks)
7. **Workarounds**: Any workarounds you discovered

## 💡 Suggesting Features

We welcome feature suggestions! Please:

1. **Check existing issues** first to avoid duplicates
2. **Describe the use case**: What problem does this solve?
3. **Specify the mode**: Should this be in Light, Full, or both?
4. **Consider the philosophy**: Does this fit the minimal (Light) or opinionated (Full) approach?
5. **Provide examples**: Show what the feature would look like in practice

### Feature Acceptance Criteria

Features are more likely to be accepted if they:
- Solve a real workflow pain point
- Fit clearly into Light or Full mode philosophy
- Don't add significant complexity
- Work cross-platform (macOS, Linux, and ideally Windows)
- Don't require additional dependencies beyond Python, Quarto, and `gh`

## 🔀 Pull Request Process

1. **Update documentation**:
   - Add your changes to CHANGELOG.md under `[Unreleased]`
   - Update README.md if adding user-facing features
   - Update inline documentation

2. **Ensure CI passes**:
   - ShellCheck validation
   - Any automated tests

3. **Write a clear PR description**:
   - What does this PR do?
   - Why is this change needed?
   - Which mode(s) does it affect?
   - How did you test it?
   - Any breaking changes?

4. **Link related issues**: Use "Fixes #123" or "Closes #123" syntax

5. **Be responsive**: Address review comments promptly

### PR Template

```markdown
## Description
Brief description of changes

## Motivation
Why is this change needed?

## Mode(s) Affected
- [ ] Light (v0.1)
- [ ] Full (v0.2)
- [ ] Both

## Testing
How did you test these changes?

## Checklist
- [ ] Scripts pass ShellCheck
- [ ] Tested Light mode
- [ ] Tested Full mode
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] No breaking changes (or clearly documented)

## Screenshots (if applicable)
Terminal output or examples
```

## 🏗️ Architecture Notes

### File Structure

```
Quoncierge/
├── setup.sh            # Shim → setup_light.sh (backward compatibility)
├── setup_light.sh      # v0.1 minimal setup
├── setup_full.sh       # v0.2 full workflow
├── README.md           # User documentation
├── CHANGELOG.md        # Version history
├── CONTRIBUTING.md     # This file
└── .claude/            # Claude Code integration
    ├── settings.json
    └── hooks/
        └── session-start.sh
```

### Design Decisions

1. **Why two scripts?**
   - Separation of concerns: minimal vs. opinionated
   - Users can choose their complexity level
   - Easier to maintain and test independently

2. **Why a shim?**
   - Backward compatibility for existing users
   - Gentle migration path
   - Clear steering toward making an active choice

3. **Why Python venv instead of conda?**
   - Minimal dependencies (Python built-in)
   - Fast and lightweight
   - Cross-platform consistency
   - Good integration with Quarto and Jupyter

4. **Why not modify setup.sh directly?**
   - It's a shim for backward compatibility
   - New features should go in `setup_light.sh` or `setup_full.sh`

## 🤝 Code of Conduct

- Be respectful and constructive
- Welcome newcomers and help them learn
- Focus on what's best for the project and users
- Assume good intentions
- Provide actionable feedback

## 📜 License

By contributing to Quoncierge, you agree that your contributions will be licensed under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) license.

## ❓ Questions?

- Open an issue for questions about contributing
- Tag issues with `question` label
- Check existing issues and documentation first

## 🙏 Recognition

Contributors will be recognized in:
- Git commit history
- GitHub contributors page
- Future acknowledgments in README (for significant contributions)

---

Thank you for helping make Quoncierge better! 🎉
