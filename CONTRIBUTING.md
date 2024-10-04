# Contributing to PSDSC

You are always welcome to contribute to PSDSC module using [Pull Request](#pull-request), [Feature Suggestions](#feature-suggestions) or [Bug Reports](#bug-reports).

## Getting started

- Fork this repo.
- Checkout the repo locally using your favorite editor or `git clone` command.

There is an easy script in the root of the repository called `build.ps1`. To resolve the dependencies of the project, you can run the command `.\build.ps1 -ResolveDependency -Task noop` to download and resolve all dependencies. If you want to build the project, change the task from `noop` to `build`.

## Pull Request

- Write clear, concise commit messages.
- Include relevant tests for your changes.
- Make sure all tests pass before submitting your pull request.
- Provide a detailed description of your changes and the problem they solve.
- Reference any related issues in your pull request description.
- Be prepared to make revisions based on feedback from the project maintainers.

## Feature Suggestions

- Clearly describe the feature you are suggesting and its potential benefits.
- Provide examples or use cases where this feature would be useful.
- If possible, include a rough outline or pseudocode of how the feature could be implemented.
- Mention any potential drawbacks or challenges associated with the feature.
- Be open to feedback and discussion from the community and maintainers.

## Bug Reports

- Please first search the [Open Issues](https://github.com/Gijsreyn/PSDSC/issues) before opening an issue to see if it has already been reported.
- Run `$PSVersionTable` to output relevant information to your environment.
- Try to be as specific as possible when reporting a bug.
