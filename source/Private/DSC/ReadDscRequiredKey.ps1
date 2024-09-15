function ReadDscRequiredKey
{
    <#
    .SYNOPSIS
        Read DSC keys from Resource Manifest.

    .DESCRIPTION
        The function ReadDscRequiredKey reads the DSC keys from Resource Manifest.

    .PARAMETER ResourceManifest
        The resource manifest to read.

    .EXAMPLE
        PS C:\> ReadDscRequiredKey -Path "$env:ProgramFiles\DSC\registry.dsc.resource.json"

        Returns
        type                       description                             version resourceInput
        ----                       -----------                             ------- -------------
        Microsoft.Windows/Registry Manage Windows Registry keys and values 0.1.0

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[ResourceManifest]])]
    param
    (
        [Parameter(Mandatory = $false)]
        [System.IO.FileInfo[]]
        $ResourceManifest
    )

    begin
    {
        Write-Verbose -Message ("Starting: {0}" -f $MyInvocation.MyCommand.Name)
    }

    process
    {
        $objectBag = [System.Collections.Generic.List[ResourceManifest]]::new()

        foreach ($manifest in $ResourceManifest)
        {
            try
            {
                Write-Verbose -Message ("Reading file: '{0}'" -f $manifest.Name)
                $ctx = Get-Content $manifest | ConvertFrom-Json -ErrorAction SilentlyContinue

                $inputObject = [ResourceManifest]::new($ctx.type, $ctx.description, $ctx.version)

                # expect to be command-based
                if (-not $ctx.kind -and $ctx.schema)
                {
                    # grab both embedded and schema key using ReadDscSchema
                    $resourceInput = ReadDscSchema -Schema $ctx.schema

                    $inputObject.resourceInput = $resourceInput

                    $objectBag.Add($inputObject)
                }

                # TODO: add apters
            }
            catch
            {
                # change to warning to debug argumentcompleter
                Write-Debug -Message ("'{0}' file could not be converted to JSON object. Error: {1}" -f $manifest.Name, $PSItem.Exception.Message)
            }
        }
    }

    end
    {
        Write-Verbose -Message ("Ended: {0}" -f $MyInvocation.MyCommand.Name)

        # return
        $objectBag
    }
}
