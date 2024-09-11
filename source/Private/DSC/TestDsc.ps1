function TestDsc
{
    <#
    .SYNOPSIS
        Check if dsc is installed.

    .DESCRIPTION
        Check if dsc is installed. Returns either true or false.

    .EXAMPLE
        PS C:\> TestDsc

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
