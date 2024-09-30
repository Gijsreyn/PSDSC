---
external help file: PSDSC-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: PSDSC
online version:
schema: 2.0.0
---

# Invoke-PsDscConfig

## SYNOPSIS
Invoke DSC version 3 config using the command-line utility

## SYNTAX

```
Invoke-PsDscConfig [[-ResourceInput] <Object>] [-Operation] <String> [[-Parameter] <Object>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The function Invoke-PsDscConfig invokes Desired State Configuration version 3 configuration documents calling 'dsc.exe'.

## EXAMPLES

### EXAMPLE 1
```
Invoke-PsDscConfig -ResourceInput myconfig.dsc.config.yaml -Parameter myconfig.dsc.config.parameters.yaml
```

### EXAMPLE 2
```
Invoke-PsDscConfig -ResourceInput @{keyPath = 'HKCU\1'} -Operation Set
```

### EXAMPLE 3
```
$script = @'
configuration WinGet {
    Import-DscResource -ModuleName 'Microsoft.WinGet.DSC'
```

node localhost {
        WinGetPackage WinGetPackageExample
        {
            Id = 'Microsoft.PowerShell.Preview'
            Ensure = 'Present'
        }
    }
}
'@
PS C:\\\> Set-Content -Path 'winget.powershell.dsc.config.ps1' -Value $script
PS C:\\\> Invoke-PsDscConfig -ResourceInput 'winget.powershell.dsc.config.ps1' -Operation Set

## PARAMETERS

### -Operation
The operation capability to execute e.g.
'Set'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parameter
Optionally, the parameter input to provide.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
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

### -ResourceInput
The resource input to provide.
Supports:

- JSON (string and path)
- YAML (string and path)
- PowerShell hash table
- PowerShell configuration document script (.ps1)

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
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
