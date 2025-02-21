function Find-PsDscResource
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false)]
        [Alias('Adapter')]
        [System.String]
        $AdapterName,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Description,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Tag
    )

    $resourceInput = @('resource', 'list')

    # TODO: Validate if we can fetch adapters from different location
    if (-not [string]::IsNullOrEmpty($AdapterName))
    {
        # TODO: We can return if PSAdapterCache.json is present without calling dsc.exe
        if ($AdapterName -in @( 'Microsoft.DSC/PowerShell', 'Microsoft.Windows/WMI', 'Microsoft.Windows/WindowsPowerShell'))
        {
            $resourceInput += "--adapter $AdapterName"
        }
    }

    if (-not [string]::IsNullOrEmpty($Description))
    {
        $resourceInput += "--description $Description"
    }

    if (-not [string]::IsNullOrEmpty($Tag))
    {
        $resourceInput += "--tag $Tag"
    }

    $processArgument = $resourceInput -join ' '

    $Process = Get-ProcessObject -Argument $processArgument

    $result = Get-ProcessResult -Process $Process

    return $result
}
