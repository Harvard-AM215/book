#!/usr/bin/env bash
# setup.sh - Universal setup script

set -e

echo "🚀 Setting up AM215 Course Materials Development Environment"
echo "============================================================"

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

OS=$(detect_os)
echo "Detected OS: $OS"

# Check for Nix first
if command_exists nix && [ -f flake.nix ]; then
    echo "✅ Nix detected with flake.nix"
    echo "Setting up Nix development environment..."
    
    # Enable direnv if available
    if command_exists direnv; then
        echo "✅ direnv detected"
        echo "Run 'direnv allow' to activate the environment"
    else
        echo "⚠️  direnv not found. Install direnv for automatic environment activation"
        echo "Alternatively, run 'nix develop' to enter the dev shell"
    fi
    
    # Create .envrc if it doesn't exist
    if [ ! -f .envrc ]; then
        cat > .envrc << 'EOF'
use flake
PATH_add scripts/
EOF
        echo "Created .envrc file"
    fi
    
elif command_exists uv && [ -f pyproject.toml ]; then
    echo "✅ uv detected with pyproject.toml"
    echo "Setting up uv environment..."
    
    # Create virtual environment and install dependencies
    uv venv --python 3.11
    uv sync
    
    echo "✅ uv environment created"
    echo "Activate with: source .venv/bin/activate"
    
elif command_exists python3 && [ -f requirements.txt ]; then
    echo "✅ Python detected with requirements.txt"
    echo "Setting up traditional venv environment..."
    
    # Create virtual environment
    python3 -m venv .venv
    source .venv/bin/activate
    
    # Upgrade pip
    pip install --upgrade pip
    
    # Install dependencies
    pip install -r requirements.txt
    
    # Install development dependencies if available
    if [ -f requirements-dev.txt ]; then
        pip install -r requirements-dev.txt
    fi
    
    echo "✅ Virtual environment created"
    echo "Activate with: source .venv/bin/activate"
    
else
    echo "❌ No suitable environment found"
    echo "Please install one of the following:"
    echo "  - Nix (recommended for reproducible environments)"
    echo "  - uv (modern Python package management)"
    echo "  - Python 3.11+ with pip"
    exit 1
fi

# Create necessary directories
mkdir -p content/{week01,week02,week03,week04,week05,week06,week07,week08,week09,week10,week11,week12,week13,week14,week15}
mkdir -p content/{appendices,resources/{figures,data,code}}
mkdir -p scripts

# Create essential MyST book files
echo "Creating MyST book structure..."

# Create _config.yml
if [ ! -f _config.yml ]; then
    cat > _config.yml << 'EOF'
title: "AM215: Advanced Scientific Computing"
author: "Harvard University"
copyright: "2025"

execute:
  execute_notebooks: off
  cache: "_build/.jupyter_cache"
  
parse:
  myst_enable_extensions:
    - amsmath
    - colon_fence
    - deflist
    - dollarmath
    - html_admonition
    - html_image
    - linkify
    - replacements
    - smartquotes
    - substitution
    - tasklist

html:
  theme: sphinx-book-theme
  title: "AM215 Course Materials"
  
latex:
  latex_documents:
    targetname: am215-complete.tex

exclude_patterns:
  - .git/**
  - '.direnv/**'
  - '.venv/**'
  - _build/**
  - Thumb.db
  - .DS_Store
  - "**.ipynb_checkpoints"
EOF
    echo "Created _config.yml"
fi

# Create _toc.yml
if [ ! -f _toc.yml ]; then
    cat > _toc.yml << 'EOF'
format: jb-book
root: content/index
chapters:
- file: content/syllabus
- file: content/week01/index
- file: content/appendices/math-review
- file: content/appendices/python-primer
EOF
    echo "Created _toc.yml"
fi

# Create main index file
if [ ! -f content/index.md ]; then
    cat > content/index.md << 'EOF'
# AM215: Advanced Scientific Computing

Welcome to AM215, where we explore the intersection of mathematical modeling and software development for scientific computing.

## Course Overview

This course combines rigorous mathematical foundations with practical software development skills, preparing you to tackle complex scientific computing challenges.

## Learning Objectives

By the end of this course, you will be able to:
- Develop mathematical models for scientific phenomena
- Implement efficient numerical algorithms
- Design and build scientific software systems
- Apply best practices in computational science

## Getting Started

Navigate through the course materials using the sidebar. Each week builds upon the previous, so we recommend following the sequence.

```{note}
Course materials are updated regularly. Check back frequently for new content and announcements.
```
EOF
    echo "Created content/index.md"
fi

# Create syllabus
if [ ! -f content/syllabus.md ]; then
    cat > content/syllabus.md << 'EOF'
# Syllabus

## Course Information

**Course:** AM215 - Advanced Scientific Computing  
**Semester:** Spring 2025  
**Credits:** 3  

## Course Description

This course explores the intersection of mathematical modeling and software development for scientific computing, emphasizing both theoretical foundations and practical implementation skills.

## Prerequisites

- Linear algebra and calculus
- Programming experience (Python preferred)
- Basic knowledge of differential equations

## Course Schedule

The course is structured around weekly modules, each focusing on specific aspects of scientific computing.

## Assessment

- Problem sets (40%)
- Midterm project (25%)
- Final project (35%)

## Resources

All course materials are available in this online book format.
EOF
    echo "Created content/syllabus.md"
fi

# Create week01 content
if [ ! -f content/week01/index.md ]; then
    cat > content/week01/index.md << 'EOF'
# Week 1: Introduction to Scientific Computing

## Overview

This week introduces the fundamental concepts of scientific computing and mathematical modeling.

## Learning Objectives

- Understand the role of mathematical modeling in scientific computing
- Set up development environments for scientific computing
- Implement basic numerical methods

## Materials

- {doc}`lecture01`
- {doc}`exercises`
EOF
    echo "Created content/week01/index.md"
fi

# Create sample lecture
if [ ! -f content/week01/lecture01.md ]; then
    cat > content/week01/lecture01.md << 'EOF'
# Lecture 1: Introduction to Mathematical Modeling

## What is Mathematical Modeling?

Mathematical modeling is the process of creating mathematical representations of real-world phenomena to understand, predict, or control them.

## A Simple Example

Consider population growth. The simplest model is exponential growth:

```{math}
:label: exponential-growth
\frac{dP}{dt} = rP(t)
```

where $P(t)$ is the population at time $t$ and $r$ is the growth rate.

## Implementation

```{code-cell} python
import numpy as np
import matplotlib.pyplot as plt

def exponential_growth(P0, r, t):
    """Exponential growth model"""
    return P0 * np.exp(r * t)

# Parameters
P0 = 100  # Initial population
r = 0.1   # Growth rate
t = np.linspace(0, 50, 100)

# Calculate and plot
P = exponential_growth(P0, r, t)
plt.figure(figsize=(8, 5))
plt.plot(t, P, 'b-', linewidth=2)
plt.xlabel('Time')
plt.ylabel('Population')
plt.title('Exponential Population Growth')
plt.grid(True, alpha=0.3)
plt.show()
```

## Summary

This simple model demonstrates key concepts we'll build upon throughout the course.
EOF
    echo "Created content/week01/lecture01.md"
fi

# Create sample exercises
if [ ! -f content/week01/exercises.md ]; then
    cat > content/week01/exercises.md << 'EOF'
# Week 1 Exercises

## Exercise 1.1: Basic Modeling

Modify the exponential growth model to include a carrying capacity $K$:

$\frac{dP}{dt} = rP\left(1 - \frac{P}{K}\right)$

Implement this logistic growth model and compare it with exponential growth.

## Exercise 1.2: Numerical Methods

Implement Euler's method to solve the exponential growth equation numerically. Compare the accuracy with the analytical solution.

## Exercise 1.3: Parameter Exploration

Investigate how different values of $r$ affect the growth behavior. Create visualizations showing multiple scenarios.
EOF
    echo "Created content/week01/exercises.md"
fi

# Create appendices
if [ ! -f content/appendices/math-review.md ]; then
    cat > content/appendices/math-review.md << 'EOF'
# Mathematics Review

## Calculus

Review of essential calculus concepts for scientific computing.

## Linear Algebra

Key linear algebra concepts and their computational aspects.

## Differential Equations

Introduction to ODEs and PDEs relevant to scientific computing.
EOF
    echo "Created content/appendices/math-review.md"
fi

if [ ! -f content/appendices/python-primer.md ]; then
    cat > content/appendices/python-primer.md << 'EOF'
# Python Programming Primer

## NumPy Basics

Essential NumPy operations for scientific computing.

## Matplotlib for Visualization

Creating effective plots and visualizations.

## SciPy for Scientific Computing

Overview of SciPy's scientific computing capabilities.
EOF
    echo "Created content/appendices/python-primer.md"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Activate your environment (see instructions above)"
echo "2. Run './scripts/build.sh' to build the book"
echo "3. Open '_build/html/index.html' in your browser"
echo "4. Start editing content in the 'content/' directory"
