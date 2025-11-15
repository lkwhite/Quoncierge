# Media Creation Guide

This guide provides recommendations for creating screenshots, screencasts, and demo videos for Quoncierge documentation.

## Screenshots

### What to Capture

**Essential Screenshots:**

1. **Successful Setup Output** (Both Light and Full modes)
   - Terminal showing the complete setup process
   - All checkmarks and success messages
   - Final "Setup complete!" message

2. **Project Structure** (Both modes)
   - Light mode: File tree showing minimal structure
   - Full mode: File tree showing complete directory layout

3. **Helper Functions in Action** (Full mode only)
   - Code cell showing helper imports
   - Running `savefig()` with output message
   - Resulting file structure in `outputs/`

4. **Quarto Rendering**
   - Command: `quarto render notebooks/YYYYMMDD-analysis.qmd`
   - Successful render output
   - Generated HTML file

5. **`qnew` Utility** (Full mode only)
   - Running `bin/qnew my-analysis`
   - Created notebook file
   - Template contents

### Screenshot Tools

**macOS:**
- Built-in: `Cmd+Shift+3` (full screen) or `Cmd+Shift+4` (selection)
- Terminal-specific: `Cmd+Shift+4`, then press `Space`, click terminal window

**Linux:**
- gnome-screenshot: `gnome-screenshot -a` (area selection)
- flameshot: `flameshot gui` (feature-rich)
- scrot: `scrot -s` (selection mode)

**Windows:**
- Snipping Tool or Snip & Sketch (built-in)
- ShareX (advanced, free)

### Screenshot Guidelines

✅ **Do:**
- Use a clean, minimal terminal theme
- Ensure text is readable (minimum 14pt font)
- Crop to relevant content only
- Use consistent window sizes
- Show the command and full output
- Include the prompt to show context

❌ **Don't:**
- Include sensitive information (API keys, real emails, personal data)
- Use light-on-light or dark-on-dark color schemes
- Crop out important context
- Include unnecessary desktop clutter
- Use tiny fonts that are hard to read

### Example Screenshot Workflow

```bash
# 1. Set up a clean environment
cd /tmp
git clone https://github.com/lkwhite/Quoncierge.git
cd Quoncierge

# 2. Configure a test username/email
sed -i 's/username/demo-user/' setup_light.sh
sed -i 's/youremail@institution.edu/demo@example.com/' setup_light.sh

# 3. Run the setup (for demo purposes)
bash setup_light.sh demo-project

# 4. Take screenshot of terminal output
# 5. Capture the resulting file structure
ls -la demo-project/
```

## Screen Recordings / Screencasts

### What to Record

**Recommended Videos:**

1. **Quick Start (30-60 seconds)**
   - Clone repo
   - Run setup script
   - Show resulting project structure
   - No audio needed, use text overlays

2. **Full Mode Demo (2-3 minutes)**
   - Create project
   - Walk through directory structure
   - Open starter notebook
   - Run cells showing helpers
   - Show auto-generated outputs
   - Demo `qnew` utility

3. **Helper Functions Tutorial (1-2 minutes)**
   - Import helpers
   - Create a simple plot
   - Save with `savefig()`
   - Show organized output directory
   - Explain automatic notebook detection

### Recording Tools

**Cross-platform:**
- **OBS Studio** (Free, powerful): https://obsproject.com/
- **asciinema** (Terminal-only, text-based): https://asciinema.org/

**macOS:**
- QuickTime Player (built-in, simple)
- ScreenFlow (paid, professional)
- Kap (free, simple): https://getkap.co/

**Linux:**
- SimpleScreenRecorder
- Kazam
- Peek (GIF recorder)

**Windows:**
- Xbox Game Bar (built-in)
- OBS Studio
- ShareX

### Recording Guidelines

**Video Settings:**
- Resolution: 1920x1080 (1080p) or 2560x1440 (1440p)
- Frame rate: 30fps minimum, 60fps preferred
- Format: MP4 (H.264) for broad compatibility
- Audio: 48kHz if including narration

**Terminal Settings:**
- Font size: 14-16pt minimum
- Theme: High contrast (e.g., Solarized Dark, Dracula)
- Window size: 120x30 or similar (readable but not tiny)
- Disable distracting elements (clock, notifications)

**Recording Tips:**
- Plan your steps before recording
- Use a script or outline
- Type at a moderate, readable pace
- Pause between commands to let output settle
- Add 2-3 seconds of padding at start/end for editing

### Example asciinema Recording

```bash
# Install asciinema
# macOS: brew install asciinema
# Linux: apt-get install asciinema / pacman -S asciinema

# Start recording
asciinema rec quoncierge-demo.cast

# Perform your demo
cd /tmp
git clone https://github.com/lkwhite/Quoncierge.git
cd Quoncierge
bash setup_light.sh demo-project

# Stop recording with Ctrl+D

# Upload to asciinema.org (optional)
asciinema upload quoncierge-demo.cast

# Or convert to GIF
asciinema2gif quoncierge-demo.cast quoncierge-demo.gif
```

## GIFs

### When to Use GIFs

GIFs are great for:
- Embedding in README or documentation
- Showing quick workflows (< 30 seconds)
- Demonstrating UI interactions
- Email-friendly demos

### GIF Creation Tools

**Dedicated GIF Recorders:**
- **Kap** (macOS): https://getkap.co/
- **Peek** (Linux): https://github.com/phw/peek
- **ScreenToGif** (Windows): https://www.screentogif.com/

**Video to GIF Converters:**
- **ffmpeg** (CLI, all platforms):
  ```bash
  ffmpeg -i input.mp4 -vf "fps=15,scale=1080:-1:flags=lanczos" -c:v gif output.gif
  ```
- **GIPHY Capture** (macOS): https://giphy.com/apps/giphycapture
- **Online converters**: ezgif.com, cloudconvert.com

### GIF Guidelines

✅ **Optimize for size:**
- Keep under 10MB if possible
- Use 10-15 fps (don't need full 30/60fps)
- Reduce dimensions if needed (e.g., 720p instead of 1080p)
- Limit duration to 15-30 seconds max
- Use tools like gifsicle to optimize

❌ **Avoid:**
- Giant file sizes (>20MB)
- Too many colors (limit to 256)
- Extremely long GIFs
- Text that's too small to read

### Example GIF Workflow

```bash
# Record with QuickTime or OBS
# Save as demo.mp4

# Convert to optimized GIF with ffmpeg
ffmpeg -i demo.mp4 \
  -vf "fps=15,scale=1080:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
  -loop 0 \
  output.gif

# Further optimize with gifsicle (if needed)
gifsicle -O3 --lossy=80 -o output-optimized.gif output.gif
```

## Demo Scenarios

### Scenario 1: "Hello World" Demo

**Goal:** Show how quick it is to get started

**Steps:**
1. Show terminal in empty directory
2. Clone Quoncierge repo
3. Run `bash setup_light.sh my-first-project`
4. Show success output
5. `cd my-first-project && ls -la`
6. Show `_quarto.yml` and `requirements.txt` were created

**Duration:** ~30 seconds
**Format:** GIF or quick video

### Scenario 2: Full Mode Workflow

**Goal:** Demonstrate organized project structure and helpers

**Steps:**
1. Run `bash setup_full.sh analysis-project`
2. Show created directory structure
3. Open `notebooks/YYYYMMDD-init-analysis.qmd` in IDE
4. Run cells to show helper functions working
5. Show `outputs/` directory with auto-organized files
6. Demo `bin/qnew new-analysis` creating a new notebook

**Duration:** 2-3 minutes
**Format:** Video with optional narration

### Scenario 3: Helper Functions Tutorial

**Goal:** Teach users how to use save helpers

**Steps:**
1. Open Python notebook
2. Import helpers: `from notebooks._quoncierge._helpers import savefig, savetbl`
3. Create a simple plot
4. Save it: `savefig("my-plot.png")`
5. Show the saved file in `outputs/<notebook>/figures/`
6. Create a DataFrame
7. Save it: `savetbl(df, "my-data.csv")`
8. Show the saved table in `outputs/<notebook>/tables/`

**Duration:** 1-2 minutes
**Format:** Video or detailed GIF series

## Including Media in Documentation

### In README.md

```markdown
## Demo

![Quoncierge Setup Demo](docs/media/setup-demo.gif)

*Quick setup of a new Quoncierge project*
```

### In Issues/PRs

Use relative paths or upload directly to GitHub:

```markdown
Here's what it looks like:

![screenshot](https://user-images.githubusercontent.com/...)
```

### In Documentation Site

If you have a docs site:

```markdown
<video width="100%" controls>
  <source src="/videos/full-mode-demo.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
```

## Media Storage

### Where to Store Media

**For GitHub:**
- Small images (<1MB): Commit directly to `docs/media/` or `assets/`
- GIFs (<10MB): Commit to repo
- Videos (>10MB): Use GitHub Releases or external hosting

**External Hosting:**
- YouTube (videos): Unlisted if you don't want public visibility
- Imgur (images/GIFs): Free, no account needed for small files
- asciinema.org (terminal recordings): Purpose-built for terminal demos

### Directory Structure

```
Quoncierge/
├── docs/
│   └── media/
│       ├── screenshots/
│       │   ├── setup-light-output.png
│       │   ├── setup-full-output.png
│       │   └── project-structure.png
│       ├── gifs/
│       │   ├── quick-start.gif
│       │   └── helper-demo.gif
│       └── videos/
│           └── full-walkthrough.mp4  # (if small enough)
```

## Checklist for Contributors

Before submitting media:

- [ ] Screenshot/video shows only non-sensitive information
- [ ] Text is readable (14pt+ font)
- [ ] File size is reasonable (<10MB for GIFs, <50MB for videos)
- [ ] Filename is descriptive (e.g., `setup-light-success.png`)
- [ ] Media demonstrates the intended feature clearly
- [ ] Added appropriate caption/description
- [ ] Tested that media displays correctly in README/docs

## Examples to Create

**High Priority:**
1. ✅ Screenshot: Successful setup output (both modes)
2. ✅ Screenshot: Project directory structure (both modes)
3. ✅ GIF: Quick start from clone to completed setup (30s)
4. ⚠️ Screenshot: Helper functions in use
5. ⚠️ Screenshot: `qnew` creating a new notebook

**Medium Priority:**
6. ⚠️ Video: Full mode complete walkthrough (2-3min)
7. ⚠️ GIF: Auto-organized outputs demo
8. ⚠️ Screenshot: Quarto rendering process

**Nice to Have:**
9. ⚠️ Video: Troubleshooting common issues
10. ⚠️ GIF: Switching kernels in Positron
11. ⚠️ asciinema: Terminal-only setup demo

---

**Note:** As you create media, update this checklist and add the actual files to the repository. Link to them in the main README.md for maximum visibility.

## Questions?

If you're creating media for Quoncierge and have questions:
- Open an issue with the `documentation` label
- Ask in discussions
- Reference this guide when submitting PRs with media
