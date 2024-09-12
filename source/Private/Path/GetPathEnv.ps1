function GetPathEnv
{
    <#
    .SYNOPSIS
        Gets PATH env variable

    .DESCRIPTION
        Gets PATH env variable. To see more details, check out the .NOTES section for link.

    .PARAMETER User
        Get the value from user scope

    .PARAMETER Machine
        (default) Get the value from machine scope

    .PARAMETER Current
        Get the value from process scope

    .PARAMETER All
        Return values for each scope

    .EXAMPLE
        PS C:\> $p = GetPathEnv -Machine

    .NOTES
        Site: https://github.com/qbikez/ps-pathutils/tree/master
    #>

    [CmdLetBinding(DefaultParameterSetName = "scoped")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Not my store.')]
    param
    (
        [Parameter(ParameterSetName = "scoped")]
        [System.Management.Automation.SwitchParameter]
        $User,

        [Parameter(ParameterSetName = "scoped")]
        [System.Management.Automation.SwitchParameter]
        $Machine,

        [Alias("process")]
        [Parameter(ParameterSetName = "scoped")]
        [System.Management.Automation.SwitchParameter]
        $Current,

        [Parameter(ParameterSetName = "all")]
        [System.Management.Automation.SwitchParameter]
        $All
    )

    $scopespecified = $user.IsPresent -or $machine.IsPresent -or $current.IsPresent
    $path = @()
    $userpath = getenvvar "PATH" -user
    if ($user)
    {
        $path += $userpath
    }
    $machinepath = getenvvar "PATH" -machine
    if ($machine -or !$scopespecified)
    {
        $path += $machinepath
    }
    if (!$user.IsPresent -and !$machine.IsPresent)
    {
        $current = $true
    }
    $currentPath = getenvvar "PATH" -current
    if ($current)
    {
        $path = $currentPath
    }

    if ($all)
    {
        $h = @{
            user    = $userpath
            machine = $machinepath
            process = $currentPath
        }
        return @(
            "`r`n USER",
            " -----------",
            $h.user,
            "`r`n MACHINE",
            " -----------",
            $h.machine,
            "`r`n PROCESS",
            " -----------",
            $h.process
        )
    }

    return $path
}
