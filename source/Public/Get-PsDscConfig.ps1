function Get-PsDscConfig
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $Inputs
    )

    $inputParameter = Resolve-DscConfigInput -Inputs $Inputs

    $processArgument
}
