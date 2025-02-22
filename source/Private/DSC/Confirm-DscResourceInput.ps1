function Confirm-DscResourceInput
{
    <#
    .SYNOPSIS
        Private function to confirm the input provided by the user.

    .DESCRIPTION
        The function Confirm-DscResourceInput confirms the resource input before invoking the DSC version 3 command-line utility.

    .PARAMETER Resource
        The resource (name) to be confirmed.

    .PARAMETER Inputs
        The input to provide. Supports a hashtable of key-value pairs, JSON, YAML, or a file path (both JSON and YAML).

    .PARAMETER Operation
        The operation to be performed. Supports 'get', 'set', 'test', and 'delete'.

    .EXAMPLE
        PS C:\> Confirm-DscResourceInput -Resource 'Microsoft.Windows/Registry' -Inputs '{"keyPath":"HKCU\\1\\2"' -Operation 'get'

        This example returns the string 'resource get --resource Microsoft.Windows/Registry --input {"keyPath":"HKCU\\1\\2"}'.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Resource,

        [Parameter(Mandatory = $true)]
        [AllowNull()]
        [System.Object]
        $Inputs,

        [Parameter(Mandatory = $true)]
        [ValidateSet('get', 'set', 'test', 'delete')]
        [System.String]
        $Operation

    )

    $ResourceInput = "resource $Operation --resource $Resource"

    if (Test-Path -LiteralPath $Inputs)
    {
        $ResourceInput += " --file $Inputs"
    }
    else
    {
        $ResourceInput += " --input $Inputs"
    }

    Write-Debug -Message "The resource input is: $ResourceInput"

    return $ResourceInput
}
