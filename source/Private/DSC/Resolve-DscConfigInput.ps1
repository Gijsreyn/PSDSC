function Resolve-DscConfigInput
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $Inputs
    )

    $inputParameter = if (-not (Test-Path $Inputs -ErrorAction SilentlyContinue) -and -not ([System.IO.Path]::GetExtension($Inputs) -notin @('.json', '.yaml', '.yml')))
    {
        "--input $Inputs"
    }
    else
    {
        "--file $Inputs"
    }

    return $inputParameter

}
