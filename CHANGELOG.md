# Changelog for PSDSC

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.2] - 2025-04-24

### Changed

- Changed the way how `ConvertTo-PsDsc*` commands work with adapters

## [1.2.1] - 2025-04-11

### Fixed

- Wildcard when installing `dsc.exe`

## [1.2.0] - 2025-03-14

### Fixed

- Build task

## [1.1.2] - 2025-03-14

### Fixed

- Pick the latest version after GA

## [1.1.1] - 2025-03-06

### Added

- New `Initialize-PsDscResourceInput` command
- Update the docs

## [1.1.0] - 2025-02-28

### Changed

- Refactored module

## [1.0.6] - 2024-11-02

### Fixed

- Fix unit test for Initialize-PsConfigDocument command

## [1.0.5] - 2024-11-02

### Changed

- Change the way how Configuration Documents are build

## [1.0.4] - 2024-10-27

- Bug fix when installing MacOS on agents

## [1.0.3] - 2024-10-27

### Added

- MacOS support when installing `dsc.exe`

## [1.0.2] - 2024-10-27

### Fixed

- Additional path added for Linux

### Fixed

- Added Linux and UseGitHub option when installing `dsc.exe`

## [1.0.1] - 2024-11-04

### Added

- Official release with WinGet

## [1.0.0] - 2024-10-04

### Added

- Improved unit testing and code coverage
- Introduced both Initialize-PsDscConfigDocument and New-PsDscVsCodeSettingsFile command
- Validate multiple inputs for `Invoke-PsDscResource` and `Invoke-PsDscConfig`
- Pester tests
- The `ConvertTo-DscJson` and `ConvertTo-DscYaml` command
- Initial start of `Invoke-PsDscResource`
- Created installation command
- Decreased the amount of calls towards DSC's version
- Allow .ps1 configuration document files to be validated
