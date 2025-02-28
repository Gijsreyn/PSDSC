---
document type: cmdlet
external help file: PSDSC-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDSC
ms.date: 02/28/2025
PlatyPS schema version: 2024-05-01
title: Remove-PsDscResource
---

# Remove-PsDscResource

## SYNOPSIS

Invoke the delete operation for DSC version 3 command-line utility.

## SYNTAX

### __AllParameterSets

```
Remove-PsDscResource [-Resource] <string> [-Inputs] <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The function Remove-PsDscResource invokes the delete operation on Desired State Configuration version 3 executable 'dsc.exe'.

## EXAMPLES

### EXAMPLE 1

Remove-PsDscResource -Resource 'Microsoft.Windows/Registry' -Inputs @{ keyPath = 'HKCU\1\2' }

This example removes the 'Microsoft.Windows/Registry' DSC resource with the specified inputs.

### EXAMPLE 2

$params = @{
    Resource = 'Microsoft.Windows/Registry'
    Inputs = 'registry.json'
}
PS C:\> Remove-PsDscResource @params

This example removes the 'Microsoft.Windows/Registry' DSC resource with the inputs provided in the 'registry.json' file.

## PARAMETERS

### -Confirm

{{ Fill Confirm Description }}

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases:
- cf
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
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Resource

The resource (name) to be deleted.

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

### -WhatIf

{{ Fill WhatIf Description }}

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases:
- wi
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

