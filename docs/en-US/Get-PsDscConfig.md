---
document type: cmdlet
external help file: PSDSC-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDSC
ms.date: 02/28/2025
PlatyPS schema version: 2024-05-01
title: Get-PsDscConfig
---

# Get-PsDscConfig

## SYNOPSIS

Invokes the config get operation for DSC version 3 command-line utility.

## SYNTAX

### __AllParameterSets

```
Get-PsDscConfig [-Inputs] <Object> [[-Parameter] <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The function Get-PsDscConfig invokes the config get operation on Desired State Configuration version 3 executable 'dsc.exe'.

## EXAMPLES

### EXAMPLE 1

$configDoc = @{
  '$schema' = 'https://aka.ms/dsc/schemas/v3/bundled/config/document.json'
  resources = @(
    @{
      name = 'Echo 1'
      type = 'Microsoft.DSC.Debug/Echo'
      properties = @{
        output = 'hello'
      }
    },
    @{
      name = 'Echo 2'
      type = 'Microsoft.DSC.Debug/Echo'
      properties = @{
        output = 'world'
      }
    }
  )
}

PS C:\> Get-PsDscConfig -Inputs $configDoc

This example retrieves the DSC configuration with the specified inputs using a hashtable.

## PARAMETERS

### -Inputs

The input to provide.
Supports a hashtable of key-value pairs, JSON, YAML, or a file path (both JSON and YAML).

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases: []
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

### -Parameter

The parameter to provide.
Supports a hashtable of key-value pairs, JSON, YAML, or a file path (both JSON and YAML).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
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

## NOTES

For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.


## RELATED LINKS

{{ Fill in the related links here }}

