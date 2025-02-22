function Resolve-DscResourceInput
{
    <#
    .SYNOPSIS
        Resolve the input to a JSON string.

    .DESCRIPTION
        The function Resolve-DscResourceInput resolves the input to a JSON string. The input can be a hashtable, JSON, YAML, or a file path (both JSON and YAML).

    .PARAMETER Inputs
        The input to provide. Supports a hashtable of key-value pairs, JSON, YAML, or a file path (both JSON and YAML).

    .EXAMPLE
        PS C:\> Resolve-DscResourceInput -Inputs @{ keyPath = 'HKCU\1\2' }

        This example resolves the hashtable input to a JSON string.

    .EXAMPLE
        PS C:\> Resolve-DscResourceInput -Inputs 'registry.json'

        This example resolves the JSON input to a JSON string.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $Inputs
    )

    if ($Inputs -is [Hashtable])
    {
        Write-Debug -Message "The input is a hashtable."
    }
    elseif ($Inputs -is [String] -and -not ([System.IO.File]::Exists($Inputs)))
    {
        try
        {
            # Try to convert the input to JSON
            $Inputs = $Inputs | ConvertFrom-Json -ErrorAction Stop
        }
        catch
        {
            try
            {
                # If that fails, try to convert the input to YAML
                $Inputs = $Inputs | ConvertFrom-Yaml -ErrorAction Stop

                # If that succeeds, convert the YAML to JSON
                $Inputs = $Inputs  | ConvertTo-Json | ConvertFrom-Json
            }
            catch
            {
                throw "Failed to convert input to JSON or YAML. Error: $_"
            }
        }
    }
    elseif ([System.IO.Path]::GetExtension($Inputs) -in @('.json', '.yaml', '.yml') -and (Test-Path $Inputs -ErrorAction SilentlyContinue))
    {
        return $Inputs
    }
    else
    {
        throw "The input '$Inputs' is not a valid input. Please provide a valid input file, JSON, YAML, or PowerShell Hashtable."
    }

    $json = ($Inputs | ConvertTo-Json -Depth 10 -Compress | ConvertTo-Json) -replace "\\\\", "\" | Out-String

    Write-Debug -Message "The resolved input is:"
    Write-Debug -Message $json
    return ($json -replace "`r`n", "")
}
