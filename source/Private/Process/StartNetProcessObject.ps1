function StartNetProcessObject
{
    <#
    .SYNOPSIS
        Start process using .NET.

    .DESCRIPTION
        The function StartNetProcessObject starts a process using .NET instead of Start-Process cmdlet.

    .PARAMETER Process
        The process object to start.

    .EXAMPLE
        PS C:\> $Process = [System.Diagnostics.Process]::new()
        PS C:\> $ProcStartinfo = [System.Diagnostics.ProcessStartInfo]::new('dsc.exe', '--version')
        PS C:\> $Process.StartInfo = $ProcStartInfo
        PS C:\> StartNetProcessObject -Process $Process

        Runs dsc --version

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [System.Diagnostics.Process]
        $Process
    )

    Write-Verbose -Message "Starting '$($Process.StartInfo.FileName)' with arguments '$($Process.StartInfo.Arguments)'"

    [void]$Process.Start()

    # Create a list to store the output
    $string = [System.Collections.Generic.List[string]]::new()
    if ($Process.StartInfo.RedirectStandardOutput)
    {
        while ($null -ne ($line = $Process.StandardOutput.ReadLine()))
        {
            if (-not [string]::IsNullOrEmpty($line))
            {
                $string.Add($line)
            }
        }
    }

    if ($Process.StartInfo.RedirectStandardError)
    {
        $standardError = $Process.StandardError.ReadToEnd()
    }

    $Process.WaitForExit()

    return [PSCustomObject]@{
        Executable = $Process.StartInfo.FileName
        Arguments  = $Process.StartInfo.Arguments
        ExitCode   = $Process.ExitCode
        Output     = $string
        Error      = $standardError
    }
}
