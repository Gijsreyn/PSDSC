class ResourceManifest
{
    [System.String] $type
    [System.String] $description
    [System.Version] $version
    [System.Array] $resourceInput

    ResourceManifest ()
    {
    }

    ResourceManifest ([string] $type, [string] $description, [version] $version)
    {
        $this.type = $type
        $this.description = $description
        $this.version = $version
    }
}