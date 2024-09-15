function ReadDscSchema
{
    <#
    .SYNOPSIS
        Read DSC schema information.

    .DESCRIPTION
        The function ReadDscSchema reads the DSC schema information and builds the resource input required.

    .PARAMETER Schema
        The schema information to read.

    .EXAMPLE
        PS C:\> $ctx = (Get-Content "$env:ProgramFiles\DSC\registry.dsc.resource.json" | ConvertFrom-Json)
        PS C:\> ReadDscSchema -Schema $ctx.schema

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [psobject]
        $Schema
    )

    begin
    {
        function _readSchemaProperty ($schemaObject)
        {
            $exampleCode = @()

            # add the required keys as example
            $exampleCode += $schemaObject.required.Foreach({
                    @{ $_ = "<$($_)>" } | ConvertTo-Json -Depth 10 -Compress
                })

            # go through optional keys as example
            $props = $schema.properties | Get-Member | Where-Object { $_.MemberType -eq 'NoteProperty' } | Select-Object -ExpandProperty Name

            $hash = @{}
            foreach ($prop in $props)
            {
                $hash.Add($prop , "<$prop>")
            }

            $exampleCode += ($hash | ConvertTo-Json -Compress)

            return $exampleCode
        }

        Write-Verbose -Message ("Starting: {0}" -f $MyInvocation.MyCommand.Name)
    }

    process
    {
        $exampleCode = @()

        if ($Schema.command)
        {
            # expect to be command-based DSC resource, also known as Resource kind
            $exePath = ResolveDscExe
            # use full exe path instead counting on environment variables to be present
            $fullExePath = [System.String]::Concat("$(Split-Path -Path $exePath)\", $ctx.schema.command.executable, '.exe')
            $process = GetNetProcessObject -SubCommand "$($ctx.schema.command.args)" -ExePath $fullExePath
            $out = StartNetProcessObject -Process $process

            if ($out.ExitCode -eq 0)
            {
                $schema = $out.Output | ConvertFrom-Json
                $exampleCode = _readSchemaProperty -schemaObject $schema
            }
        }

        if ($Schema.embedded)
        {
            $schema = $Schema.embedded
            $exampleCode = _readSchemaProperty -schemaObject $schema
        }
    }
    end
    {
        Write-Verbose -Message ("Ended: {0}" -f $MyInvocation.MyCommand.Name)
        # return
        return $exampleCode
    }
}
