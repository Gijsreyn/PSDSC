function Set-PsDscResource
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [Alias('Name')]
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

    if ($PSCmdlet.ShouldProcess("Set", "'$Resource' with '$resourceInput'"))
    {
        $result = Get-ProcessResult -Process $Process
    }

    return $result
}
