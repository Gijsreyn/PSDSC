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
Initialize-PsDscConfigDocument [-SchemaVersion] <String> [-Resource] <ConfigurationResource[]> [-AsJson]
 [-AsYaml] [-ProgressAction <ActionPreference>] [<CommonParameters>]
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

### -SchemaVersion
Specifies the schema version to use for the configuration document. Valid values are '2024/04' and '2023/10'.

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

### -Resource
Specifies the configuration resources to include in the configuration document. This parameter is mandatory.

```yaml
Type: ConfigurationResource[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsJson
Specifies that the output should be in JSON format. This parameter is optional.

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

### -AsYaml
Specifies that the output should be in YAML format. This parameter is optional.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES
For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.

## RELATED LINKS
