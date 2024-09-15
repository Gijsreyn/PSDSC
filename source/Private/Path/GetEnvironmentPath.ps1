function GetEnvironmentPath
{
    <#
    .SYNOPSIS
        Get the environment path.

    .DESCRIPTION
        The function GetEnvironmentPath gets the environment path.

    .PARAMETER Scope
        [System.EnvironmentVariableTarget], [String]
        Specify the scope to search for the target Environment Variable.

        Process : Environment Variables in the running process.

        User    : Environment Variables in the User Scope affect the Global Environment Variables for the current user.

        Machine : Environment Variables in the Machine Scope change the settings in the registry for all users.

    .EXAMPLE
        PS C:\> GetEnvironmentPath -Scope Machine

    .NOTES
        https://github.com/rbleattler/xEnvironmentVariables
    #>
    param (
        [Parameter(Mandatory)]
        [System.EnvironmentVariableTarget]
        $Scope
    )
    switch ($Scope)
    {
        "Process"
        {
            "Env:"
        }
        "User"
        {
            "Registry::HKEY_CURRENT_USER\Environment"
        }
        "Machine"
        {
            "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
        }
        Default
        {
            $null
        }
    }
}
