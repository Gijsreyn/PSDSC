function ConvertTo-PsDscInput
{
    <#
    .SYNOPSIS
        Converts the provided manifest to a DSC resource input format.

    .DESCRIPTION
        The function ConvertTo-PsDscInput converts the provided manifest to a Desired State Configuration resource input format. It supports extracting required properties only if specified.

    .PARAMETER Manifest
        The manifest to be converted to input.

    .PARAMETER RequiredOnly
        Switch to indicate if only required properties should be included.

    .EXAMPLE
        PS C:\> Get-PsDscManifest -Resource 'Microsoft/OSInfo'
        PS C:\> ConvertTo-PsDscInput -Manifest $manifest -RequiredOnly

        Returns:
        Name                           Value
        ----                           -----
        family                         string
        codename                       string
        edition                        string
        version                        string
        architecture                   string
        $id                            string
        bitness                        string

    .NOTES
    For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [AllowNull()]
        [System.Management.Automation.PSObject]
        $Manifest,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $RequiredOnly
    )

    $resourceInput = @{}

    if ($Manifest)
    {
        # Check if there is a schema embedded in the manifest
        if ($Manifest.schema.embedded)
        {
            if ($RequiredOnly.IsPresent)
            {
                foreach ($requiredValue in $Manifest.schema.embedded.required)
                {
                    $resourceInput.Add($requiredValue, $null)
                }
            }
            else
            {
                $noteProperties = $manifest.schema.embedded.properties | Foreach-Object { Get-Member -MemberType NoteProperty -InputObject $_ }

                foreach ($noteProperty in $noteProperties)
                {
                    $resourceInput.Add($noteProperty.Name, $manifest.schema.embedded.properties.$($noteProperty.Name).type)
                }
            }
        }
    }

    return $resourceInput
}
