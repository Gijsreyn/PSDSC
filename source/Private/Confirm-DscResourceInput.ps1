function Confirm-DscResourceInput
{
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
        [ValidateSet('get', 'set', 'test')]
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

    return $ResourceInput
}
