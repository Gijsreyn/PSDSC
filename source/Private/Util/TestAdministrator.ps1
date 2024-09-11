function TestAdministrator
{
    <#
    .SYNOPSIS
        Test if user is currently running elevated or not.

    .DESCRIPTION
        Test if user is currently running elevated or not.

    .EXAMPLE
        TestAdministrator

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>

    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
