function Get-PsDscPowerShellResourceSchema
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Resource,

        [Parameter(Mandatory = $true)]
        [string]$CacheFilePath
    )

    try
    {
        $cache = Get-Content -Path $CacheFilePath | ConvertFrom-Json

        $cacheEntry = $cache.ResourceCache | Where-Object { $_.Type -eq $Resource }

        if ($cacheEntry)
        {
            $properties = $cacheEntry.DscResourceInfo.Properties | ForEach-Object {
                [PSCustomObject]@{
                    $_.Name = [PSCustomObject]@{
                        description = $_.Description
                        type        = $_.PropertyType
                    }
                }
            }

            return [PSCustomObject]@{
                '$schema'   = 'https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/bundled/resource/manifest.json'
                type        = $Resource
                description = $cacheEntry.DscResourceInfo.Description
                tags        = @('DSCResource')
                version     = $cacheEntry.DscResourceInfo.Version
                schema      = [PSCustomObject]@{
                    embedded = [PSCustomObject]@{
                        "`$schema" = "https://json-schema.org/draft/2020-12/schema"
                        title      = $cacheEntry.Type.Split("/")[1]
                        type       = 'object'
                        required   = @($cacheEntry.DscResourceInfo.Properties | Where-Object { $_.IsMandatory } | ForEach-Object {
                                $_.Name
                            })
                        properties = $properties
                    }
                }
            }
        }
    }
    catch
    {
        Write-Warning -Message "Failed to read the cache file. The error was: $_"
        return
    }
}
