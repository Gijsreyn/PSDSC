function ReadDscSchemaProperty
{
    <#
    .SYNOPSIS
        Read DSC schema property information.

    .DESCRIPTION
        The function ReadDscSchemaProperty reads the DSC schema property information and builds the resource input required.

    .PARAMETER SchemaObject
        The schema object to pass in.

    .PARAMETER BuildHashTable
        A switch parameter to indicate if the output should be a hashtable.

    .EXAMPLE
        PS C:\> $ctx = (Get-Content "$env:ProgramFiles\DSC\registry.dsc.resource.json" | ConvertFrom-Json)
        PS C:\> $fullExePath = [System.String]::Concat("$(Split-Path -Path $exePath)\", $ctx.schema.command.executable, '.exe')
        PS C:\> $process = GetNetProcessObject -Arguments "$($ctx.schema.command.args)" -ExePath $fullExePath
        PS C:\> $schema = (StartNetProcessObject -Process $process).Output | ConvertFrom-Json
        PS C:\> ReadDscSchemaProperty -SchemaObject $schema

        Returns:
        {"keyPath":"<keyPath>"}
        {"valueName":"<valueName>","_exist":"<_exist>","keyPath":"<keyPath>","valueData":"<valueData>","_metadata":"<_metadata>"}

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$SchemaObject,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]$BuildHashTable
    )

    $exampleCode = @()

    # Add the required keys as example
    $exampleCode += $SchemaObject.required.ForEach({
            if ($BuildHashTable.IsPresent)
            {
                ConvertToHashString -HashTable ([ordered]@{ $_ = "<$($_)>" })
            }
            else
            {
                [ordered]@{ $_ = "<$($_)>" } | ConvertTo-Json -Depth 10 -Compress
            }
        })

    # Go through optional keys as example
    $props = $SchemaObject.properties.PSObject.Properties | Where-Object { $_.MemberType -eq 'NoteProperty' } | Select-Object -ExpandProperty Name

    $hash = [ordered]@{}
    foreach ($prop in $props)
    {
        $hash.Add($prop, "<$prop>")
    }

    if ($BuildHashTable.IsPresent)
    {
        $exampleCode += ConvertToHashString -HashTable $hash
    }
    else
    {
        if ($hash.Count -ne 0)
        {
            $exampleCode += ($hash | ConvertTo-Json -Compress)
        }
        else
        {
            $exampleCode += @()
        }
    }

    return $exampleCode
}
