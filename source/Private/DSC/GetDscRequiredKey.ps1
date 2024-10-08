function GetDscRequiredKey
{
    <#
    .SYNOPSIS
        Get the required DSC key(s) from Resource Manifest(s).

    .DESCRIPTION
        The function GetDscRequiredKey gets all the required keys located in 'dsc.exe' installation location.
        It reads all resource manifest to build the object and captures the resource input if possible.

    .PARAMETER Path
        The path to the 'dsc.exe' installation location.

    .PARAMETER BuildHashTable
        A switch parameter to indicate if the output should be a hashtable.

    .EXAMPLE
        PS C:\> $resolvedPath = Split-Path (Get-Command 'dsc').Source
        PS C:\> GetDscRequiredKey -Path $resolvedPath

        Returns ResourceManifest object

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [System.String]
        $Path,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]$BuildHashTable
    )

    if (-not $PSBoundParameters.ContainsKey('Path'))
    {
        $Path = Split-Path (ResolveDscExe) -Parent
    }

    $mFiles = Get-ChildItem -Path $Path -Depth 1 -Filter "*.dsc.resource.json"

    if ($mFiles)
    {
        $p = @{
            ResourceManifest = $mFiles
            BuildHashTable   = $BuildHashTable.IsPresent
        }

        $inputObject = ReadDscRequiredKey @p
    }

    $inputObject
}
