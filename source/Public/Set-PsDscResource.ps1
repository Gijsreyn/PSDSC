function Set-PsDscResource
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
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

    $processArgument = Confirm-DscResourceInput -Resource $Resource -Inputs $resourceInput -Operation 'set'

    $Process = Get-ProcessObject -Argument $processArgument

    if ($PSCmdlet.ShouldProcess("'$Resource' with '$resourceInput'" , "Set"))
    {
        $result = Get-ProcessResult -Process $Process
    }

    return $result
}
