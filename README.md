# PSDSC - PowerShell Desired State Configuration Version 3 Module

This is the repository for the PowerShell Desired State Configuration (DSC) Version 3 Module. You might think, why another PowerShell module for DSC? We already have the [PSDesiredStateConfiguration](https://learn.microsoft.com/nl-nl/powershell/module/psdesiredstateconfiguration/?view=dsc-2.0).

DSC version 3 is no longer PowerShell. Instead, the engine is written in Rust. The output produced by the build is a command-line utility (CLI) called `dsc.exe`. This community project was created to enable the same features the CLI provides, only using PowerShell as the program.

PowerShell also adds features and helps you familiarize yourself with the cmdlets wrapped around the _"commands"_ under the hood. While following the approved verbs and following the creation of recognizable PowerShell commands, you should be able to see everything using the common parameters.

The current list of commands implemented in the module:

- [ConvertTo-DscJson](./docs/en-US/ConvertTo-DscJson.md)
- [ConvertTo-DscYaml](./docs/en-US/ConvertTo-DscYaml.md)
- [Install-DscCli](./docs/en-US/Install-DscCLI.md)
- [Invoke-PsDscResource](./docs/en-US/Invoke-PsDscResource.md)

## Installation

The PSDSC is published to [PowerShellGallery](https://www.powershellgallery.com/packages/PSDSC/).

The module works on PowerShell 7+ and was tested on Windows. To install the module, use the following command:

```powershell
Install-PSResource -Name PSDSC -TrustRepository -Repository PSGallery
```

## Contributing

Thank you for considering contributing to our project! All types of contributions are welcome, including bug reports, feature suggestions, and code improvements. Please follow the [CONTRIBUTING.md](CONTRIBUTING.md) guidelines below to ensure a smooth contribution process.
