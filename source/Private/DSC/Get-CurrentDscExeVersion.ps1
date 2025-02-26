function Get-CurrentDscExeVersion
{
    <#
    .SYNOPSIS
        Get the current version of the installed DSC executable.

    .DESCRIPTION
        The function Get-CurrentDscExeVersion gets the current version of the installed DSC executable.

    .EXAMPLE
        PS C:\> Get-CurrentDscExeVersion

        Returns the current version of the installed DSC executable.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    if (Test-DscExe)
    {
        $dscVersion = (& dsc --version).Split(' ' )[1]
        return $dscVersion
    }
    else
    {
        return $null
    }
}
