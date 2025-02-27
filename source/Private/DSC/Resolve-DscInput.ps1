function Resolve-DscInput
{
    <#
    .SYNOPSIS
        Resolve the input to a JSON string.

    .DESCRIPTION
        The function Resolve-DscInput resolves the input to a JSON string. The input can be a hashtable, JSON, YAML, or a file path (both JSON and YAML).

    .PARAMETER Inputs
        The input to provide. Supports a hashtable of key-value pairs, JSON, YAML, or a file path (both JSON and YAML).

    .EXAMPLE
        PS C:\> Resolve-DscInput -Inputs @{ keyPath = 'HKCU\1\2' }

        This example resolves the hashtable input to a JSON string.

    .EXAMPLE
        PS C:\> Resolve-DscInput -Inputs 'registry.json'

        This example resolves the JSON input to a JSON string.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $Inputs
    )

    if ([System.IO.Path]::GetExtension($Inputs) -in @('.json', '.yaml', '.yml') -and (Test-Path $Inputs -ErrorAction SilentlyContinue))
    {
        return $Inputs
    }

    # Check for YAML, hash table, or JSON input
    $stringData = if ($Inputs -is [Hashtable])
    {
        $Inputs
    }
    elseif (Test-Json $Inputs -ErrorAction SilentlyContinue)
    {
        $Inputs
    }
    elseif (Get-Command ConvertFrom-Yaml -ErrorAction SilentlyContinue)
    {
        $Inputs | ConvertFrom-Yaml
    }
    else
    {
        throw "Failed to convert input to JSON. Make sure the input is a valid JSON, YAML, or a hashtable which can be converted to JSON."
    }

    $json = ($stringData | ConvertTo-Json -Depth 10 -Compress | ConvertTo-Json) -replace "\\\\", "\" | Out-String

    Write-Debug -Message "The resolved input is:"
    Write-Debug -Message $json
    return ($json -replace "`r`n", "")
}
