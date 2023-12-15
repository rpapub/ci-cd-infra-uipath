function Set-EnvironmentVariablesFromSettings {
    param (
        [string]$settingsFilePath = (Join-Path -Path $PSScriptRoot -ChildPath "../pipeline-config/settings.json"),
        [string]$envVarPrefix = "PBP_"
    )

    # Check if the settings file exists
    if (-Not (Test-Path -Path $settingsFilePath)) {
        Write-Host "Settings file not found at $settingsFilePath"
        throw #exit 1 would not be testable
    }

    # Read the settings file
    $settingsContent = Get-Content -Path $settingsFilePath -Raw | ConvertFrom-Json

    # Function to recursively process each object and create flattened key names
    function Get-FlattenedKeys {
        param (
            [Parameter(Mandatory = $true)]
            [PSCustomObject]$ConfigObject,
            [string]$CurrentPath = ""
        )

        $flattenedKeys = @{}
        $baseKeys = @{}

        foreach ($property in $ConfigObject.PSObject.Properties) {
            $key = $property.Name -replace "_description$"
            $baseKeys[$key] = $true
        }

        foreach ($property in $ConfigObject.PSObject.Properties) {
            $key = $property.Name
            $value = $property.Value

            # Construct the full path for the current property
            $fullPath = if ($CurrentPath) { "$CurrentPath" + "_" + "$key" } else { $key }

            # Skip description keys if base key exists
            if ($key -like "*_description" -and $baseKeys.ContainsKey($key -replace "_description$")) {
                continue
            }

            if ($value -is [PSCustomObject]) {
                # Recurse for nested objects
                $nestedKeys = Get-FlattenedKeys -ConfigObject $value -CurrentPath $fullPath
                $flattenedKeys += $nestedKeys
            }
            elseif ($value -is [Array]) {
                # Convert array to comma-separated string
                $flattenedKeys[$fullPath] = ($value -join ',')
            }
            else {
                # Add the key-value pair to the flattened list
                $flattenedKeys[$fullPath] = $value
            }
        }

        return $flattenedKeys
    }

    # Function to set environment variables with prefix
    function Set-EnvironmentVariables {
        param (
            [Parameter(Mandatory = $true)]
            [hashtable]$FlattenedKeys,
            [string]$EnvVarPrefix
        )

        foreach ($key in $FlattenedKeys.Keys) {
            # Construct the environment variable name, convert to uppercase
            $envVarName = ($EnvVarPrefix + $key).ToUpper() -replace '[^a-zA-Z0-9_]', ''

            # Check if the value is a string and transform to 1 or 0 if it's "True" or "False"
            $envVarValue = $FlattenedKeys[$key]

            if ($envVarValue -is [bool]) {
                if ($envVarValue) {
                    $envVarValue = "1"
                }
                else {
                    $envVarValue = "0"
                }
            }

            # Set the environment variable with the specified scope
            [Environment]::SetEnvironmentVariable($envVarName, $envVarValue, [EnvironmentVariableTarget]::Process)
            Write-Host "Set environment variable: $envVarName=$($envVarValue)"
        }
    }

    # Get flattened keys from the config
    $flattenedKeys = Get-FlattenedKeys -ConfigObject $settingsContent

    # Set environment variables with the flattened keys
    Set-EnvironmentVariables -FlattenedKeys $flattenedKeys -EnvVarPrefix $envVarPrefix
}

# Call the function to set environment variables using default values
Set-EnvironmentVariablesFromSettings
