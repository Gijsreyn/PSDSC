function GetEnvVar
{
    <#
    .SYNOPSIS
        Get Environment variable value.

    .DESCRIPTION
        Get Environment variable value. To see more details, check out the .NOTES section for link.

    .PARAMETER Name
        The variable name to look for.

    .PARAMETER User
        get variable from user scope (persistent)

    .PARAMETER Machine
        get variable from machine scope (persistent)

    .PARAMETER Current
        (default=true) get variable from current process scope

    .EXAMPLE
        PS C:\> $machinepath = getenvvar "PATH" -machine

    .NOTES
        Site: https://github.com/qbikez/ps-pathutils/tree/master
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'Not my store.')]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [System.Management.Automation.SwitchParameter]
        $User,

        [System.Management.Automation.SwitchParameter]
        $Machine,

        [System.Management.Automation.SwitchParameter]
        $Current
    )

    $val = @()
    if ($user)
    {
        $val += [System.Environment]::GetEnvironmentVariable($name, [System.EnvironmentVariableTarget]::User);
    }
    if ($machine)
    {
        $val += [System.Environment]::GetEnvironmentVariable($name, [System.EnvironmentVariableTarget]::Machine);
    }
    if (!$user.IsPresent -and !$machine.IsPresent)
    {
        $current = $true
    }
    if ($current)
    {
        $val = invoke-expression "`$env:$name"
    }
    if ($null -ne $val)
    {
        $p = $val -Split ";"
    }
    else
    {
        $p = @()
    }

    return $p
}
