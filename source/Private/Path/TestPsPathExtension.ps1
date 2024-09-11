function TestPsPathExtension
{
    <#
    .SYNOPSIS
        Test if path is PowerShell

    .DESCRIPTION
        The function TestPsPathExtension tests if a path is of (.ps1) extension.

    .PARAMETER Path
        The path to PowerShell file.

    .EXAMPLE
        PS C:\> TestPsPathExtension -Path 'test.ps1'

        Return true

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path
    )

    $res = $true

    if (-not (Test-Path $Path))
    {
        $res = $false
    }

    if (([System.IO.Path]::GetExtension($Path) -ne ".ps1"))
    {
        $res = $false
    }

    return $res
}
