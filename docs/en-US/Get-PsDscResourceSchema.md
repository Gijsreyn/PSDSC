---
external help file: PSDSC-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: PSDSC
online version:
schema: 2.0.0
---

# Get-PsDscResourceSchema

## SYNOPSIS
Retrieves the schema for a specified DSC resource.

## SYNTAX

```
Get-PsDscResourceSchema [-ResourceName] <String> [-IncludeProperty] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The function Get-PsDscResourceSchema function retrieves the schema for a specified Desired State Configuration (DSC) resource.
It can optionally include the properties of the resource in the output.

## EXAMPLES

### EXAMPLE 1
```
Get-PsDscResourceSchema -ResourceName "Microsoft.Windows/Registry"
Retrieves the schema for the "Microsoft.Windows/Registry" DSC resource.
```

### EXAMPLE 2
```
Get-PsDscResourceSchema -ResourceName "Microsoft.WinGet.DSC/WinGetPackage" -IncludeProperty
Retrieves the schema for the "Microsoft.WinGet.DSC/WinGetPackage" DSC resource and includes its properties in the output onyl.
```

## PARAMETERS

### -IncludeProperty
A switch parameter that, when specified, includes the properties of the DSC resource in the output.

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

### -ResourceName
The name of the DSC resource for which to retrieve the schema.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

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

## NOTES
For more details, refer to the module documentation.

## RELATED LINKS
