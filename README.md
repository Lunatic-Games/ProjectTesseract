
# ProjectTesseract 
Transdimensional Combat
## Build Status
[![Actions Status](https://github.com/Lunatic-Games/ProjectTesseract/workflows/Build%20Develop%20Branch/badge.svg)](https://github.com/Lunatic-Games/ProjectTesseract/actions)

## Coding Formats:
Variable: **snake_case**

Functions: **snake_case**

Scenes: **PascalCase**

Folders: **PascalCase**

## Git Proceedures
For this project we will be using the Gitflow workflow. There are two main branches, `master` and `develop`. The `master` branch is used for release-able versions of code. The `develop` branch is used for active development, testing, and integrating new features. Below are the proceedures to be used for developing a new feature, issuing a hotfix, and publishing a release.
### Features
1. Checkout a new branch from the `HEAD` of `develop`. Make sure the branch name starts with "feature-"
2. Use this branch for developing and testing the feature.
3. When the feature is completed, merge back into `develop` or create a pull request for others to review the code and later, merge.
4. Delete the `feature` branch.

### Releases
1. When the `develop` branch is ready to be released, checkout a new branch from `develop`. Make sure the branch name starts with "release-"
2. Once any last minute fixes are completed, create a pull request to merge the `release` branch into `master`.
3. Once reviewed and approved, the branches will be merged.
4. Once the branches are merged, the current postion of the `master` branch will be tagged as a new release.
5. Merge the `release` branch back into `develop` and continue on with development.
6.  Delete the `release` branch.

### Hotfixes
1. To issue a hotfix to a bug on the `master` branch, checkout a new branch from `master`. Make sure the branch name starts with "hotfix-"
2. Once the bug is fixed, create a pull request or merge the `hotfix` branch into both `master` and `develop`.
3. Once the branches are merged, the current postion of the `master` branch will be tagged as a new release.
4. Delete the `hotfix` branch.

## Todo
- Have bullets show over networked game
- Have lobby screen with all possible lobbys discovered on the network

## Authors
- Matthias Harden
- Joe Zlonicky
- Noah Jacobsen
- Davis Carlson
