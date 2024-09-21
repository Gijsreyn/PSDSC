function GetNetProcessObject
{
    <#
    .SYNOPSIS
        Produce .NET System.Diagnostics.Process object.

    .DESCRIPTION
        The function GetNetProcessObject instantiaties a .NET process object to be returned.

    .PARAMETER Arguments
        The arguments to add to the run.

    .PARAMETER ExePath
        The executable to start. Defaults to 'dsc.exe'

    .EXAMPLE
        PS C:\> GetNetProcessObject -Arguments 'resource get --resource Microsoft.Windows/RebootPending'

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Diagnostics.Process])]
    param
    (
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [System.String]
        $Arguments,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [System.String]
        $ExePath = (ResolveDscExe)
    )

    # use System.Diagnostics.Process instead of & or Invoke-Expression
    $proc = [System.Diagnostics.Process]::new()
    $arguments = (-not [string]::IsNullOrEmpty($Arguments)) ? $Arguments : '--version'

    # build process start info with redirects
    $procStartinfo = [System.Diagnostics.ProcessStartInfo]::new($ExePath, $arguments)
    $procStartinfo.UseShellExecute = $false
    $procStartinfo.RedirectStandardOutput = $true
    $procStartinfo.RedirectStandardError = $true

    $proc.StartInfo = $procStartinfo

    # return object
    return $proc
}
