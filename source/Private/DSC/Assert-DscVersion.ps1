function Assert-DscVersion
{
    <#
    .SYNOPSIS
        Assert that the required DSC version is available on GitHub

    .DESCRIPTION
        The function `Assert-DscVersion` checks if the required DSC version is available on GitHub.
        It uses the `VersionCompleter` class to retrieve all available versions and compares them
        against the specified required version. If the required version is not found, it throws an error.

    .PARAMETER RequiredVersion
        The version of DSC that is required. This should be a string representing the version number.

    .EXAMPLE
        This example checks if the required DSC version '1.0.0' is available:
        ```powershell
        Assert-DscVersion -RequiredVersion '1.0.0'
        ```

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$RequiredVersion
    )

    # Use the VersionCompleter to get all available versions
    $completer = [VersionCompleter]::new()
    $allVersions = $completer.CompleteArgument($null, $null, $null, $null, @{})

    $versionText = $allVersions | Select-Object -ExpandProperty CompletionText

    if ($versionText -notcontains $RequiredVersion)
    {
        throw "The required DSC version '$RequiredVersion' is not available. Available versions are: $($versionText -join ', ')"
    }
}
