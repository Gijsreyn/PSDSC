function Test-PsDscResource
{
    <#
    .SYNOPSIS
        Invoke the test operation for DSC version 3 command-line utility.

    .DESCRIPTION
        The function Test-PsDscResource invokes the test operation on Desired State Configuration version 3 executable 'dsc.exe'.

    .PARAMETER Resource
        The resource (name) to be tested.

    .PARAMETER Inputs
        The input to provide. Supports a hashtable of key-value pairs, JSON, YAML, or a file path (both JSON and YAML).

    .EXAMPLE
        PS C:\> Test-PsDscResource -Resource 'Microsoft.Windows/Registry' -Inputs @{ keyPath = 'HKCU\1\2' }

        This example tests the 'Microsoft.Windows/Registry' DSC resource with the specified inputs.

    .EXAMPLE
        PS C:\> $params = @{
            Resource = 'Microsoft.Windows/Registry'
            Inputs = 'registry.json'
        }
        PS C:\> Test-PsDscResource @params

        This example tests the 'Microsoft.Windows/Registry' DSC resource with the inputs provided in the 'registry.json' file.

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
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $Inputs
    )

    $resourceInput = Resolve-DscInput -Inputs $Inputs

    $processArgument = Confirm-DscResourceInput -Resource $Resource -Inputs $resourceInput -Operation 'test'

    $process = Get-ProcessObject -Argument $processArgument

    $result = Get-ProcessResult -Process $process

    return $result
}
