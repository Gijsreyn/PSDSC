function Resolve-DscExe
{
    <#
    .SYNOPSIS
        Resolve the location of 'dsc.exe'.

    .DESCRIPTION
        The function Resolve-DscExe resolves the location of the Desired State Configuration version 3 executable 'dsc.exe'.

        It first checks if:

        - The script variable $script:dscExePath is set.
        - The common installation paths for Windows, Linux, and macOS.
        - Leverages the Get-Command cmdlet to search for 'dsc.exe' in the PATH.

    .EXAMPLE
        PS C:\> Resolve-DscExe

        This example resolves the location of 'dsc.exe' and returns the full path.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [OutputType([System.String])]
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPositionalParameters', '', Justification = 'PowerShell module is 7+).')]
    Param
    ()

    if ($script:dscExePath)
    {
        if (Test-Path $script:dscExePath)
        {
            Write-Verbose -Message "Returning DSC executable from global variable: $script:dscExePath."
            return $script:dscExePath
        }
    }

    $dscExePath = $null

    if ($IsWindows)
    {
        $commonPath = @("$env:ProgramFiles\dsc\dsc.exe", "$env:LOCALAPPDATA\dsc\dsc.exe")

        foreach ($path in $commonPath)
        {
            if (Test-Path $path)
            {
                Write-Verbose -Message "Found DSC executable in common path: $path."
                $dscExePath = $path
                break
            }
        }

        if (-not $dscExePath)
        {
            $dscExePath = (Get-Command -Name 'dsc.exe' -ErrorAction SilentlyContinue).Source
            if ($dscExePath)
            {
                Write-Verbose -Message "Found DSC executable in PATH: $dscExePath."
            }
        }
    }
    elseif ($IsLinux)
    {
        $dscExePath = Join-Path '/opt/' 'microsoft' 'dsc' 'dsc'
        if (-not (Test-Path $dscExePath))
        {
            $dscExePath = (Get-Command -Name 'dsc' -ErrorAction SilentlyContinue).Source
            if ($dscExePath)
            {
                Write-Verbose -Message "Found DSC executable in PATH: $dscExePath."
            }
        }
        else
        {
            Write-Verbose -Message "Found DSC executable in default installation path: $dscExePath."
        }
    }
    elseif ($IsMacOs)
    {
        $dscExePath = Join-Path '/usr/' 'local' 'microsoft' 'dsc' 'dsc'
        if (-not (Test-Path $dscExePath))
        {
            $dscExePath = (Get-Command -Name 'dsc' -ErrorAction SilentlyContinue).Source
            if ($dscExePath)
            {
                Write-Verbose -Message "Found DSC executable in PATH: $dscExePath."
            }
        }
        else
        {
            Write-Verbose -Message "Found DSC executable in default installation path: $dscExePath."
        }
    }

    if (-not [string]::IsNullOrEmpty($dscExePath))
    {
        return $dscExePath
    }
    else
    {
        Throw "Could not locate 'dsc.exe'. Please make sure it can be found through the PATH or DSC_RESOURCE_PATH environment variable."
    }
}
