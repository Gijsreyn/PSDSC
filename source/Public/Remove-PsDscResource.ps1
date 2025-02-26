function Remove-PsDscResource
{
    <#
    .SYNOPSIS
        Invoke the delete operation for DSC version 3 command-line utility.

    .DESCRIPTION
        The function Remove-PsDscResource invokes the delete operation on Desired State Configuration version 3 executable 'dsc.exe'.

    .PARAMETER Resource
        The resource (name) to be deleted.

    .PARAMETER Inputs
        The input to provide. Supports a hashtable of key-value pairs, JSON, YAML, or a file path (both JSON and YAML).

    .EXAMPLE
        PS C:\> Remove-PsDscResource -Resource 'Microsoft.Windows/Registry' -Inputs @{ keyPath = 'HKCU\1\2' }

        This example removes the 'Microsoft.Windows/Registry' DSC resource with the specified inputs.

    .EXAMPLE
        PS C:\> $params = @{
            Resource = 'Microsoft.Windows/Registry'
            Inputs = 'registry.json'
        }
        PS C:\> Remove-PsDscResource @params

        This example removes the 'Microsoft.Windows/Registry' DSC resource with the inputs provided in the 'registry.json' file.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
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

    $resourceInput = Resolve-DscResourceInput -Inputs $Inputs

    $processArgument = Confirm-DscResourceInput -Resource $Resource -Inputs $resourceInput -Operation 'delete'

    $Process = Get-ProcessObject -Argument $processArgument

    if ($PSCmdlet.ShouldProcess("'$Resource' with '$resourceInput'" , "Remove"))
    {
        $result = Get-ProcessResult -Process $Process
    }

    return $result
}
