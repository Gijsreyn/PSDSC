function AddToPath
{
    <#
    .SYNOPSIS
        Adds the specified path to PATH env variable

    .DESCRIPTION
        Assumes that paths on PATH are separated by `;`

    .PARAMETER Path
        path to add to the list.

    .PARAMETER Persistent
        save the variable in machine scope.

    .PARAMETER First
        preppend the value instead of appending.

    .PARAMETER User
        save to user scope. use only when needed.

    .EXAMPLE
        PS C:\> $exePath | AddToPath -Persistent:$true

    .NOTES
        Site: https://github.com/qbikez/ps-pathutils/tree/master
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidMultipleTypeAttributes', '', Justification = 'Not my store.')]
    param
    (
        [Parameter(ValueFromPipeline = $true, mandatory = $true)]
        [System.String]
        $Path,

        [Alias("p")]
        [System.Management.Automation.SwitchParameter]
        $Persistent,

        [System.Management.Automation.SwitchParameter]
        $First,

        [System.Management.Automation.SwitchParameter]
        [System.Boolean]
        $User
    )

    process
    {
        if ($null -eq $path)
        {
            throw [System.ArgumentNullException]"path"
        }
        if ($User)
        {
            $p = GetPathEnv -User
        }
        elseif ($persistent)
        {
            $p = GetPathEnv -Machine
        }
        else
        {
            $p = GetPathEnv -Current
        }
        $p = $p | ForEach-Object { $_.trimend("\") }
        $p = @($p)
        $paths = @($path)
        $paths | ForEach-Object {
            $path = $_.trimend("\")
            Write-Verbose "adding $path to PATH"
            if ($first)
            {
                if ($p.length -eq 0 -or $p[0] -ine $path)
                {
                    $p = @($path) + $p
                }
            }
            else
            {
                if ($path -inotin $p)
                {
                    $p += $path
                }
            }
        }

        if ($User)
        {
            Write-Verbose "saving user PATH and adding to current proc"
            [System.Environment]::SetEnvironmentVariable("PATH", [string]::Join(";", $p), [System.EnvironmentVariableTarget]::User);
            #add also to process PATH
            AddToPath $path -persistent:$false -first:$first
        }
        elseif ($persistent)
        {
            Write-Verbose "Saving to global machine PATH variable"
            [System.Environment]::SetEnvironmentVariable("PATH", [string]::Join(";", $p), [System.EnvironmentVariableTarget]::Machine);
            #add also to process PATH
            AddToPath $path -persistent:$false -first:$first
        }
        else
        {
            $env:path = [string]::Join(";", $p);
            [System.Environment]::SetEnvironmentVariable("PATH", $env:path, [System.EnvironmentVariableTarget]::Process);
        }
    }
}
