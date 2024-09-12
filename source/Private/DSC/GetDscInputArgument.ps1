function GetDscInputArgument
{
    <#
    .SYNOPSIS
        Get the DSC input for resource(s).

    .DESCRIPTION
        The function GetDscInputArgument gets the DSC input required for resource available to DSC's core engine.

    .PARAMETER Path
        The location of JSON resource manifest to look for.

    .EXAMPLE
        PS C:\> GetDscInputArgument -Path "$env:ProgramFiles\DSC"

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Output object not needed.')]
    param
    (
        [Parameter(Mandatory = $false)]
        [System.String]
        $Path
    )

    if (-not $PSBoundParameters.ContainsKey('Path'))
    {
        $Path = Split-Path (ResolveDscExe) -Parent
    }

    $manifestFile = Get-ChildItem -Path $Path -Depth 1 -Filter "*.dsc.resource.json"

    $o = [System.Collections.Generic.List[object]]::new()

    foreach ($manifest in $manifestFile)
    {
        try
        {
            $ctx = Get-Content $Manifest | ConvertFrom-Json -ErrorAction SilentlyContinue

            $inputObject = [PSCustomObject]@{
                type        = $ctx.type
                description = $ctx.description
                version     = $ctx.version
            }

            # TODO: add embedded schema and adapter type kind
            # TODO: make function out of below as embedded returns same data
            if (-not $ctx.kind -and $ctx.schema.command)
            {
                # expect to be command-based DSC resource, also known as Resource kind
                $exePath = ResolveDscExe
                # use full exe path instead counting on environment variables to be present
                $fullExePath = [System.String]::Concat("$(Split-Path -Path $exePath)\", $ctx.schema.command.executable, '.exe')
                $process = GetNetProcessObject -SubCommand $fullExePath -ExePath $ctx.schema.command.executable
                $out = StartNetProcessObject -Process $process

                if ($out.ExitCode -eq 0)
                {
                    try
                    {
                        $schema = $out.Output | ConvertFrom-Json -ErrorAction SilentlyContinue

                        $exampleCode = @()

                        # add the required keys as example
                        $exampleCode += $schema.required.Foreach({
                                @{ $_ = "<$($_)>" } | ConvertTo-Json -Depth 10 -Compress
                            })

                        # go through optional keys as example
                        $props = $schema.properties | Get-Member | Where-Object { $_.MemberType -eq 'NoteProperty' } | Select-Object -ExpandProperty Name

                        # TODO: validate type in properties to set proper values when returning data

                        $hash = @{}
                        foreach ($prop in $props)
                        {
                            $hash.Add($prop , "<$prop>")
                        }

                        $exampleCode += ($hash | ConvertTo-Json -Compress)

                        Write-Debug -Message ("Adding resource input data for '{0}'" -f $ctx.type)
                        $inputObject | Add-Member -NotePropertyName resourceInput -TypeName NoteProperty -NotePropertyValue @($exampleCode) -Force
                    }
                    catch
                    {
                        Write-Warning -Message ("There is no JSON returned for file: '{0}'." -f $manifest.Name)
                    }
                }
            }
        }
        catch
        {
            Write-Warning -Message ("Could not convert manifest file: '{0}'. Error: {1}" -f $manifest.Name, $_.Exception.Message)
        }

        $o.Add($inputObject)
    }

    $o
}
