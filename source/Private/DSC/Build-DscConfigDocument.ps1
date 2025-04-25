function Build-DscConfigDocument
{
    <#
    .SYNOPSIS
        Build DSC configuration document

    .DESCRIPTION
        The function Build-DscConfigDocument builds a Desired State Configuration version 3 document.

    .PARAMETER Path
        The path to a valid Configuration Document.

    .PARAMETER Content
        The content to a valid DSC Configuration Document.

    .EXAMPLE
        PS C:\> $path = 'myConfig.ps1'
        PS C:\> Build-DscConfigDocument -Path $path

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Path')]
        [ValidateScript({
                if (-Not ($_ | Test-Path) )
                {
                    throw "File or folder does not exist"
                }
                if (-Not ($_ | Test-Path -PathType Leaf) )
                {
                    throw "The Path argument must be a file. Folder paths are not allowed."
                }
                return $true
            })]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Content')]
        [System.String]
        $Content
    )

    # start by declaring the configuration document
    $configurationDocument = [ordered]@{
        "`$schema" = "https://aka.ms/dsc/schemas/v3/bundled/config/document.json"
        resources  = @()
    }

    # convert all objects to hashtables
    $dscObjects = ConvertTo-DscObject @PSBoundParameters -ErrorAction SilentlyContinue

    if (-not $dscObjects -or $dscObjects.Count -eq 0)
    {
        Write-Warning "ConvertTo-DscObject returned no objects. Conversion may have failed."
    }

    # store all resources in variables
    $resources = [System.Collections.Generic.List[object]]::new()

    foreach ($dscObject in $dscObjects)
    {
        $resource = [PSCustomObject]@{
            name       = $dscObject.ResourceInstanceName
            type       = ("{0}/{1}" -f $dscObject.ModuleName, $dscObject.ResourceName)
            properties = @()
        }

        $properties = [ordered]@{}

        foreach ($dscObjectProperty in $dscObject.GetEnumerator())
        {
            if ($dscObjectProperty.Key -notin @('ResourceInstanceName', 'ResourceName', 'ModuleName', 'DependsOn', 'ConfigurationName', 'Type'))
            {
                $properties.Add($dscObjectProperty.Key, $dscObjectProperty.Value)
            }
        }

        # add properties
        $resource.properties = $properties

        if ($dscObject.ContainsKey('DependsOn') -and $dscObject.DependsOn)
        {
            $dependsOnKeys = $dscObject.DependsOn.Split("]").Replace("[", "")

            $previousGroupHash = $dscObjects | Where-Object { $_.ResourceName -eq $dependsOnKeys[0] -and $_.ResourceInstanceName -eq $dependsOnKeys[1] }
            if ($previousGroupHash)
            {
                $dependsOnString = "[resourceId('$("{0}/{1}" -f $previousGroupHash.ModuleName, $previousGroupHash.ResourceName)','$($previousGroupHash.ResourceInstanceName)')]"

                Write-Verbose -Message "Found '$dependsOnstring' for resource: $($dscObject.ResourceInstanceName)"
                # Add it to the object
                $resource | Add-Member -MemberType NoteProperty -Name 'dependsOn' -Value @($dependsOnString)
            }
        }

        $resources.Add($resource)
    }

    $configurationDocument.resources = $resources

    return $configurationDocument
}
