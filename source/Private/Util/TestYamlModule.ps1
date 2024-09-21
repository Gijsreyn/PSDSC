function TestYamlModule
{
    <#
    .SYNOPSIS
        Test if ConvertTo-Yaml is installed from Yayaml

    .DESCRIPTION
        Test if ConvertTo-Yaml is installed from Yayaml

    .EXAMPLE
        TestYamlModule

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>

    if (-not (Get-Module -ListAvailable yayaml -ErrorAction SilentlyContinue) -or (Get-Module -ListAvailable powershell-yaml))
    {
        return $false
    }

    return $true
}
