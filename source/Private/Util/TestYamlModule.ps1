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

    if (-not (Get-Command -Name 'ConvertTo-Yaml' -ErrorAction SilentlyContinue))
    {
        return $false
    }

    return $true
}
