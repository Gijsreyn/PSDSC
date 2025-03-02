function Initialize-PsDscResourceInput
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [Alias('ResourceName')]
        [ArgumentCompleter([ResourceCompleter])]
        [System.String]
        $Resource,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RequiredOnly
    )

    $manifest = Get-PsDscManifest -Resource $Resource

    $resourceInput = ConvertTo-PsDscInput -Manifest $manifest -RequiredOnly:$RequiredOnly

    return $resourceInput
}
