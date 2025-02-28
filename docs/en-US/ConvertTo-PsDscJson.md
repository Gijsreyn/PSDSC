---
document type: cmdlet
external help file: PSDSC-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDSC
ms.date: 02/28/2025
PlatyPS schema version: 2024-05-01
title: ConvertTo-PsDscJson
---

# ConvertTo-PsDscJson

## SYNOPSIS

Convert DSC Configuration (v1/v2) Document to JSON.

## SYNTAX

### Path (Default)

```
ConvertTo-PsDscJson -Path <string> [<CommonParameters>]
```

### Content

```
ConvertTo-PsDscJson -Content <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The function ConvertTo-PsDscJson converts a DSC Configuration Document (v1/v2) to JSON.

## EXAMPLES

### EXAMPLE 1

$path = 'myConfig.ps1'
PS C:\> ConvertTo-PsDscJson -Path $path

## PARAMETERS

### -Content

The content to a valid DSC Configuration Document.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: Content
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Path

The file path to a valid DSC Configuration Document.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: Path
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Input a valid DSC Configuration Document

configuration MyConfiguration {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
    {
        Environment CreatePathEnvironmentVariable
        {
            Name = 'TestPathEnvironmentVariable'
            Value = 'TestValue'
            Ensure = 'Present'
            Path = $true
            Target = @('Process')
        }
    }
}

{{ Fill in the Description }}

## OUTPUTS

### Returns a JSON string

{
    "$schema": "https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json",
    "resources": {
        "name": "MyConfiguration node",
        "type": "Microsoft.DSC/PowerShell",
        "properties": {
        "resources": [
            {
            "name": "CreatePathEnvironmentVariable",
            "type": "PSDscResources/Environment",
            "properties": {
                "Value": "TestValue",
                "Path": true,
                "Name": "TestPathEnvironmentVariable",
                "Ensure": "Present",
                "Target": [
                            "Process"
                        ]
                    }
                }
            ]
        }
    }
}

{{ Fill in the Description }}

### System.String

{{ Fill in the Description }}

## NOTES

For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.


## RELATED LINKS

{{ Fill in the related links here }}
