function ResolveDscExe
{
    <#
    .SYNOPSIS
        Resolve the location of 'dsc.exe'.

    .DESCRIPTION
        The function ResolveDscExe searches for:

        * DSC_RESOURCE_PATH environment variable
        * PATH environment variable
        * Custom path specified using -Path

    .PARAMETER Path
        Optional parameter to directly specify 'dsc.exe'

    .PARAMETER Scope
        The scope to search for e.g. Machine, User, or Process

    .EXAMPLE
        PS C:\> $Exe = ResolveDscExe

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [OutputType([System.String])]
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPositionalParameters', '', Justification = 'PowerShell module is 7+).')]
    Param
    (
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [System.IO.FileInfo]
        $Path,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Machine', 'User', 'Process')]
        [System.String]
        $Scope = 'Machine'
    )

    if ($PSBoundParameters.ContainsKey('Path') -and ($Path.Name -ne 'dsc.exe'))
    {
        Throw "No file found at path '$Path'. Please specify the file path to 'dsc.exe'"
    }

    if ($IsWindows)
    {
        $dscResourceVar = GetEnvironmentVariable -Name 'DSC_RESOURCE_PATH' -Scope $Scope -Expanded
        if ($dscResourceVar.Length -ne 0)
        {
            $Path = Join-Path -Path $dscResourceVar -ChildPath 'dsc.exe'
        }

        if (TestWinGetModule)
        {
            # TODO: life is difficult with WinGet
            $version = (GetDscVersion) -replace "preview.", ""
            $architecture = ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture).ToString().ToLower()
            $Path = Join-Path $env:ProgramFiles 'WindowsApps' "Microsoft.DesiredStateConfiguration-Preview_3.0.$version.0_$architecture`__8wekyb3d8bbwe" 'dsc.exe'
        }

        if (-not $Path -and -not (Test-Path $Path))
        {
            # try globally and default installation when elevated
            $Path = (Get-Command dsc -ErrorAction SilentlyContinue).Source

            if (-not $Path)
            {
                # used for pipeline info
                $Path = Join-Path -Path $env:ProgramFiles 'DSC' 'dsc.exe'
            }
        }

        if (-not (Test-Path $Path -ErrorAction SilentlyContinue))
        {
            Throw "Could not locate 'dsc.exe'. Please make sure it can be found through the PATH or DSC_RESOURCE_PATH environment variable."
        }

        return $Path
    }

    # TODO: Resolve other paths on Mac/Linux
}
