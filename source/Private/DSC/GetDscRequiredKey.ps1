function GetDscRequiredKey
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [System.String]
        $Path
    )

    if (-not $PSBoundParameters.ContainsKey('Path'))
    {
        $Path = Split-Path (ResolveDscExe) -Parent
    }

    $mFiles = Get-ChildItem -Path $Path -Depth 1 -Filter "*.dsc.resource.json"

    if ($mFiles)
    {
        $inputObject = ReadDscRequiredKey -ManifestFile $mFiles
    }

    $inputObject
}
