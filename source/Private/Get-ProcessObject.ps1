function Get-ProcessObject
{
    [CmdletBinding()]
    [OutputType([System.Diagnostics.Process])]
    param
    (
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [System.String]
        $Argument,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [System.String]
        $DscExe = (ResolveDscExe)
    )

    $process = [System.Diagnostics.Process]::new()

    $startParameters = @{
        FileName               = $DscExe
        UseShellExecute        = $false
        RedirectStandardOutput = $true
        RedirectStandardError  = $true
    }

    if (-not [string]::IsNullOrEmpty($Argument))
    {
        $startParameters['Arguments'] = $Argument
    }

    $startInfo = [System.Diagnostics.ProcessStartInfo]$startParameters

    $process.StartInfo = $startInfo

    return $process
}
