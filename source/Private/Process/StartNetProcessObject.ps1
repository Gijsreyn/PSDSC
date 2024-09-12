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

    Write-Debug -Message ("Starting '{0}' with arguments: [{1}]" -f $Process.StartInfo.FileName, $Process.StartInfo.Arguments)
    $Process.Start() | Out-Null

    $output = [System.Collections.Generic.List[string]]::new()

    if ($Process.StartInfo.RedirectStandardOutput)
    {
        while ($null -ne ($line = $Process.StandardOutput.ReadLine()))
        {
            Write-Debug "Adding: $line"
            $output.Add($line)
        }
    }

    if ($Process.StartInfo.RedirectStandardError)
    {
        $standardError = $Process.StandardError.ReadToEnd()
    }

    $Process.WaitForExit()

    $inputObject = New-Object -TypeName PSObject -Property ([Ordered]@{
            Executable = $Process.StartInfo.FileName
            Arguments  = $Process.StartInfo.Arguments
            ExitCode   = $Process.ExitCode
            Output     = $output
            Error      = $standardError
        })

    $inputObject
}
