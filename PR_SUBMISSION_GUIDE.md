# Step-by-Step Guide: Submitting a Pull Request to ESPHome

This guide walks you through the complete process of contributing to the ESPHome project.

## Prerequisites

- [ ] GitHub account
- [ ] Git installed locally
- [ ] Python 3.9 or later
- [ ] Familiarity with YAML and basic Python

## Phase 1: Preparation (Before Coding)

### Step 1: Join the ESPHome Community
- [ ] Join ESPHome Discord: https://discord.gg/KhAMKrd
- [ ] Introduce yourself in #introductions
- [ ] Ask in #dev channel if your contribution would be welcome

### Step 2: Check Existing Work
- [ ] Search existing issues: https://github.com/esphome/esphome/issues
- [ ] Check existing PRs: https://github.com/esphome/esphome/pulls
- [ ] Verify your idea isn't already implemented or rejected

### Step 3: Open a Discussion (Optional but Recommended)
- [ ] Go to: https://github.com/orgs/esphome/discussions
- [ ] Create a new discussion describing your contribution
- [ ] Wait for feedback from maintainers
- [ ] Adjust your plan based on feedback

## Phase 2: Setup Development Environment

### Step 4: Fork the Repository
```bash
# Go to https://github.com/esphome/esphome
# Click "Fork" button (top right)
# This creates your own copy of the repository
```

### Step 5: Clone Your Fork
```bash
cd ~/projects  # or your preferred directory
git clone https://github.com/YOUR_USERNAME/esphome.git
cd esphome
```

### Step 6: Add Upstream Remote
```bash
git remote add upstream https://github.com/esphome/esphome.git
git remote -v  # Verify remotes are set up
```

### Step 7: Create Development Environment
```bash
# Install development dependencies
script/setup

# Activate virtual environment (created by setup script)
source venv/bin/activate  # Linux/Mac
# OR
venv\Scripts\activate  # Windows
```

### Step 8: Install Pre-commit Hooks
```bash
pre-commit install
```

## Phase 3: Make Your Changes

### Step 9: Create a Feature Branch
```bash
# Sync with upstream first
git fetch upstream
git checkout dev
git merge upstream/dev

# Create your branch (use descriptive name)
git checkout -b feature/lvgl-display-examples
# OR
git checkout -b boards/add-guition-displays
```

### Step 10: Make Your Changes

Choose your contribution type:

#### Option A: Adding Display Examples to LVGL Component

1. **Create example file:**
```bash
cd esphome/components/lvgl
# Create your example YAML file
cp hello_world.yaml touchscreen_example.yaml
```

2. **Edit the example:**
- Include comprehensive comments
- Show best practices
- Make it hardware-agnostic where possible
- Test on real hardware

3. **Update component README if needed:**
```bash
# Add reference to your example
vim README.md  # or your preferred editor
```

#### Option B: Adding Board Definitions

1. **Edit boards.py:**
```bash
cd esphome/components/esp32
vim boards.py
```

2. **Add board definitions:**
```python
# Find the ESP32_BOARD_PINS dictionary
# Add your board(s) following existing pattern

"guition_esp32_4848s040": {
    "SDA": 19,
    "SCL": 45,
    "LED": 38,
    "BUTTON": 0,
    # Add all relevant pins
},
```

3. **Test your board definition:**
```yaml
# Create test YAML
esp32:
  board: guition_esp32_4848s040
```

#### Option C: Adding Documentation

1. **Clone docs repo (separate):**
```bash
cd ~/projects
git clone https://github.com/esphome/esphome-docs.git
cd esphome-docs
```

2. **Create/edit documentation:**
```bash
# Documentation uses reStructuredText (.rst files)
cd components
# Create or edit relevant documentation
```

### Step 11: Test Your Changes

```bash
# Run code formatters
script/lint

# Run tests (if you added Python code)
pytest tests/

# Test with real configuration
esphome compile test_config.yaml

# Test on actual hardware
esphome run test_config.yaml
```

## Phase 4: Commit and Push

### Step 12: Review Your Changes
```bash
git status
git diff
```

### Step 13: Stage Your Changes
```bash
# Stage specific files
git add esphome/components/lvgl/touchscreen_example.yaml
git add esphome/components/esp32/boards.py

# Or stage all changes
git add .
```

### Step 14: Commit Your Changes
```bash
# Write a clear, descriptive commit message
git commit -m "Add LVGL touchscreen display examples

- Added comprehensive touchscreen example with swipe navigation
- Includes Home Assistant integration examples
- Demonstrates brightness control and multi-page layouts
- Tested on ESP32-S3 displays (480x480 and 800x480)"
```

Good commit messages:
- Start with a verb (Add, Fix, Update, Remove)
- First line is a summary (50 chars max)
- Leave blank line then add details
- Explain WHAT and WHY, not HOW

### Step 15: Push to Your Fork
```bash
git push origin feature/lvgl-display-examples
```

## Phase 5: Create Pull Request

### Step 16: Open Pull Request
1. Go to https://github.com/esphome/esphome
2. Click "Pull requests" tab
3. Click "New pull request"
4. Click "compare across forks"
5. Set:
   - base repository: `esphome/esphome`
   - base branch: `dev`
   - head repository: `YOUR_USERNAME/esphome`
   - compare branch: `feature/lvgl-display-examples`
6. Click "Create pull request"

### Step 17: Fill Out PR Template

The template will include:

**Title:** Clear, concise description (e.g., "Add LVGL touchscreen examples")

**Description:**
```markdown
## Description
Adds comprehensive LVGL examples for ESP32 touchscreen displays.

## Related issue (if applicable)
Fixes #1234

## Pull request in esphome-docs (if applicable)
esphome/esphome-docs#5678

## Checklist:
- [x] The code change is tested and works locally
- [x] Tests have been added to verify that the new code works (if applicable)
- [ ] Documentation has been updated (if applicable)
- [x] Code follows ESPHome style guide
- [x] All tests pass
```

**What does this implement/fix:**
- Explain the problem it solves
- Describe the solution
- Mention any breaking changes

**Testing:**
- Describe how you tested
- List hardware tested on
- Include test results

### Step 18: Sign the CLA
- A bot will comment if you need to sign the CLA
- Click the link and sign the Contributor License Agreement
- Comment on PR: "@esphomebot recheck"

## Phase 6: Review Process

### Step 19: Respond to Review Comments
- [ ] Check your PR regularly for comments
- [ ] Enable GitHub notifications
- [ ] Respond politely and professionally
- [ ] Make requested changes promptly

### Step 20: Make Changes Based on Feedback
```bash
# Make the requested changes in your local branch
# Edit files as needed

# Commit the changes
git add .
git commit -m "Address review comments

- Fixed formatting issues
- Added missing documentation
- Updated test cases"

# Push to your fork (PR updates automatically)
git push origin feature/lvgl-display-examples
```

### Step 21: Keep Your Branch Updated
```bash
# Fetch latest from upstream
git fetch upstream

# Rebase your branch on latest dev
git rebase upstream/dev

# Resolve any conflicts
# Then push (may need force push)
git push origin feature/lvgl-display-examples --force
```

## Phase 7: After Merge

### Step 22: Clean Up
```bash
# Delete your feature branch locally
git checkout dev
git branch -d feature/lvgl-display-examples

# Delete remote branch
git push origin --delete feature/lvgl-display-examples

# Update your fork
git fetch upstream
git merge upstream/dev
git push origin dev
```

### Step 23: Celebrate! 🎉
- [ ] Thank the reviewers
- [ ] Share your contribution
- [ ] Consider contributing more!

## Common Issues and Solutions

### CI Build Fails

**Issue:** Linting errors
```bash
# Run locally
script/lint
# Fix reported issues
```

**Issue:** Test failures
```bash
# Run tests locally
pytest tests/
# Fix failing tests
```

**Issue:** Merge conflicts
```bash
# Rebase on latest dev
git fetch upstream
git rebase upstream/dev
# Resolve conflicts
git add .
git rebase --continue
git push origin feature/branch-name --force
```

### PR Not Getting Reviewed

- Be patient (maintainers are volunteers)
- Politely ping after 1-2 weeks
- Ask in Discord #dev channel
- Ensure PR is complete and CI passes

### Changes Requested

- Don't take it personally
- Ask for clarification if needed
- Make changes promptly
- Thank reviewers for feedback

## Tips for Success

1. **Start Small:** First PR should be simple (documentation, small fix)
2. **Follow Style:** Match existing code style exactly
3. **Test Thoroughly:** Test on real hardware, not just compilation
4. **Document Well:** Add comments, update docs
5. **Be Patient:** Review can take time
6. **Be Responsive:** Reply to comments quickly
7. **Be Professional:** Friendly, polite, grateful
8. **Learn from Feedback:** Improve based on reviews

## Resources

- **Contributing Guide:** https://developers.esphome.io/contributing/code/
- **Code Style:** https://developers.esphome.io/contributing/code-style/
- **Component Guide:** https://developers.esphome.io/guides/
- **Discord:** https://discord.gg/KhAMKrd
- **Forum:** https://community.home-assistant.io/c/esphome/

## Questions?

- Ask in ESPHome Discord #dev channel
- Open a discussion on GitHub
- Check existing documentation

## Next Steps for This Repository

Based on the content of esphome-modular-lvgl-buttons, the most valuable contributions would be:

1. **LVGL Examples** (Easiest, most welcome)
   - Comprehensive touchscreen example
   - Swipe navigation pattern
   - Home Assistant integration examples
   - Color wheel implementation

2. **Documentation** (Very helpful)
   - Hardware setup guides
   - Pin mapping reference
   - Troubleshooting tips

3. **Board Definitions** (If not already present)
   - Add pin definitions for popular displays
   - Guition, Sunton, Waveshare boards

Start with #1 - it's the most straightforward and provides immediate value to the community!
