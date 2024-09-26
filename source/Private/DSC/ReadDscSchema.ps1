function ReadDscSchema
{
    <#
    .SYNOPSIS
        Read DSC schema information.

    .DESCRIPTION
        The function ReadDscSchema reads the DSC schema information and builds the resource input required.

    .PARAMETER Schema
        The schema information to read.

    .PARAMETER BuildHashTable
        A switch parameter to indicate if the output should be a hashtable.

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
        $Schema,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]
        $BuildHashTable
    )

    begin
    {
        Write-Verbose -Message ("Starting: {0}" -f $MyInvocation.MyCommand.Name)
    }

    process
    {
        $exampleCode = @()

        $schemaParams = @{
            schemaObject   = $null
            BuildHashTable = $BuildHashTable.IsPresent
        }

        if ($Schema.command)
        {
            # expect to be command-based DSC resource, also known as Resource kind
            $exePath = ResolveDscExe
            # use full exe path instead counting on environment variables to be present
            $fullExePath = [System.String]::Concat("$(Split-Path -Path $exePath)\", $ctx.schema.command.executable, '.exe')
            $process = GetNetProcessObject -Arguments "$($ctx.schema.command.args)" -ExePath $fullExePath
            $out = StartNetProcessObject -Process $process

            if ($out.ExitCode -eq 0)
            {
                $schemaParams.schemaObject = $out.Output | ConvertFrom-Json
                $exampleCode = ReadDscSchemaProperty @schemaParams
            }
        }

        if ($Schema.embedded)
        {
            $schemaParams.schemaObject = $Schema.embedded
            $exampleCode = ReadDscSchemaProperty @schemaParams
        }
    }
    end
    {
        Write-Verbose -Message ("Ended: {0}" -f $MyInvocation.MyCommand.Name)
        # return
        return $exampleCode
    }
}
