function Test-YamlModule
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param ()
    if (-not (Get-Command -Name 'ConvertTo-Yaml' -ErrorAction SilentlyContinue))
    {
        return $false
    }

    return $true
}
