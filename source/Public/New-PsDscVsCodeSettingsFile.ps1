function New-PsDscVsCodeSettingsFile
{
    <#
    .SYNOPSIS
        Simple function to add schema definitions to VSCode settings file.

    .DESCRIPTION
        The function New-PsDscVsCodeSettingsFile adds schema definitions to the 'settings.json' file to help author DSC Configuration Documents.

    .PARAMETER Path
        The path to the VSCode settings file. Defaults to $Home\AppData\Roaming\Code\User\settings.json

    .EXAMPLE
        PS C:\> New-PsDscVsCodeSettingsFile

    .EXAMPLE
        PS C:\> New-PsDscVsCodeSettingsFile -Path customsettingsfile.json

    .OUTPUTS
        System.String

    .NOTES
        For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        $Path = "$Home\AppData\Roaming\Code\User\settings.json"
    )

    $schema = "https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/bundled/config/document.vscode.json"
    $settings = @"
{
    "json.schemas": [
        {
            "fileMatch": ["**/*.dsc.config.json"],
            "url": "$schema"
        }
    ],
    "yaml.schemas": {
        "$schema": "**/*.dsc.config.yaml"
    },
    "yaml.completion": true
}
"@

    $params = @{
        Path     = $Path
        Encoding = 'utf8'
        Value    = $settings
    }

    if (-not (Test-Path $Path -ErrorAction SilentlyContinue))
    {
        Write-Verbose -Message ("Creating new file: '$Path' with")
        Write-Verbose -Message $settings

        Set-Content @params
    }
    else
    {
        try
        {
            $current = Get-Content $Path | ConvertFrom-Json -ErrorAction Stop
            $reference = ($current | ConvertTo-Json | ConvertFrom-Json)

            # schema object
            $yamlObject = [PSCustomObject]@{
                $schema = '**/*.dsc.config.yaml'
            }

            $jsonObject = [PSCustomObject]@{
                fileMatch = @('**/*.dsc.config.json')
                url       = $schema
            }

            # add to current
            $current | Add-Member -NotePropertyName 'yaml.schemas' -TypeName NoteProperty -NotePropertyValue $yamlObject -Force
            $current | Add-Member -NotePropertyName 'json.schemas' -TypeName NoteProperty -NotePropertyValue @($jsonObject) -Force

            $settings = $current | ConvertTo-Json -Depth 10

            Write-Verbose -Message "Previous settings file:"
            Write-Verbose -Message ($reference | ConvertTo-Json -Depth 5 | Out-String)

            $params.Value = $settings

            if ($PSCmdlet.ShouldProcess($Path, 'overwrite'))
            {
                Set-Content @params
            }
        }
        catch
        {
            Throw ("'$Path' is not a valid .JSON file. Error: {0}" -f $PSItem.Exception.Message)
        }
    }

    return $settings
}
