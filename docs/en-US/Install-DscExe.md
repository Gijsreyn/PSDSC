---
document type: cmdlet
external help file: PSDSC-Help.xml
HelpUri: ''
Locale: en-NL
Module Name: PSDSC
ms.date: 05/23/2025
PlatyPS schema version: 2024-05-01
title: Install-DscExe
---

# Install-DscExe

## SYNOPSIS

Install DSC executable.

## SYNTAX

### __AllParameterSets

```
Install-DscExe [[-Version] <string>] [-Force] [-IncludePrerelease] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The function Install-DscExe installs Desired State Configuration version 3 executable.

## EXAMPLES

### EXAMPLE 1

Install-DscExe

Install the latest version of DSC

### EXAMPLE 2

Install-DscExe -Force

Install DSC and forces the installed if there is already a version installed.

## PARAMETERS

### -Force

This switch will force DSC to be installed, even if another installation is already in place.

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

### -IncludePrerelease

This switch will allow latest pre-release version of DSC.

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

### -Version

The version of DSC to install.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
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

### System.Boolean

{{ Fill in the Description }}

## NOTES

For more details, go to module repository at: <https://github.com/Gijsreyn/PSDSC>.

## RELATED LINKS

{{ Fill in the related links here }}
