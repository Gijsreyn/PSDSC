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

    if ([string]::IsNullOrEmpty($ResourceInput) -and [string]::IsNullOrEmpty($ParameterInput))
    {
        return
    }

    $validate, $IsResource = if ($PSBoundParameters.ContainsKey('ResourceInput'))
    {
        $ResourceInput, $true
    }
    else
    {
        $ParameterInput, $false
    }

    if (-not $IsResource -and $Command -eq 'resource')
    {
        Throw "Combination is not valid. You cannot use -ResourceInput and -Command 'resource' together."
    }

    $typeName = $validate.GetType().Name

    # validate if data is hashtable
    if ($typeName -eq 'HashTable')
    {
        Write-Debug -Message "Validated input as hash table"
        $out = $validate | ConvertTo-Json -Depth 10 -Compress
    }

    $extension = [System.IO.Path]::GetExtension($validate)

    if ($extension -and $extension -notin ('.Hashtable'))
    {
        if (-not (Test-Path $validate))
        {
            Throw "Path '$validate' does not exist. Please enter a valid path."
        }
    }

    $i = Get-Item $validate -ErrorAction SilentlyContinue

    # check if data is YAML or JSON path
    if ($extension -in ('.json', '.yml', '.yaml'))
    {
        Write-Debug -Message "Validated input as path"
        $out = $validate
    }

    if ($typeName -eq 'String' -and -not $extension)
    {
        # workaround JSON
        try
        {
            # yes we need a way to validate if JSON is actually JSON
            $out = $validate | ConvertFrom-Json -ErrorAction SilentlyContinue | ConvertTo-Json -Depth 10 -Compress
            Write-Verbose "Validated input as JSON"
        }
        catch
        {
            Write-Verbose ("Could not converted '[{0}]' data. If this was not intented, please make sure the input is valid JSON." -f $validate)
        }

        # check if yaml is present
        if ($null -eq $out)
        {
            if (TestYamlModule)
            {
                # always pass output to JSON even thought dsc handles the rest
                try
                {
                    $out = $validate | ConvertFrom-Yaml -ErrorAction SilentlyContinue | ConvertTo-Json -Depth 10 -Compress
                    Write-Verbose "Validated input as YAML"
                }
                catch
                {
                    Write-Verbose ("Could not converted '[{0}]' data. If this was not intented, please make sure the input is valid YAML." -f $validate)
                }
            }
        }
    }

    switch ($Command)
    {
        'config'
        {
            if (-not $i -and $IsResource)
            {
                $string = "--document $(($out | ConvertTo-Json) -replace "\\\\", "\")"
            }
            elseif ($i -and $IsResource)
            {
                $string = "--path $out"
            }
            elseif (-not $i -and -not $IsResource)
            {
                $string = ("--parameters $(($out | ConvertTo-Json) -replace "\\\\", "\")" -replace "`r`n", "")
            }
            else
            {
                $string = "--parameters-file $out"
            }
        }
        'resource'
        {
            if (-not $i)
            {
                $string = "--input $(($out | ConvertTo-Json) -replace "\\\\", "\")"
            }
            else
            {
                $string = "--path $out"
            }
        }
    }

    return $string
}
