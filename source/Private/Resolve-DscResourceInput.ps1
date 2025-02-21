function Resolve-DscResourceInput
{
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
    return $json
}
