---
document type: cmdlet
external help file: PSDSC-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDSC
ms.date: 03/06/2025
PlatyPS schema version: 2024-05-01
title: Initialize-PsDscResourceInput
---

# Initialize-PsDscResourceInput

## SYNOPSIS

Initializes a hashtable input for a DSC resource.

## SYNTAX

### __AllParameterSets

```
Initialize-PsDscResourceInput [-Resource] <string> [-RequiredOnly] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Initialize-PsDscResourceInput function retrieves a DSC resource manifest and converts it into
a hashtable format that can be used as input for DSC operations.
It provides an easy way to get
a template with all properties or just the required ones.

## EXAMPLES

### EXAMPLE 1

Initialize-PsDscResourceInput -Resource 'Microsoft.Windows/Registry'

Returns a hashtable with all properties for the Registry resource.

### EXAMPLE 2

Initialize-PsDscResourceInput -Resource 'Microsoft.Windows/Registry' -RequiredOnly

Returns a hashtable with only the required properties for the Registry resource.

## PARAMETERS

### -RequiredOnly

When specified, only the required properties are included in the output.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Resource

The name of the DSC resource.

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

### System.Collections.Hashtable

{{ Fill in the Description }}

## NOTES

For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.


## RELATED LINKS

{{ Fill in the related links here }}

