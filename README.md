# AM215: Advanced Scientific Computing Course Materials

This repository contains the course materials for AM215, combining mathematical modeling with software development for scientific computing.

## Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/am215-materials.git
   cd am215-materials
   ```

2. **Run the setup script**
   ```bash
   ./setup.sh
   ```

3. **Start development**
   ```bash
   ./scripts/dev.sh
   ```

## Environment Options

We support multiple development environments to accommodate different preferences and systems:

### Option 1: Nix (Recommended for reproducibility)

**Prerequisites:** [Nix](https://nixos.org/download.html) and [direnv](https://direnv.net/)

```bash
# The setup script will detect Nix automatically
./setup.sh
direnv allow  # Automatically activates environment when entering directory
```

**Benefits:**
- Completely reproducible environment
- Automatic activation with direnv
- No version conflicts
- Works identically across all systems

### Option 2: uv (Modern Python package management)

**Prerequisites:** [uv](https://github.com/astral-sh/uv)

```bash
# Install uv if not already installed
curl -LsSf https://astral.sh/uv/install.sh | sh

# Setup will detect uv automatically
./setup.sh
source .venv/bin/activate  # Activate environment
```

**Benefits:**
- Fast dependency resolution
- Modern Python package management
- Good compatibility with existing Python tools

### Option 3: Traditional venv

**Prerequisites:** Python 3.11+ and pip

```bash
# Setup will detect Python automatically
./setup.sh
source .venv/bin/activate  # Activate environment
```

**Benefits:**
- Works with any Python installation
- Familiar to most Python users
- No additional tools required

## Development Workflow

### Basic Commands

```bash
# Build the book
./scripts/build.sh

# Watch for changes and auto-rebuild
./scripts/watch.sh

# Start full development environment (Jupyter Lab + auto-rebuild)
./scripts/dev.sh

# Clean build artifacts
./scripts/clean.sh
```

### Writing Content

1. **Add new lectures** in `content/weekXX/` directories
2. **Update table of contents** in `_toc.yml`
3. **Add references** to `content/resources/bibliography.bib`
4. **Include code examples** as `.py` files or Jupyter notebooks

### Project Structure

```
am215-materials/
├── content/                 # Course content
│   ├── index.md            # Course homepage
│   ├── syllabus.md         # Syllabus
│   ├── week01/             # Week 1 materials
│   │   ├── index.md        # Week overview
│   │   ├── lecture01.md    # Lecture notes
│   │   └── exercises.md    # Problem sets
│   ├── appendices/         # Reference materials
│   └── resources/          # Shared resources
├── _config.yml             # Jupyter Book configuration
├── _toc.yml               # Table of contents
├── scripts/               # Build and utility scripts
└── _build/                # Generated output (ignored)
```

## MyST Features

This course uses MyST (Markedly Structured Text) for rich academic content:

### Code Execution
```markdown
# Python code that runs when building
{code-cell} python
import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(0, 10, 100)
y = np.sin(x)
plt.plot(x, y)
plt.show()
```

### Mathematical Equations
```markdown
# Inline math: $E = mc^2$
# Block math with labels:
{math}
:label: euler-equation
e^{i\pi} + 1 = 0
```

### Admonitions
```markdown
{note}
This is a note for students.
```

```markdown
{warning}
This is a warning about common mistakes.
```

### Cross-references
```markdown
See equation {eq}`euler-equation` for details.
```

## Collaboration

### For Contributors

1. **Create a feature branch** for your changes
2. **Test your changes** locally with `./scripts/build.sh`
3. **Submit a pull request** with a clear description

### For Students

- **Report issues** via GitHub Issues
- **Suggest improvements** via pull requests
- **Access latest materials** at [course website]

## Deployment

### GitHub Pages (Recommended)

```bash
# Deploy to GitHub Pages
./scripts/deploy.sh
```

### Manual Deployment

```bash
# Build and copy to your web server
./scripts/build.sh
rsync -avz _build/html/ user@server:/path/to/webroot/
```

## Troubleshooting

### Common Issues

1. **Environment activation fails**
   - Check that your chosen package manager is installed
   - Run `./setup.sh` again

2. **Build fails**
   - Ensure all dependencies are installed
   - Check for syntax errors in MyST files
   - Run `./scripts/clean.sh` and rebuild

3. **Math rendering issues**
   - Verify MathJax configuration in `_config.yml`
   - Check for unescaped characters in equations

### Getting Help

1. Check the [MyST documentation](https://myst-parser.readthedocs.io/)
2. Review [Jupyter Book documentation](https://jupyterbook.org/)
3. Open an issue in this repository

## License

This course material is licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
