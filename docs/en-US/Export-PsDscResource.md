---
document type: cmdlet
external help file: PSDSC-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDSC
ms.date: 02/28/2025
PlatyPS schema version: 2024-05-01
title: Export-PsDscResource
---

# Export-PsDscResource

## SYNOPSIS

Invoke the export operation for DSC version 3 command-line utility.

## SYNTAX

### __AllParameterSets

```
Export-PsDscResource [-Resource] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The function Export-PsDscResource invokes the export operation on Desired State Configuration version 3 executable 'dsc.exe'.

## EXAMPLES

### EXAMPLE 1

Export-PsDscResource -Resource 'Microsoft/OSInfo'

This example exports the 'Microsoft/OSInfo' DSC resource.

## PARAMETERS

### -Resource

The resource (name) to be exported.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases:
- ResourceName
ParameterSets:
- Name: (All)
  Position: 0
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

## OUTPUTS

### System.Management.Automation.PSObject

{{ Fill in the Description }}

## NOTES

For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.


## RELATED LINKS

{{ Fill in the related links here }}

