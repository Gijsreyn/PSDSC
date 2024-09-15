# PSDSC - PowerShell Desired State Configuration Version 3 Module

This is the repository for the PowerShell Desired State Configuration (DSC) Version 3 Module. You might think, why another PowerShell module for DSC? We already have the [PSDscResources](https://github.com/PowerShell/PSDscResources) and [PSDesiredStateConfiguration](https://learn.microsoft.com/nl-nl/powershell/module/psdesiredstateconfiguration/?view=dsc-2.0).

DSC version 3 in itself is not PowerShell anymore. Instead the engine is written in Rust. The output produced by the build, is a command-line utility (CLI) called `dsc.exe`. This community projected was created to enable the same features the CLI has using PowerShell. PowerShell also has additional features to help you familiarize yourself with the new commands used under the hood.

The current list of commands implemented in the module:

- [ConvertTo-DscJson](./docs/en-US/ConvertTo-DscJson.md)
- [ConvertTo-DscYaml](./docs/en-US/ConvertTo-DscYaml.md)
- [Install-DscCli](./docs/en-US/Install-DscCLI.md)
- [Invoke-PsDscResource](./docs/en-US/Invoke-PsDscResource.md)

## Installation

The PowerShell Desired State Configuration Version 3 Module is published to [PowerShellGallery](https://www.powershellgallery.com/packages/PSDSC/).

The module works on PowerShell 7+ and was tested on Windows. To install the module, use the following command:

```powershell
Install-PSResource -Name PSDSC -TrustRepository -Repository PSGallery
```

## Contributing

Thank you for considering contributing to our project! All types of contributions are welcome, including bug reports, feature suggestions, and code improvements. Please follow the guidelines below to ensure a smooth contribution process:

1. Reporting Bugs: Use the issue tracker to report bugs. Provide detailed information to help us understand and resolve the issue quickly.
2. Suggesting Enhancements: Share your ideas for new features or improvements by opening an issue.
3. Submitting Pull Requests: Fork the repository, create a new branch, and submit your changes via a pull request. Ensure your code follows our style guidelines and includes relevant tests.
4. Documentation: Help us improve our documentation by suggesting changes or adding new content.
