---
external help file: PSDSC-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: PSDSC
online version:
schema: 2.0.0
---

# Initialize-PsDscConfigDocument

## SYNOPSIS
Initialize a DSC configuration document.

## SYNTAX

```
Initialize-PsDscConfigDocument [-ResourceName] <String> [[-ResourceInput] <Hashtable>]
 [[-ResourceDescription] <String>] [-IsPwsh] [-IsWindowsPowerShell] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The function Initialize-PsDscConfigDocument initializes a DSC configuration document.
It can pick up 'resource' and 'adapter' from PowerShell or Windows PowerShell.

## EXAMPLES

### EXAMPLE 1
```
Initialize-PsDscConfigDocument -ResourceName 'Microsoft.Windows/Registry' -ResourceInput @{'keyPath' = 'HKCU\1'} -ResourceDescription 'Registry'
```

Returns:
{"$schema":"https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json","resources":\[{"name":"Registry","type":"Microsoft.Windows/Registry","properties":"@{keyPath=HKCU\\\\1}"}\]}

### EXAMPLE 2
```
Init-PsDscConfigDocument -ResourceName Microsoft.WinGet.DSC/WinGetPackage -IsPwsh -ResourceInput @{ Id = 'Microsoft.PowerShell.Preview'} -ResourceDescription 'WinGetPackage'
```

Returns:
{"$schema":"https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json","resources":\[{"name":"Using Pwsh","type":"Microsoft.DSC/PowerShell","properties":"@{resources=}"}\]}

## PARAMETERS

### -IsPwsh
Switch to indicate if the resource is using PowerShell.
Adds 'Microsoft.DSC/PowerShell' type.

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

### -IsWindowsPowerShell
Switch to indicate if the resource is using Windows PowerShell.
Adds 'Microsoft.Windows/WindowsPowerShell' type.

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

### -ResourceDescription
The resource description to provide.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceInput
The resource input to provide.
Supports PowerShell hash table.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceName
The resource name to execute.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES
For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.

## RELATED LINKS
