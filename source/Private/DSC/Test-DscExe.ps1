function Test-DscExe
{
    <#
    .SYNOPSIS
        Check if dsc.exe is installed.

    .DESCRIPTION
        Check if dsc.exe is installed. Returns either true or false.

    .EXAMPLE
        PS C:\> Test-DscExe

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param ()

    $dsc = (Get-Command dsc -ErrorAction SilentlyContinue)
    if ($dsc)
    {
        $true
    }
    else
    {
        $false
    }
}
