function AddDscResource
{
    <#
    .SYNOPSIS
        Add resource to StringBuilder.

    .DESCRIPTION
        The function AddDscResource adds the resource on the StringBuilder passed.

    .PARAMETER StringBuilder
        The StringBuilder object.

    .PARAMETER ResourceName
        The resource name to add.

    .EXAMPLE
        PS C:\> $Sb = [System.Text.StringBuilder]::new()
        PS C:\> AddDscResource -Sb $Sb -ResourceName Microsoft.Windows/Registry

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [Alias('Sb')]
        [System.Text.StringBuilder]
        $StringBuilder,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName
    )

    Write-Debug -Message "Adding $ResourceName argument"
    $StringBuilder.Append(" --resource $ResourceName") | Out-Null
}
