using namespace System.Text.Json.Serialization

class Test {
  [JsonPropertyName('$schema')]
  [string]$Schema
  [hashtable]$Parameters
}

[System.Text.Json.JsonSerializer]::Serialize[Test](@{Schema='schema content'; Parameters = @{'param1'='value1'}})
