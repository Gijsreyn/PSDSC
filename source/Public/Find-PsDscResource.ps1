function Find-PsDscResource
{
    <#
    .SYNOPSIS
        Invoke the list operation for DSC version 3 command-line utility.

    .DESCRIPTION
        The function Find-PsDscResource invokes the list operation on Desired State Configuration version 3 executable 'dsc.exe'.

    .PARAMETER AdapterName
        The adapter name to filter on. Supported values are 'Microsoft.DSC/PowerShell', 'Microsoft.Windows/WMI', and 'Microsoft.Windows/WindowsPowerShell'.

        The adapter name is optional.

    .PARAMETER Description
        The description to filter on. The description is optional.

    .PARAMETER Tag
        The tag to filter on. The tag is optional.

    .EXAMPLE
        PS C:\> Find-PsDscResource -Adapter 'Microsoft.Windows/WindowsPowerShell' -Description 'This is a test description' -Tag 'Test'

        This example finds the DSC resources with the specified adapter, description, and tag.

    .EXAMPLE
        PS C:\> Find-PsDscResource

        This example finds the DSC resources without any filters. It does not get any adapted resources.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
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

    $process = Get-ProcessObject -Argument $processArgument

    $result = Get-ProcessResult -Process $process

    return $result
}
