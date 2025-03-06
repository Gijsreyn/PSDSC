# ![PSDSCLogo] PSDSC - PowerShell Desired State Configuration Version 3 Module

This is the repository for the PowerShell Desired State Configuration (DSC) Version 3 Module. There are plenty of community modules availabe, but there is something special about DSC V3.

That's because DSC version 3 is doesn't rely on PowerShell anymore. The `PSDesiredStateConfiguration` module is not the driver of the engine anymore. The project is open-sourced and written in Rust. Building the project from GitHub, produces a command-line utility (CLI): `dsc.exe`. This community project was created to enable the same features the CLI provides, only using PowerShell. PowerShell invokes `dsc.exe` using the .NET object `System.Diagnostics.Process`.

PowerShell also adds features and helps you familiarize yourself with the cmdlets wrapped around the _command options_ under the hood. Each command in the module follows the approved verbs. This allows for recognizable commands towards `dsc.exe` without hiding the unnecessary. You should be able to see what is sent towards the engine using common parameters. For example, turn on `-Verbose` or `Debug` parameter on each command to see these type of messages.

The current list of commands implemented in the module:

- [ConvertTo-PsDscJson](./docs/en-US/ConvertTo-PsDscJson.md)
- [Export-PsDscConfig](./docs/en-US/Export-PsDscConfig.md)
- [Export-PsDscResource](./docs/en-US/Export-PsDscResource.md)
- [Find-PsDscResource](./docs/en-US/Find-PsDscResource.md)
- [Get-PsDscConfig](./docs/en-US/Get-PsDscConfig.md)
- [Get-PsDscResource](./docs/en-US/Get-PsDscResource.md)
- [Initialize-PsDscResourceInput](./docs/en-US/Initialize-PsDscResourceInput.md)
- [Install-DscExe](./docs/en-US/Install-DscExe.md)
- [Remove-PsDscResource](./docs/en-US/Remove-PsDscResource.md)
- [Set-PsDscConfig](./docs/en-US/Set-PsDscConfig.md)
- [Set-PsDscResource](./docs/en-US/Set-PsDscResource.md)
- [Test-PsDscConfig](./docs/en-US/Test-PsDscConfig.md)
- [Test-PsDscResource](./docs/en-US/Test-PsDscResource.md)

## Installation

The PSDSC is published to [PowerShellGallery](https://www.powershellgallery.com/packages/PSDSC/).

The module works on PowerShell 7+ and was tested on Windows. To install the module, use the following command:

```powershell
Install-PSResource -Name PSDSC
```

## Usage examples

The PSDSC module is not difficult to operate. It calls the `dsc.exe` executable directly. While the input for `dsc.exe` only supports JSON and YAML as input, PSDSC extends it with more capabilities. It supports the PowerShell objects by passing in a `hashtable` object on a single parameter. The parameter `-Inputs` can be found on nearly every command in this module. This makes it easy recognizable and you don't have to worry about if the input is a `.json` file or a `${}` PowerShell input object. PSDSC translates the input to the required options underneath.

> [!NOTE]
>
> You can always check out how it is translated by turning the `-Verbose` or `-Debug` parameter.

PowerShell v7+ is required.

```powershell
# start by installing 'dsc.exe' using Install-DscExe
Install-DscExe

# if you have an existing configuration document as such
# MyConfiguration.ps1
configuration MyConfiguration {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
    {
        Environment CreatePathEnvironmentVariable
        {
            Name   = 'TestPathEnvironmentVariable'
            Value  = 'TestValue'
            Ensure = 'Present'
            Path   = $true
        }
    }
}


# you can use the ConvertTo-PsDscJson
$resourceInput = ConvertTo-PsDscJson -Path MyConfiguration.ps1

# call dsc config get

$r = Get-PsDscConfig -Inputs $resourceInput

# return build arguments
$r.Arguments

# when working with resource, tab-completion kicks in on resources known to 'dsc.exe'
Get-PsDscResource -Resource Microsoft.Windows/Registry -Inputs '{"keyPath":"<keyPath>"}' #or
Get-PsDscResource -Resource Microsoft.Windows/Registry -Inputs '{"_exist":"<_exist>","_metadata":"<_metadata>","valueName":"<valueName>","keyPath":"<keyPath>","valueData":"<valueData>"}'

# there are also possibilities to have different input types
Get-PsDscResource -Resource Microsoft.Windows/Registry -Inputs @{keyPath = 'HKCU\MyPath'}

# Or use paths
Get-PsDscResource -Resource Microsoft.Windows/Registry -Inputs registry.example.resource.json
Get-PsDscResource -Resource Microsoft.Windows/Registry -Inputs registry.example.resource.yaml

# To generate example input
Initialize-PsDscResourceInput -Resource Microsoft.Windows/Registry # Or use -RequiredOnly

# to get schema definition integration in VSCode, you can use the New-PsDscVsCodeSettingsFile
New-PsDscVsCodeSettingsFile # adds to settings.json file:

# "yaml.schemas": {
#     "https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/bundled/config/document.vscode.json": "**/*.dsc.config.yaml"
#   },
#   "json.schemas": [
#     {
#       "fileMatch": [
#         "**/*.dsc.config.json"
#       ],
#       "url": "https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/bundled/config/document.vscode.json"
#     }
#   ]

# To find out more commands use
Get-Command -Module PSDSC
```

To see tab-completion kicking in for resources, check out the following:

![TabCompletionDscResource]

## Support

PSDSC targets PowerShell 7+, meaning it should run cross-platform. However, most commands implemented in the module are tested on Windows. The module aims to provide features and assistance in:

- Tab-completion on resources
- Build configuration documents from PowerShell v1/2 DSC Documents
- Support multiple input possibilities
- Familiarize yourself with new DSC concepts
- Assist in setting up authoring experience for JSON and YAML v3 DSC configuration documents

## Contributing

Thank you for considering contributing to our project! All types of contributions are welcome, including bug reports, feature suggestions, and code improvements. Please follow the [CONTRIBUTING.md](CONTRIBUTING.md) guidelines below to ensure a smooth contribution process.

<!-- References -->
[TabCompletionDscResource]: .images/tab-completion-dsc-resource.gif
[PSDSCLogo]: .images/psdsc_40px.png
