function Export-PsDscResource
{
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
