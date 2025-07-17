# AM 215: Mathematical Modeling for Computational Science

This repository contains the source files for the AM 215 Jupyter Book. This guide explains the development workflow for collaborators.

## Quick Start

For experienced developers, here is the fastest way to get started:

```bash
# Clone the repository
git clone <repository-url>
cd <repository-name>

# Create the environment and install dependencies
uv venv
source .venv/bin/activate
uv sync

# Start the local development server in a dedicated terminal
./scripts/serve.sh
```

## Prerequisites

Before you begin, ensure you have the following installed:

1.  **Git:** For version control.
2.  **Python 3.11+:** The project is configured to use this version.
3.  **uv:** A fast Python package installer and resolver. If you don't have it, you can install it with `pip`:
    ```bash
    pip install uv
    ```

## Environment Setup

This project uses `uv` and `pyproject.toml` to manage dependencies for building the book. You have two options for setting up your environment.

### Option 1: Standard Setup (Manual)

This is the standard approach that will work on any system.

1.  **Clone the repository:**
    ```bash
    git clone git@github.com:Harvard-AM215/book.git
    cd book
    ```

2.  **Create a virtual environment:**
    ```bash
    uv venv
    ```
    This will create a `.venv` directory in the project root.

3.  **Activate the environment:**
    *   On macOS/Linux: `source .venv/bin/activate`
    *   On Windows (PowerShell): `.venv\Scripts\Activate.ps1`

4.  **Install dependencies:**
    ```bash
    uv sync
    ```
    This command reads `pyproject.toml` and installs all necessary packages into your virtual environment. You must have your environment activated to run this.

### Option 2: Using `direnv` (Recommended)

`direnv` is a tool that automatically activates and deactivates the virtual environment when you `cd` into or out of the project directory. It's a "set it and forget it" solution that makes the workflow smoother.

1.  **Install `direnv`:** Follow the [official installation instructions for your operating system](https://direnv.net/docs/installation.html). Make sure to hook it into your shell.

2.  **Allow the environment:** The first time you `cd` into the project directory, `direnv` will be blocked for security reasons. Run the following command to allow it:
    ```bash
    direnv allow .
    ```
    `direnv` will read the `.envrc` file and automatically create and manage the virtual environment for you.

From now on, you will never need to run `source .venv/bin/activate` again; `direnv` handles it for you.

## Development Workflow

The process of adding content involves editing files, building the book, and viewing the results on a local server before pushing your changes. We recommend having **two terminal windows open** for a smooth workflow.

### 1. Editing and Adding Content

-   All book content (notebooks and Markdown files) lives in the `jupyter-book/content/` directory.
-   **To edit notebooks**, activate your environment and run `jupyter lab` from the project root. This will open the familiar web-based interface for editing `.ipynb` files.
-   After creating a new file, you **must** add its path to the table of contents to make it appear in the book. Open `jupyter-book/_toc.yml` and add the file path in the desired location.

### 2. Building and Serving the Book Locally

We have created helper scripts in the `./scripts/` directory to standardize this process.

-   **`./scripts/build.sh`**: This command builds the book once. The output is generated in the `jupyter-book/_build/html` directory. You will typically not need to run this directly.
-   **`./scripts/serve.sh`**: This is the primary command for local development. **This script takes over your terminal window** to provide a live server and an interactive rebuild prompt.

The recommended workflow is:

1.  **In your first terminal**, run `./scripts/serve.sh`. It will:
    -   Perform an initial build of the book.
    -   Start a local web server to test interactive elements.
    -   Provide a clickable link to view your book.
    -   Wait for you to press a key to trigger the next rebuild.

2.  **In your second terminal**, run `git` commands, start `jupyter lab`, or use your preferred text editor to modify the source files.

3.  After saving changes, return to the first terminal and **press any key** (e.g., Spacebar) to rebuild the book.

4.  Once the build is complete, **refresh your browser** to see the changes. The link to your book will be redisplayed in the terminal for convenience.

5.  When you're done, press `Ctrl+C` in the first terminal to stop the server cleanly.

## Git Workflow and Deployment

-   **Automatic Deployment:** Any commit pushed to the `main` branch will automatically trigger a GitHub Actions workflow that builds and deploys the latest version of the book to its public URL.
-   **Development on Branches:** To avoid breaking the main site, we recommend development **on a separate branch,** rather than workng directly on `main`.

The recommended Git workflow is:
1.  Create a new branch for your feature or changes: `git checkout -b your-feature-name`
2.  Make your edits, build and test locally, and commit your changes.
3.  Push your branch to the remote repository: `git push origin your-feature-name`
4.  On GitHub, open a **[Pull Request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)** to merge your feature branch into the `main` branch. This allows for code review before deployment.
5.  Once the Pull Request is approved and merged, the deployment workflow will run automatically.

## Important Notes & Gotchas

-   **Two `requirements.txt` Files:** This project uses `pyproject.toml` for the *build environment*. The `jupyter-book/requirements.txt` file is separate and is used by **Pyodide** or **Binder** to install packages *into the user's browser* for the "Live Code" feature. If your notebook needs a new library for users to run in the browser, you must add it to `jupyter-book/requirements.txt`.
-   **"Live Code" Failures:** If you find that the "Live Code" button does nothing on a specific page, the most likely cause is that the notebook have dependencies that are either missing from requirements.txt or don't work with Pyodide/Binder.
-   **Troubleshooting:** If you encounter strange build errors, a good first step is to delete your local virtual environment (`rm -rf .venv`) and recreate it by running `direnv allow .` (if using direnv) or `uv venv && uv sync` (if managing manually).

## Resources

For guides, you can check out:
- [Jupyter Book](https://jupyterbook.org/en/stable/intro.html)
- [Myst Markdown](https://mystmd.org/)
