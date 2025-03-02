function Initialize-PsDscResourceInput
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [Alias('ResourceName')]
        [ArgumentCompleter([ResourceCompleter])]
        [System.String]
        $Resource
    )

    $manifest = Get-PsDscManifest -Resource $Resource

    return $manifest
}
