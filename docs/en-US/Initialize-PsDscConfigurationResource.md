---
external help file: PSDSC-help.xml
Module Name: PSDSC
online version:
schema: 2.0.0
---

# Initialize-PsDscConfigurationResource

## SYNOPSIS
Initializes a DSC Configuration Resource.

## SYNTAX

```
Initialize-PsDscConfigurationResource [-ResourceName] <String> [-ResourceType] <String>
 [[-ResourceInput] <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Initialize-PsDscConfigurationResource function initializes a Desired State Configuration (DSC) resource with the specified name, type, and optional input parameters.
It creates an instance of the ConfigurationResource class and sets its properties based on the provided parameters.

## EXAMPLES

### EXAMPLE 1
```
Initialize-PsDscConfigurationResource -ResourceName 'Registry keys' -ResourceType 'Microsoft.Windows/Registry' -ResourceInput @{'keyPath' = 'HKCU\1'}
```

Returns:
name          type                       properties
----          ----                       ----------
Registry keys Microsoft.Windows/Registry {\[type, Microsoft.Windows/Registry\]

## PARAMETERS

### -ResourceName
Specifies the name of the DSC resource.
This parameter is mandatory.

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

### -ResourceType
Specifies the type of the DSC resource.
This parameter is mandatory and supports argument completer for DSC configuration.

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

### -ResourceInput
Specifies the input parameters for the DSC resource.
This parameter is optional and allows null values.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### ConfigurationResource
## NOTES
For more details, go to module repository at: https://github.com/Gijsreyn/PSDSC.

## RELATED LINKS
