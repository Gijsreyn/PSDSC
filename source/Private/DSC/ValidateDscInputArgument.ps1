function ValidateDscInputArgument
{
    <#
    .SYNOPSIS
        Validate input provided to 'dsc.exe'

    .DESCRIPTION
        The function validates the input provided by the user before parsing it to 'dsc.exe'.
        Input that can be specified:

        * JSON/YAML
        * PowerShell hashtable
        * TODO: Add .ps1 possibility

    .PARAMETER StringBuilder
        Pass in string builder object to append strings

    .PARAMETER ResourceInput
        The resource input to provide. Supports JSON, path and PowerShell scripts.

    .EXAMPLE
        PS C:\> $Sb = [System.Text.StringBuilder]::new()
        PS C:\> ValidateDscInputArgument -StringBuilder $Sb -ResourceInput @{keyPath = 'HKCU\Microsoft'}

        Returns the following output:
        PS C:\> $Sb.ToString()
        --input "{\"keyPath\":\"HKCU\\Microsoft\"}"

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

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [object]
        $ResourceInput
    )

    $stringIn = ""

    # try JSON cast
    try
    {
        if ($ResourceInput | ConvertFrom-Json -ErrorAction SilentlyContinue)
        {
            $stringIn = " --input $(($ResourceInput | ConvertTo-Json) -replace "\\\\", "\")"
        }
    }
    catch
    {
        Write-Debug -Message "Not JSON input."
    }

    if (-not [string]::IsNullOrEmpty($ResourceInput))
    {
        $objectType = $ResourceInput.GetType().Name

        Write-Debug -Message ("Object passed in of type: '{0}'" -f $objectType)

        # do it for hash table
        if ($objectType -eq 'Hashtable')
        {
            $stringIn = " --input $(($ResourceInput | ConvertTo-Json -Depth 10 -Compress | ConvertTo-Json) -replace "\\\\", "\" | Out-String)"
        }

        # else try picking it up by path
        $extension = (Get-Item -Path $ResourceInput -ErrorAction SilentlyContinue).Extension

        switch ($extension)
        {
            ".yaml"
            {
                if (TestYamlModule)
                {
                    $stringIn = " --path $ResourceInput"
                }
            }
            ".json"
            {
                $stringIn = " --path $ResourceInput"
            }
            # TODO: Add possibility to include .ps1 and use ConvertTo-DscYaml or ConvertTo-DscJson
            default
            {
                # $stringIn = ""
            }
        }
    }

    Write-Debug -Message "Adding input/path argument with $stringIn"
    $StringBuilder.Append($stringIn) | Out-Null
}
