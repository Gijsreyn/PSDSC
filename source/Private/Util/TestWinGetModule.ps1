function TestWinGetModule
{
    <#
    .SYNOPSIS
        Checks if the specified PowerShell module is installed.

    .DESCRIPTION
        The TestWinGetModule function checks if a specified PowerShell module is installed on the system by using the Get-Module cmdlet with the -ListAvailable parameter.
        By default, it checks for the "Microsoft.WinGet.Dsc" module, but you can specify a different module name if needed.

    .PARAMETER ModuleName
        The name of the module to check for. The default value is "Microsoft.WinGet.Dsc".

    .EXAMPLE
        TestWinGetModule
        This example checks if the "Microsoft.WinGet.Dsc" module is installed.

    .EXAMPLE
        PS C:\> TestWinGetModule -ModuleName "Pester"
        This example checks if the "Pester" module is installed.

    .OUTPUTS
        System.Boolean
        Returns $true if the module is installed, otherwise returns $false.
    #>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $false)]
        [string]$ModuleName = "Microsoft.WinGet.Dsc"
    )

    process
    {
        $module = Get-Module -Name $ModuleName -ListAvailable
        if ($module)
        {
            return $true
        }
        else
        {
            return $false
        }
    }
}
