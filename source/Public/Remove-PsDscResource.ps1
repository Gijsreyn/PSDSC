function Remove-PsDscResource
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [Alias('ResourceName')]
        [ArgumentCompleter([DscResourceCompleter])]
        [System.String]
        $Resource,

        [Parameter(Mandatory = $true)]
        [ArgumentCompleter([DscResourceInputCompleter])]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $Inputs
    )

    $resourceInput = Resolve-DscResourceInput -Inputs $Inputs

    $processArgument = Confirm-DscResourceInput -Resource $Resource -Inputs $resourceInput -Operation 'delete'

    $Process = Get-ProcessObject -Argument $processArgument

    if ($PSCmdlet.ShouldProcess("'$Resource' with '$resourceInput'" , "Remove"))
    {
        $result = Get-ProcessResult -Process $Process
    }

    return $result
}
