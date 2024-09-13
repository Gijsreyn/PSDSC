function ReadDscRequiredKey
{
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[ManifestFile]])]
    param
    (
        [Parameter(Mandatory = $false)]
        [System.IO.FileInfo[]]
        $ManifestFile
    )

    begin
    {
        Write-Verbose -Message ("Starting: {0}" -f $MyInvocation.MyCommand.Name)
    }

    process
    {
        $objectBag = [System.Collections.Generic.List[ManifestFile]]::new()

        foreach ($manifest in $ManifestFile)
        {
            try
            {
                Write-Verbose -Message ("Reading file: '{0}'" -f $manifest.Name)
                $ctx = Get-Content $manifest | ConvertFrom-Json -ErrorAction SilentlyContinue

                $inputObject = [ManifestFile]::new($ctx.type, $ctx.description, $ctx.version)

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
