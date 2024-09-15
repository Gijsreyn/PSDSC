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

    $cmdData = @{
        'GetDscResourceCommand'    = @{
            'preview.9' = @{
                SubCommand = 'resource get'
            }
        }
        'SetDscResourceCommand'    = @{
            'preview.9' = @{
                SubCommand = 'resource set'
            }
        }
        'TestDscResourceCommand'   = @{
            'preview.9' = @{
                SubCommand = 'resource test'
            }
        }
        'RemoveDscResourceCommand' = @{
            'preview.9' = @{
                SubCommand = 'resource delete'
            }
        }
        'FindDscResourceCommand'   = @{
            'preview.9' = @{
                SubCommand = 'resource list'
            }
        }
    }

    $keyData = $cmdData.$CommandName.$Version

    if (-not $keyData)
    {
        Throw "Command '$CommandName' not implemented."
    }

    Write-Verbose -Message "Selected data for '$CommandName'"
    return ([PSCustomObject]@{
            Name       = $keyData
            SubCommand = ([System.Text.StringBuilder]::new($keyData.SubCommand))
        })
}
