function Confirm-DscConfigInput
{
    <#
    .SYNOPSIS
        Private function to confirm the input provided by the user.

    .DESCRIPTION
        The function Confirm-DscConfigInput confirms the config input before invoking the DSC version 3 command-line utility.
    .PARAMETER Inputs
        The input to provide. Supports a hashtable of key-value pairs, JSON, YAML, or a file path (both JSON and YAML).

    .PARAMETER Operation
        The operation to be performed. Supports 'get', 'set', 'test', and 'export'.

    .PARAMETER Parameter
        The parameter to provide. Supports a hashtable of key-value pairs, JSON, YAML, or a file path (both JSON and YAML).

    .EXAMPLE
        PS C:\> Confirm-DscConfigInput -Inputs '{"keyPath":"HKCU\\1\\2"' -Operation 'get'

        This example returns the string 'config get --resource Microsoft.Windows/Registry --input {"keyPath":"HKCU\\1\\2"}'.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Inputs,

        [Parameter(Mandatory = $true)]
        [ValidateSet('get', 'set', 'test', 'export')]
        [System.String]
        $Operation,

        [Parameter()]
        [AllowNull()]
        [System.String]
        $Parameter
    )

    $sb = [System.Text.StringBuilder]::new('config')

    if (-not [string]::IsNullOrEmpty($Parameter))
    {
        $parameterInput = if (-not (Test-Path $Parameter -ErrorAction SilentlyContinue) -and ([System.IO.Path]::GetExtension($Parameter) -notin @('.json', '.yaml', '.yml')))
        {
            # Resolve the parameter input and append it to the command
            $Parameter = Resolve-DscInput -Inputs $Parameter
            " --parameters $Parameter"
        }
        else
        {
            " --parameters-file $Parameter"
        }

        # Append the parameter to the command
        [void]$sb.Append($parameterInput)
    }

    [void]$sb.Append(" $Operation")

    $inputParameter = if (-not (Test-Path $Inputs -ErrorAction SilentlyContinue) -and ([System.IO.Path]::GetExtension($Inputs) -notin @('.json', '.yaml', '.yml')))
    {
        "--input $Inputs"
    }
    else
    {
        "--file $Inputs"
    }

    [void]$sb.Append(" $inputParameter")

    return $sb.ToString()
}
