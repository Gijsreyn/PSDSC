# Changelog for PSDSC

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- Allow .ps1 configuration document files to be validated
- Decreased the amount of calls towards DSC's version

### Added

- Improved unit testing and code coverage
- Introduced both Initialize-PsDscConfigDocument and New-PsDscVsCodeSettingsFile command
- Validate multiple inputs for `Invoke-PsDscResource` and `Invoke-PsDscConfig`
- Pester tests
- The `ConvertTo-DscJson` and `ConvertTo-DscYaml` command
- Initial start of `Invoke-PsDscResource`
- Created installation command
