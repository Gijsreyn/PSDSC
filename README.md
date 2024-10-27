# ![PSDSCLogo] PSDSC - PowerShell Desired State Configuration Version 3 Module

This is the repository for the PowerShell Desired State Configuration (DSC) Version 3 Module. There are plenty of community modules availabe, but there is something special about DSC V3.

That's because DSC version 3 is doesn't rely on PowerShell anymore. The `PSDesiredStateConfiguration` module is not the driver of the engine anymore. The project is open-sourced and written in Rust. Building the project from GitHub, produces a command-line utility (CLI): `dsc.exe`. This community project was created to enable the same features the CLI provides, only using PowerShell. PowerShell invokes `dsc.exe` using the .NET object `System.Diagnostics.Process`.

PowerShell also adds features and helps you familiarize yourself with the cmdlets wrapped around the _command options_ under the hood. Each command in the module follows the approved verbs. This allows for recognizable commands towards `dsc.exe` without hiding the unnecessary. You should be able to see what is sent towards the engine using common parameters. For example, turn on `-Verbose` or `Debug` parameter on each command to see these type of messages.

The current list of commands implemented in the module:

- [ConvertTo-DscJson](./docs/en-US/ConvertTo-DscJson.md)
- [ConvertTo-DscYaml](./docs/en-US/ConvertTo-DscYaml.md)
- [Get-PsDscResourceSchema](./docs/en-US/Get-PsDscResourceSchema.md)
- [Initialize-PsDscConfigDocument](./docs/en-US/Initialize-PsDscConfigDocument.md)
- [Install-DscCli](./docs/en-US/Install-DscCLI.md)
- [Invoke-PsDscResource](./docs/en-US/Invoke-PsDscResource.md)
- [New-PsDscVsCodeSettingsFile](./docs/en-US/New-PsDscVsCodeSettingsFile.md)

## Installation

The PSDSC is published to [PowerShellGallery](https://www.powershellgallery.com/packages/PSDSC/).

The module works on PowerShell 7+ and was tested on Windows. To install the module, use the following command:

```powershell
Install-PSResource -Name PSDSC -TrustRepository -Repository PSGallery
```

> [!NOTE]
> `Microsoft.PowerShell.PSResourceGet` should be shipped in higher version of PowerShell 7.2+. If you get _The term 'Install-PSResource' is not recognized as the name of a cmdlet, function, script file, or operable program error message_, update PowerShell to the latest version.

## Usage examples

The PSDSC module is not difficult to operate, as it hooks directly into `dsc.exe`. While JSON is the primary driver, `dsc.exe` supports JSON and YAML as input. Under the hood, it is always converted to JSON. PSDSC extends more capabilities, by also supporting PowerShell objects based on `hashtable` object and a single `-ResourceInput` parameter. You don't have to worry about if the input is a `.json` file or `@{}` PowerShell input object. PSDSC translates the input to the required options.

PowerShell v7+ is required.

```powershell
# start by installing 'dsc.exe' using Install-DscCli
Install-DscCli

# if you have an existing configuration document as such
# MyConfiguration.ps1
configuration MyConfiguration {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
    {
        Environment CreatePathEnvironmentVariable
        {
            Name = 'TestPathEnvironmentVariable'
            Value = 'TestValue'
            Ensure = 'Present'
            Path = $true
        }
    }
}

# you can use the ConvertTo-DscJson 
$resourceInput = ConvertTo-DscJson -Path MyConfiguration.ps1

# call dsc config get
$r = $resourceInput | Invoke-PsDscConfig -Operation Get

# return build arguments
$r.Arguments

# when working with resource, tab-completion kicks in on resources known to 'dsc.exe'
Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Get -ResourceInput '{"keyPath":"<keyPath>"}' #or
Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry -Operation Get -ResourceInput '{"_exist":"<_exist>","_metadata":"<_metadata>","valueName":"<valueName>","keyPath":"<keyPath>","valueData":"<valueData>"}'

# there are also possibilities to have different input types
Invoke-PsDscResource -ResourceName Microsoft.Windows/Registry Set -ResourceInput @{keyPath = 'HKCU\1\2'}

Invoke-PsDscResource -ResourceName MIcrosoft.Windows/Registry Test -ResourceInput registry.example.resource.json
Invoke-PsDscResource -ResourceName MIcrosoft.Windows/Registry Test -ResourceInput registry.example.resource.yaml

# powershell adapter works also when cache is available from powershell.resource.ps1
Invoke-PsDscResource -ResourceName Microsoft.WinGet.DSC/WinGetPackage -ResourceInput '{"Id":"<string>"}'

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

# using short alias to build a DSC v3 configuration document and execute it
$doc = Init-PsDscConfigDocument -ResourceName Microsoft.Windows/Registry -ResourceInput @{'keyPath' = 'HKCU\User'}

$p = @{
    Operation = 'Get'
    ResourceInput = $doc
}
Invoke-PsDscConfig @p

# Invoke-PsDscConfig also supports the ability to use (.ps1) configuration document scripts.
# MyConfiguration.ps1
configuration MyConfiguration {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
    {
        Environment CreatePathEnvironmentVariable
        {
            Name = 'TestPathEnvironmentVariable'
            Value = 'TestValue'
            Ensure = 'Present'
            Path = $true
        }
    }
}
Invoke-PsDscConfig -Operation Get -ResourceInput MyConfiguration.ps1

```

To see tab-completion kicking in for resources, check out the following:

![TabCompletionDscResource]

## Support

PSDSC targets PowerShell 7+, meaning it should run cross-platform. However, most commands implemented in the module are tested on Windows. The module aims to provide features and assistance in:

- Tab-completion on resources
- Build configuration documents from PowerShell v1/2 DSC Documents
- Support multiple input possibilities
- Familiarize yourself with new DSC concepts
- Assist in setting up authoring experience for JSON and YAMl v3 DSC configuration documents

## Contributing

Thank you for considering contributing to our project! All types of contributions are welcome, including bug reports, feature suggestions, and code improvements. Please follow the [CONTRIBUTING.md](CONTRIBUTING.md) guidelines below to ensure a smooth contribution process.

<!-- References -->
[TabCompletionDscResource]: .images/tab-completion-dsc-resource.gif
[PSDSCLogo]: .images/psdsc_40px.png
