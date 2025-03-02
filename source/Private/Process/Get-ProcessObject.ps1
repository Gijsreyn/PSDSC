function Get-ProcessObject
{
    <#
    .SYNOPSIS
        Create a new process object.

    .DESCRIPTION
        The function Get-ProcessObject creates a new process object.

    .PARAMETER Argument
        The argument to provide to the process.

    .PARAMETER DscExe
        The path to the DSC version 3 executable 'dsc.exe'.

    .EXAMPLE
        PS C:\> Get-ProcessObject -Argument 'resource get --resource Microsoft.Windows/Registry'

        This example creates a new process object with the specified argument.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Diagnostics.Process])]
    param
    (
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [System.String]
        $Argument,

        [Parameter(Mandatory = $false)]
        [System.String]
        $DscExe = (Resolve-DscExe)
    )

    $process = [System.Diagnostics.Process]::new()

    $startParameters = @{
        FileName               = $DscExe
        UseShellExecute        = $false
        RedirectStandardOutput = $true
        RedirectStandardError  = $true
    }

    if (-not [string]::IsNullOrEmpty($Argument))
    {
        $startParameters['Arguments'] = $Argument
    }

    $startInfo = [System.Diagnostics.ProcessStartInfo]$startParameters

    $process.StartInfo = $startInfo

    return $process
}
