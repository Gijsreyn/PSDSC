function Get-ProcessResult
{
    <#
    .SYNOPSIS
        Get the result of a process.

    .DESCRIPTION
        The function Get-ProcessResult gets the result of a process.

    .PARAMETER Process
        The process to get the result from.

    .EXAMPLE
        PS C:\> Get-ProcessResult -Process (Get-ProcessObject -Argument 'resource get --resource Microsoft.Windows/Registry')

        This example gets the result of the process created by Get-ProcessObject.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [System.Diagnostics.Process]
        $Process
    )

    Write-Verbose -Message "Starting '$($Process.StartInfo.FileName)' with arguments '$($Process.StartInfo.Arguments)'"

    Write-Debug -Message "Process starting..."
    $startTime = Get-Date
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
    $endTime = Get-Date
    $elapsedTime = $endTime - $startTime
    Write-Debug -Message "Process has exited. Elapsed time: $($elapsedTime.TotalSeconds) seconds."

    return [PSCustomObject]@{
        Executable = $Process.StartInfo.FileName
        Arguments  = $Process.StartInfo.Arguments
        ExitCode   = $Process.ExitCode
        Output     = $string
        Error      = $standardError
    }
}
