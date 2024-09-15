---
external help file: PSDSC-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: PSDSC
online version:
schema: 2.0.0
---

# Install-DscCLI

## SYNOPSIS
Install DSC CLI (Windows only).

## SYNTAX

```
Install-DscCLI [[-Version] <String>] [-Force] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The function Install-DscCLI installs Desired State Configuration version 3 executablle.

## EXAMPLES

### EXAMPLE 1
```
Install-DscCli
```

Install the latest version of DSC

### EXAMPLE 2
```
Install-DscCli -Version '3.0.0-preview.9' -Force
```

Install preview.9 version of DSC and forces the installation

## PARAMETERS

### -Force
This switch will force DSC to be installed, even if another installation is already in place.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
The version to be installed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.

## RELATED LINKS
