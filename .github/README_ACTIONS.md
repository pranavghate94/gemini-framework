# GitHub Actions Documentation

This repository includes two GitHub Actions workflows to provide Continuous Integration (CI) and Continuous Deployment (CD) for the GEMINI Framework Python project.

## Workflows Overview

### 1. CI Workflow (`.github/workflows/ci.yml`)

The CI workflow automatically runs on:
- Pull requests targeting `main` or `develop` branches
- Direct pushes to `main` or `develop` branches

**Features:**
- **Multi-Python Testing**: Tests against Python versions 3.8, 3.9, 3.10, 3.11, and 3.12
- **Dependency Caching**: Uses GitHub Actions cache for pip and poetry dependencies to speed up builds
- **Flexible Installation**: Attempts multiple installation strategies:
  1. `pip install -e .[test]` (editable install with test extras)
  2. `pip install -e .` (editable install without extras)
  3. `pip install -r requirements-dev.txt` (if requirements-dev.txt exists)
  4. Falls back to installing common testing tools
- **Linting**: Runs code quality checks using:
  - **ruff** (preferred, modern Python linter)
  - **flake8** (fallback if ruff not available)
  - **black** (code formatting check)
- **Testing**: Executes tests using pytest with:
  - JUnit XML output for test result parsing
  - Code coverage reporting
  - Graceful handling when no tests are found
- **Artifact Upload**: Saves test results and coverage reports as workflow artifacts

### 2. Release Workflow (`.github/workflows/release.yml`)

The release workflow triggers on:
- Manual dispatch (workflow_dispatch)
- Published GitHub releases
- Git tags matching `v*.*.*` pattern (e.g., v1.0.0, v2.1.3)

**Features:**
- **Build Job**: Creates both source and wheel distributions using `python -m build`
- **Publish Job**: Automatically publishes to PyPI when triggered by releases or version tags
- **Artifact Management**: Uploads build artifacts for inspection and debugging
- **Security**: Uses PyPI API token authentication for secure publishing

## Required Repository Secrets

To enable automatic PyPI publishing, you must configure the following repository secret:

### Setting up PYPI_API_TOKEN

1. **Generate a PyPI API Token**:
   - Go to [PyPI Account Settings](https://pypi.org/manage/account/)
   - Navigate to "API tokens" section
   - Click "Add API token"
   - Give it a name like "gemini-framework-github-actions"
   - Set scope to "Entire account" or limit to specific project
   - Copy the generated token (starts with `pypi-`)

2. **Add Secret to Repository**:
   - Go to your GitHub repository
   - Navigate to **Settings** > **Secrets and variables** > **Actions**
   - Click **"New repository secret"**
   - Name: `PYPI_API_TOKEN`
   - Value: Paste your PyPI API token
   - Click **"Add secret"**

## How to Trigger Releases

### Option 1: GitHub Releases (Recommended)
1. Go to your repository on GitHub
2. Click **Releases** > **Create a new release**
3. Create a new tag (e.g., `v1.0.0`)
4. Fill in release title and description
5. Click **Publish release**
6. The workflow will automatically build and publish to PyPI

### Option 2: Git Tags
```bash
# Create and push a version tag
git tag v1.0.0
git push origin v1.0.0
```

### Option 3: Manual Dispatch
1. Go to **Actions** tab in your repository
2. Select **Release** workflow
3. Click **Run workflow**
4. Choose branch and click **Run workflow**
5. Note: Manual dispatch will only build, not publish to PyPI (unless you also create a tag)

## Workflow Status and Monitoring

- **CI Status**: Check the status of CI runs in the **Actions** tab or as status checks on pull requests
- **Release Status**: Monitor release deployments in the **Actions** tab
- **Test Reports**: Download test result artifacts from completed workflow runs
- **Build Artifacts**: Download wheel and source distributions from release workflow runs

## Troubleshooting

### Common Issues

1. **PyPI Publishing Fails**:
   - Verify `PYPI_API_TOKEN` secret is correctly set
   - Ensure token has sufficient permissions
   - Check if package version already exists on PyPI

2. **Tests Fail**:
   - Review test logs in the Actions tab
   - Download test result artifacts for detailed analysis
   - Ensure all test dependencies are properly specified

3. **Linting Failures**:
   - Install and run linting tools locally: `pip install ruff black flake8`
   - Fix code style issues before pushing
   - Configure `.ruff.toml` or `pyproject.toml` for project-specific linting rules

4. **Dependency Installation Issues**:
   - Verify `pyproject.toml` is properly formatted
   - Ensure all dependencies are available and compatible
   - Check for conflicting version requirements

For additional help, check the workflow run logs in the **Actions** tab for detailed error messages and debugging information.