function BuildDscConfigDocument
{
    <#
    .SYNOPSIS
        Build DSC configuration document

    .DESCRIPTION
        The function BuildDscConfigDocument builds a Desired State Configuration version 3 document.

    .PARAMETER Path
        The path to a valid Configuration Document.

    .PARAMETER Content
        The content to a valid DSC Configuration Document.

    .EXAMPLE
        PS C:\> $path = 'myConfig.ps1'
        PS C:\> BuildDscConfigDocument -Path $path

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

    # create configuration document resource class (can be re-used)
    $configurationDocument = [PSCustomObject]@{
        name       = $null
        type       = $null
        properties = @{}
    }

    # convert object
    $rs = ConvertToDscObject @PSBoundParameters -ErrorAction SilentlyContinue

    $configurationDocument.name = ($rs | Select-Object -First 1 -ExpandProperty ConfigurationName)
    $configurationDocument.type = ($rs | Select-Object -First 1 -ExpandProperty Type)

    # bag to hold resources
    $resourceProps = [System.Collections.Generic.List[object]]::new()

    foreach ($resource in $rs)
    {
        # props
        $properties = @{}

        # TODO: make the dependsOn key using resourceId() function
        $resource.GetEnumerator() | ForEach-Object { if ($_.Key -notin @('ResourceInstanceName', 'ResourceName', 'ModuleName', 'DependsOn', 'ConfigurationName', 'Type'))
            {
                $properties.Add($_.Key, $_.Value)
            } }

        # build the module
        $inputObject = [PSCustomObject]@{
            name       = $resource.ResourceInstanceName
            type       = ("{0}/{1}" -f $resource.ModuleName, $resource.ResourceName)
            properties = $properties
        }

        # add to bag
        $resourceProps.Add($inputObject)
    }

    # add all the resources
    $configurationDocument.properties = @{
        resources = $resourceProps
    }

    # TODO: get schema information from GitHub
    $configurationDocument = [ordered]@{
        "`$schema" = "https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json"
        resources  = $configurationDocument
    }

    return $configurationDocument
}
