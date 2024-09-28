function ConfirmDscInput
{
    <#
    .SYNOPSIS
        Confirm input and builds arguments required for 'dsc.exe'

    .DESCRIPTION
        The function ConfirmDscInput confirms the input that is passed from higher-level functions. It returns the arguments for building the System.Diagnostics.Process object.

    .PARAMETER Command
        The command to run e.g. config

    .PARAMETER ResourceInput
        The resource input to provide. Supports JSON, YAML path and PowerShell hash table.

    .PARAMETER ParameterInput
        Optionally, the parameter input to provide.

    .EXAMPLE
        PS C:\> ConfirmDscInput -Command resource -ResourceInput @{keyPath = 'HKCU\1'}

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding(DefaultParameterSetName = 'ByInput')]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('config', 'resource')]
        [System.String]
        $Command,

        [Parameter(Mandatory = $false, ParameterSetName = 'ByInput')]
        [System.Object]
        [AllowNull()]
        $ResourceInput,

        [Parameter(Mandatory = $false, ParameterSetName = 'ByParameter')]
        [System.Object]
        [AllowNull()]
        $ParameterInput
    )

    $Path = $false

    if ([string]::IsNullOrEmpty($ResourceInput) -and [string]::IsNullOrEmpty($ParameterInput))
    {
        return
    }

    if ($PSCmdlet.ParameterSetName -eq 'ByInput' -and $ResourceInput)
    {
        # check the type of ResourceInput and process accordingly
        if ($ResourceInput -is [string] -and (Test-Path -Path $ResourceInput -ErrorAction SilentlyContinue))
        {
            $extension = (Get-Item $ResourceInput -ErrorAction SilentlyContinue).Extension
            if ($extension -in @('.json', '.yaml', '.yml'))
            {
                Write-Debug -Message "The '$ResourceInput' is a valid path string."
                $out = $ResourceInput

                # set variable
                $Path = $true
            }

            if ($extension -eq '.ps1' -and $Command -eq 'config')
            {
                Write-Debug -Message "The '$ResourceInput' is a PowerShell (.ps1) script. Converting..."
                $out = ConvertTo-DscJson -Path $ResourceInput

                Write-Debug -Message "The converted JSON is:"
                Write-Debug -Message $out
            }
        }
        elseif ($ResourceInput -is [hashtable])
        {
            # resourceInput is a hashtable
            $json = $ResourceInput | ConvertTo-Json -Depth 10 -Compress
            $out = $json
        }
        elseif ($ResourceInput -is [string])
        {
            try
            {
                $json = $ResourceInput | ConvertFrom-Json
                $out = $json | ConvertTo-Json -Depth 10 -Compress
            }
            catch
            {
                Write-Debug -Message "The '$ResourceInput' is not a valid JSON string. Please make sure the input is valid JSON."
            }
        }
        else
        {
            # TODO: check if YAML can be used to convert with ConvertFrom-Yaml
        }
    }


    # process ParameterInput if provided
    if ($PSCmdlet.ParameterSetName -eq 'ByParameter' -and $ParameterInput)
    {
        if ($ParameterInput -is [string] -and (Test-Path -Path $ParameterInput -ErrorAction SilentlyContinue))
        {
            $extension = (Get-Item $ParameterInput -ErrorAction SilentlyContinue).Extension
            if ($extension -in @('.json', '.yaml', '.yml'))
            {
                Write-Debug -Message "The '$ParameterInput' is a valid path string."
                $out = $ParameterInput

                # set variable
                $Path = $true
            }
        }
        elseif ($ParameterInput -is [hashtable])
        {
            $json = $ParameterInput | ConvertTo-Json -Compress
            $out = $json
        }
        elseif ($ParameterInput -is [string])
        {
            try
            {
                $json = $ParameterInput | ConvertFrom-Json
                $out = $json | ConvertTo-Json -Depth 10 -Compress
            }
            catch
            {
                Write-Debug -Message "The '$ParameterInput' is not a valid JSON string. Please make sure the input is valid JSON."
            }
        }
    }

    switch ($Command)
    {
        'config'
        {
            if ($Path -and $PSCmdlet.ParameterSetName -eq 'ByInput')
            {
                $string = "--path $out"
            }
            elseif ($PSCmdlet.ParameterSetName -eq 'ByInput')
            {
                $string = ("--document {0}" -f ($out | ConvertTo-Json) -replace "\\\\", "\")
            }
            elseif ($Path -and $PSCmdlet.ParameterSetName -eq 'ByParameter')
            {
                $string = "--parameters-file $out"
            }
            else
            {
                $string = ("--parameters $(($out | ConvertTo-Json) -replace "\\\\", "\")" -replace "`r`n", "")
            }
        }
        'resource'
        {
            if (-not $extension)
            {
                $string = ("--input {0}" -f ($out | ConvertTo-Json) -replace "\\\\", "\")
            }
            else
            {
                $string = "--path $out"
            }
        }
    }
    return $string
}
