function Get-PsDscResource
{
    <#
    .SYNOPSIS
        Invoke the get operation for DSC version 3 command-line utility.

    .DESCRIPTION
        The function Get-PsDscResource invokes the get operation on Desired State Configuration version 3 executable 'dsc.exe'.

    .PARAMETER Resource
        The resource (name) to be retrieved.

    .PARAMETER Inputs
        The input to provide. Supports a hashtable of key-value pairs, JSON, YAML, or a file path (both JSON and YAML).

    .EXAMPLE
        PS C:\> Get-PsDscResource -Resource 'Microsoft.Windows/Registry' -Inputs @{ keyPath = 'HKCU\1\2' }

        This example retrieves the 'Microsoft.Windows/Registry' DSC resource with the specified inputs.

    .EXAMPLE
        PS C:\> $params = @{
            Resource = 'Microsoft.Windows/Registry'
            Inputs = 'registry.json'
        }
        PS C:\> Get-PsDscResource @params

        This example retrieves the 'Microsoft.Windows/Registry' DSC resource with the inputs provided in the 'registry.json' file.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [Alias('ResourceName')]
        [ArgumentCompleter([ResourceCompleter])]
        [System.String]
        $Resource,

        [Parameter(Mandatory = $true)]
        [ArgumentCompleter([ResourceInputCompleter])]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $Inputs
    )

    $resourceInput = Resolve-DscInput -Inputs $Inputs

    $processArgument = Confirm-DscResourceInput -Resource $Resource -Inputs $resourceInput -Operation 'get'

    $process = Get-ProcessObject -Argument $processArgument

    $result = Get-ProcessResult -Process $process

    return $result
}
