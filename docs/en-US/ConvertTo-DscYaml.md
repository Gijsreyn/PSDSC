---
external help file: PSDSC-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: PSDSC
online version:
schema: 2.0.0
---

# ConvertTo-DscYaml

## SYNOPSIS
Convert DSC Configuration (v1/v2) Document to YAML.

## SYNTAX

```
ConvertTo-DscYaml [[-Path] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The function ConvertTo-DscYaml converts a DSC Configuration Document (v1/v2) to YAML.

## EXAMPLES

### EXAMPLE 1
```
$path = 'myConfig.ps1'
PS C:\> ConvertTo-DscYaml -Path $path
```

## PARAMETERS

### -Path
The file path to a valid DSC Configuration Document.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

### Input a valid DSC Configuration Document

```powershell
configuration MyConfiguration {
     Import-DscResource -ModuleName PSDesiredStateConfiguration
     Node localhost
     {
         Environment CreatePathEnvironmentVariable
         {
             Name = 'TestPathEnvironmentVariable'
             Value = 'TestValue'
             Ensure = 'Present'
             Path = $true
             Target = @('Process')
         }
     }
}
```

## OUTPUTS

### Returns a YAML string

```yaml
$schema: https://raw.githubusercontent.com/PowerShell/DSC/main/schemas/2024/04/config/document.json
resources:
     name: MyConfiguration
     type: Microsoft.DSC/PowerShell
     properties:
         resources:
         - name: CreatePathEnvironmentVariable
         type: PSDscResources/Environment
         properties:
             Value: TestValue
             Path: true
             Name: TestPathEnvironmentVariable
             Ensure: Present
             Target:
             - Process
```

## NOTES

## RELATED LINKS