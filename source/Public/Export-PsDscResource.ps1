function Export-PsDscResource
{
    <#
    .SYNOPSIS
        Invoke the export operation for DSC version 3 command-line utility.

    .DESCRIPTION
        The function Export-PsDscResource invokes the export operation on Desired State Configuration version 3 executable 'dsc.exe'.

    .PARAMETER Resource
        The resource (name) to be exported.

    .EXAMPLE
        PS C:\> Export-PsDscResource -Resource 'Microsoft/OSInfo'

        This example exports the 'Microsoft/OSInfo' DSC resource.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [Alias('ResourceName')]
        [ArgumentCompleter([DscResourceCompleter])]
        [System.String]
        $Resource
    )

    $processArgument = "resource export --resource $Resource"

    $Process = Get-ProcessObject -Argument $processArgument

    $result = Get-ProcessResult -Process $Process

    return $result
}
