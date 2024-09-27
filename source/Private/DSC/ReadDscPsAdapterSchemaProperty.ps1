function ReadDscPsAdapterSchemaProperty
{
    <#
    .SYNOPSIS
        Reads the schema properties of a DSC PowerShell adapter.

    .DESCRIPTION
        The function ReadDscPsAdapterSchemaProperty processes the properties of a DSC PowerShell adapter and returns them in a specified format. It can return the properties as a JSON string or as a hash table string.

    .PARAMETER Properties
        The properties of the DSC PowerShell adapter to be processed. This parameter is mandatory.

    .PARAMETER BuildHashTable
        A switch parameter that indicates whether to build the output as a hash table string. If not specified, the output will be in JSON format.

    .OUTPUTS
        System.Collections.Generic.List[System.String]
        Returns a list of strings containing the processed properties in the specified format.

    .EXAMPLE
        PS C:\> $properties = @(
            [PSCustomObject]@{ Name = 'Property1'; PropertyType = '[string]'; IsMandatory = $true },
            [PSCustomObject]@{ Name = 'Property2'; PropertyType = '[int]'; IsMandatory = $false }
        )
        PS C:\>  ReadDscPsAdapterSchemaProperty -Properties $properties

        Returns:

        This example processes the given properties and returns them in JSON format.

    .EXAMPLE
        PS C:\> $properties = @(
            [PSCustomObject]@{ Name = 'Property1'; PropertyType = '[string]'; IsMandatory = $true },
            [PSCustomObject]@{ Name = 'Property2'; PropertyType = '[int]'; IsMandatory = $false }
        )
        PS C:\>  ReadDscPsAdapterSchemaProperty -Properties $properties -BuildHashTable

        This example processes the given properties and returns them as a hash table string.

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[System.String]])]
    param (
        [Parameter(Mandatory = $true)]
        [PSObject] $Properties,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]
        $BuildHashTable
    )

    $resourceInput = [System.Collections.Generic.List[System.String]]::new()
    $inputObject = [ordered]@{}
    $mandatory = [ordered]@{}

    foreach ($property in $Properties)
    {
        $typeName = $property.PropertyType.Split(".")[-1].TrimEnd("]").Replace("[", "")
        $inputObject[$property.Name] = "<$typeName>"

        if ($property.IsMandatory -eq $true)
        {
            $mandatory[$property.Name] = "<$typeName>"
        }
    }

    if ($BuildHashTable.IsPresent)
    {
        $resourceInput.Add((ConvertToHashString -HashTable $mandatory))
        $resourceInput.Add((ConvertToHashString -HashTable $inputObject))
    }
    else
    {
        $resourceInput.Add(($mandatory | ConvertTo-Json -Depth 10 -Compress))
        $resourceInput.Add(($inputObject | ConvertTo-Json -Depth 10 -Compress))
    }

    return $resourceInput
}
