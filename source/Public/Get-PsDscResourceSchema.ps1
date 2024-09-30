<#
.SYNOPSIS
    Retrieves the schema for a specified DSC resource.

.DESCRIPTION
    The function Get-PsDscResourceSchema function retrieves the schema for a specified Desired State Configuration (DSC) resource.
    It can optionally include the properties of the resource in the output.

.PARAMETER ResourceName
    The name of the DSC resource for which to retrieve the schema.

.PARAMETER IncludeProperty
    A switch parameter that, when specified, includes the properties of the DSC resource in the output.

.EXAMPLE
    PS C:\> Get-PsDscResourceSchema -ResourceName "Microsoft.Windows/Registry"
    Retrieves the schema for the "Microsoft.Windows/Registry" DSC resource.

.EXAMPLE
    PS C:\> Get-PsDscResourceSchema -ResourceName "Microsoft.WinGet.DSC/WinGetPackage" -IncludeProperty
    Retrieves the schema for the "Microsoft.WinGet.DSC/WinGetPackage" DSC resource and includes its properties in the output onyl.

.NOTES
    For more details, refer to the module documentation.
#>
function Get-PsDscResourceSchema
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [Alias('Name')]
        [ArgumentCompleter([DscResourceCompleter])]
        [System.String]
        $ResourceName,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]
        $IncludeProperty
    )

    begin
    {
        Write-Verbose -Message ("Starting: {0}" -f $MyInvocation.MyCommand.Name)
    }

    process
    {
        $process = GetNetProcessObject -Arguments "resource schema --resource $ResourceName"

        $inputObject = StartNetProcessObject -Process $process

        if (-not ([string]::IsNullOrEmpty($inputObject.Output)))
        {
            $out = $inputObject.Output | ConvertFrom-Json

            if ($IncludeProperty)
            {
                $hash = @{}
                $out.properties.PSObject.Members | ForEach-Object {
                    if ($_.MemberType -eq 'NoteProperty ')
                    {
                        $hash[$_.Name] = $null
                    }
                }

                $inputObject = $hash
            }
        }
    }

    end
    {
        Write-Verbose ("Ended: {0}" -f $MyInvocation.MyCommand.Name)
        return $inputObject
    }
}
