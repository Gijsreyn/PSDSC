function Initialize-PsDscConfigDocument
{
    <#
    .SYNOPSIS
        Initialize a DSC configuration document.

    .DESCRIPTION
        The function Initialize-PsDscConfigDocument initializes a DSC configuration document. It can pick up 'resource' and 'adapter' from PowerShell or Windows PowerShell.

    .PARAMETER ResourceName
        The resource name to execute.

    .PARAMETER ResourceInput
        The resource input to provide. Supports PowerShell hash table.

    .PARAMETER ResourceDescription
        The resource description to provide.

    .PARAMETER IsPwsh
        Switch to indicate if the resource is using PowerShell. Adds 'Microsoft.DSC/PowerShell' type.

    .PARAMETER IsWindowsPowerShell
        Switch to indicate if the resource is using Windows PowerShell. Adds 'Microsoft.Windows/WindowsPowerShell' type.

    .EXAMPLE
        PS C:\> Initialize-PsDscConfigDocument -ResourceName 'Microsoft.Windows/Registry' -ResourceInput @{'keyPath' = 'HKCU\1'} -ResourceDescription 'Registry'

        Returns:
        {"$schema":"https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json","resources":[{"name":"Registry","type":"Microsoft.Windows/Registry","properties":"@{keyPath=HKCU\\1}"}]}

    .EXAMPLE
        PS C:\> Init-PsDscConfigDocument -ResourceName Microsoft.WinGet.DSC/WinGetPackage -IsPwsh -ResourceInput @{ Id = 'Microsoft.PowerShell.Preview'} -ResourceDescription 'WinGetPackage'

        Returns:
        {"$schema":"https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json","resources":[{"name":"Using Pwsh","type":"Microsoft.DSC/PowerShell","properties":"@{resources=}"}]}

    .OUTPUTS
        System.String

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [Alias('Init-PsDscConfigDocument')]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ArgumentCompleter([DscConfigCompleter])]
        [string]$ResourceName,

        [Parameter(Mandatory = $false)]
        [ArgumentCompleter([DscConfigInputCompleter])]
        [AllowNull()]
        [hashtable]$ResourceInput,

        [Parameter(Mandatory = $false)]
        [string]$ResourceDescription,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]
        $IsPwsh,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]
        $IsWindowsPowerShell

    )

    if ([string]::IsNullOrEmpty($ResourceDescription))
    {
        $ResourceDescription = $ResourceName
    }

    $resources = [ordered]@{
        name       = $ResourceDescription
        type       = $ResourceName
        properties = $ResourceInput
    }

    if ($IsPwsh.IsPresent)
    {
        $resources = [ordered]@{
            name       = 'Using Pwsh'
            type       = 'Microsoft.DSC/PowerShell'
            properties = [ordered]@{
                resources = $resources
            }
        }
    }

    if ($IsWindowsPowerShell.IsPresent)
    {
        $resources = [ordered]@{
            name       = 'Using Pwsh'
            type       = 'Microsoft.Windows/WindowsPowerShell'
            properties = [ordered]@{
                resources = $resources
            }
        }
    }

    $configDocument = [ordered]@{
        '$schema' = 'https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json'
        resources = @($resources)

    }

    return $configDocument | ConvertTo-Json -Depth 10
}
