using namespace System.Text.Json.Serialization

class ConfigurationDocument
{
  [JsonPropertyName('$schema')]
  [System.String]
  $schema

  [JsonIgnoreAttribute(Condition = 'WhenWritingNull')]
  [System.Collections.Hashtable[]]
  $parameters

  [JsonIgnoreAttribute(Condition = 'WhenWritingNull')]
  [System.Collections.Hashtable[]]
  $variables

  [ConfigurationResource[]]
  $resources

  [JsonIgnoreAttribute(Condition = 'WhenWritingNull')]
  [System.Collections.Hashtable]$metadata

  ConfigurationDocument()
  {
  }
  ConfigurationDocument([string]$schema, [ConfigurationResource[]]$resources)
  {
    $this.schema = $schema
    $this.resources = $resources
  }

  [string] SerializeToJson()
  {
    $options = [System.Text.Json.JsonSerializerOptions]@{
      WriteIndented = $true
    }

    return [System.Text.Json.JsonSerializer]::Serialize[ConfigurationDocument]($this, $options)
  }

  [string] SerializeToYaml()
  {
    if (TestYamlModule)
    {
      return (ConvertTo-Yaml -InputObject $this -Depth 10)
    }
    else
    {
      throw "YamlDotNet module is not available. Please install the module to use this feature."
    }
  }
}

class ConfigurationResource
{
  [System.String]
  $name

  [System.String]
  $type

  [System.Collections.Hashtable]
  $properties

  ConfigurationResource()
  {
  }
  ConfigurationResource([string]$name, [string]$type)
  {
    $this.name = $name
    $this.type = $type
  }
  ConfigurationResource([string]$name, [string]$type, [hashtable]$properties)
  {
    $this.name = $name
    $this.type = $type
    $this.properties = $properties
  }
}
