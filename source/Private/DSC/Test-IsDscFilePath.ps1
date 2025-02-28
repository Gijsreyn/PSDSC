function Test-IsDscFilePath
{
    <#
    .SYNOPSIS
        Tests if the given path is a valid DSC file path.

    .DESCRIPTION
        The function Test-IsDscFilePath tests if the given path is a valid DSC file path. The function returns true if the path is a valid DSC file path, otherwise false.

    .PARAMETER Path
        The path or input to test for.

    .EXAMPLE
        PS C:\> Test-IsDscFilePath -Path 'C:\path\to\file.json'

        This example tests if the given path is a valid DSC file path.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path
    )

    return (Test-Path $Path -ErrorAction SilentlyContinue) -and ([System.IO.Path]::GetExtension($Path) -in @('.json', '.yaml', '.yml'))
}
