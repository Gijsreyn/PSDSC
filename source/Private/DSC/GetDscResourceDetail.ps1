function GetDscResourceDetail
{
    <#
    .SYNOPSIS
        Get the resource detail from *.dsc.resource.json file.

    .DESCRIPTION
        The function GetDscResourceDetail gets the resource details from the *.dsc.resource.json file(s) and returns the type of the resource.

    .PARAMETER Path
        The path that locates 'dsc.exe' file. If not provided, the function will resolve the path to 'dsc.exe'.

    .PARAMETER Exclude
        The hashtable that contains the key-value pair to exclude the JSON content. The key is the property name and the value is the property value.

        For example: @{kind = 'Group'} excludes all resource(s) that have the kind of 'Group'.

    .EXAMPLE
        PS C:\> GetDscResourceDetail

        Returns all resources from the *.dsc.resource.json file(s).

    .EXAMPLE
        PS C:\> GetDscResourceDetail -Exclude @{kind = 'Adapter'}

        Returns all resources from the *.dsc.resource.json file(s) excluding the resources that have the kind of 'Adapter'.

    .OUTPUTS
        System.String

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.

    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[System.String]])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPositionalParameters', '', Justification = 'PowerShell 7+.')]
    param (
        [Parameter(Mandatory = $false)]
        [System.String]
        $Path = (ResolveDscExe),

        [Parameter(Mandatory = $false)]
        [System.Collections.Hashtable]
        [AllowNull()]
        $Exclude
    )

    if (-not (Test-Path $Path -ErrorAction SilentlyContinue))
    {
        Throw "Path does not exist: $Path. Please ensure the path is correct to 'dsc.exe'."
    }

    # Get the current directory 'dsc.exe' sits in
    $current = Split-Path $Path -Parent

    # Get all JSON files that match the pattern *.dsc.resource.json
    $jsonFiles = Get-ChildItem -Path $current -Filter '*.dsc.resource.json'

    # Initialize an array to hold the results
    $results = [System.Collections.Generic.List[System.String]]::new()

    foreach ($file in $jsonFiles)
    {
        try
        {
            # Read the content of the JSON file
            $jsonContent = Get-Content -Path $file.FullName -Raw | ConvertFrom-Json

            if (-not ([string]::IsNullOrEmpty($Exclude)))
            {
                if ($jsonContent.$($Exclude.Keys) -eq $Exclude.Values)
                {
                    # Set to null as we are not adding any excludes
                    $jsonContent = $null
                }
            }

            # Filter the JSON content based on type
            if ($null -ne $jsonContent.type -and $jsonContent.kind -ne 'Adapter')
            {
                $results.Add($jsonContent.type)
            }

            if ($jsonContent.kind -eq 'Adapter' -and $jsonContent.type -eq 'Microsoft.DSC/PowerShell')
            {
                if ($IsLinux -or $IsMacOS)
                {
                    $cacheFilePath = Join-Path $env:HOME ".dsc" "PSAdapterCache.json"
                }
                else
                {
                    $cacheFilePath = Join-Path $env:LocalAppData "dsc" "PSAdapterCache.json"
                }

                if (Test-Path $cacheFilePath)
                {
                    try
                    {
                        $cacheContent = Get-Content -Path $cacheFilePath -Raw | ConvertFrom-Json
                        $cacheContent.ResourceCache.Type | ForEach-Object {
                            $results.Add($_)
                        }
                    }
                    catch
                    {
                        Write-Debug "Failed to read or parse cache file: $cacheFilePath. Exception: $_"
                    }
                }
                else
                {
                    Write-Debug -Message ("'PSAdapterCache.json' file not found at: $cacheFilePath. Please run './powershell.resource.ps1 List' to generate the cache file found at '{0}'." -f (Join-Path $current 'psDscAdapter'))
                }
            }

            if ($jsonContent.kind -eq 'Adapter' -and $jsonContent.type -eq 'Microsoft.Windows/WindowsPowerShell')
            {
                if ($PSVersionTable.PSVersion.Major -le 5)
                {
                    Join-Path $env:LocalAppData "dsc\WindowsPSAdapterCache.json"
                }
                else
                {
                    Join-Path $env:HOME ".dsc" "PSAdapterCache.json"
                }

                if (Test-Path $cacheFilePath)
                {
                    $cacheContent = Get-Content -Path $cacheFilePath -Raw | ConvertFrom-Json
                    $cacheContent.ResourceCache.Type | ForEach-Object {
                        $results.Add($_)
                    }
                }
                else
                {
                    Write-Debug -Message ("'WindowsPSAdapterCache' file not found at: $cacheFilePath. Please run './powershell.resource.ps1 List' to generate the cache file found at '{0}'." -f (Join-Path $current 'psDscAdapter'))
                }
            }
        }
        catch
        {
            Write-Debug "Failed to process file: $($file.FullName). Exception: $_"
        }
    }

    # Return the filtered results
    return $results
}
