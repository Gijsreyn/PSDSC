function GetDscCommandIndex
{
    <#
    .SYNOPSIS
        Get command index data.

    .DESCRIPTION
        The function GetDscCommandIndex gets the command index data for commands created.

    .PARAMETER CommandName
        The command name to return data for.

    .PARAMETER IncludeCommand
        Include the sub command as StringBuilder

    .EXAMPLE
        PS C:\> GetDscCommandIndex -CommandName GetDscResourceCommand

        Returns:
        Name                         SubCommand
        ----                         ----------
        {[SubCommand, resource get]}

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $false)]
        [System.String]
        $CommandName
    )

    # TODO: When version information is available, we can get it using Get-Item and use ResolveDscExe
    # $resolveExe = ResolveDscExe
    $versionProc = GetNetProcessObject
    $version = ((StartNetProcessObject -Process $versionProc).Output.Trim() -split "-") | Select-Object -Last 1

    # TODO: can add without version later
    $cmdData = @{
        'GetDscResourceCommand'    = @{
            'preview.10' = @{
                SubCommand = @('resource', 'get')
            }
        }
        'SetDscResourceCommand'    = @{
            'preview.10' = @{
                SubCommand = @('resource', 'set')
            }
        }
        'TestDscResourceCommand'   = @{
            'preview.10' = @{
                SubCommand = @('resource', 'test')
            }
        }
        'RemoveDscResourceCommand' = @{
            'preview.10' = @{
                SubCommand = @('resource', 'delete')
            }
        }
        'FindDscResourceCommand'   = @{
            'preview.10' = @{
                SubCommand = @('resource', 'list')
            }
        }
        'GetDscConfigCommand'      = @{
            'preview.10' = @{
                SubCommand = @('config', 'get')
            }
        }
        'SetDscConfigCommand'      = @{
            'preview.10' = @{
                SubCommand = @('config', 'set')
            }
        }
        'TestDscConfigCommand'     = @{
            'preview.10' = @{
                SubCommand = @('config', 'test')
            }
        }
        'RemoveDscConfigCommand'   = @{
            'preview.10' = @{
                SubCommand = @('config', 'delete')
            }
        }
    }

    $keyData = $cmdData.$CommandName.$Version

    if (-not $keyData)
    {
        Throw "Command '$CommandName' not implemented for version: $version."
    }

    Write-Verbose -Message "Selected data for '$CommandName'"
    return ([PSCustomObject]@{
            Command   = $keyData.SubCommand[0]
            Operation = $keyData.SubCommand[1]
        })
}
