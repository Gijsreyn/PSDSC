function Test-PsDscResource
{
    [CmdletBinding()]
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

    $processArgument = Confirm-DscResourceInput -Resource $Resource -Inputs $resourceInput -Operation 'test'

    $Process = Get-ProcessObject -Argument $processArgument

    $result = Get-ProcessResult -Process $Process

    return $result
}
