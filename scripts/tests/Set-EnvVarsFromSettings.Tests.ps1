
# Describe block for testing the JSON content
Describe "JSON Configuration Tests" {
    Context "JSON File Existence" {

        BeforeAll {
            $filePath = "../../testing-config/assets/settings.json"
        }

        It "File should exist" {
            Test-Path -Path $filePath | Should -Be $true
        }
    }
}

Describe "Set-EnvironmentVariablesFromSettings" {
    Context "With Valid Settings File" {
        BeforeAll {
            # Load the script containing your function
            $scriptPath = "../Set-EnvVarsFromSettings.ps1"
            . $scriptPath

            # Define the path to the test JSON file
            $filePath = "../../testing-config/assets/settings.json"
            # Load the JSON content from the file
            $jsonContent = Get-Content -Path $filePath -Raw | ConvertFrom-Json
            #Write-Host $jsonContent
        }

        It "Should have 'semverstrategy'" {
            $jsonContent | ForEach-Object { 
                $_.PSObject.Properties.Name | Should -Contain "semverstrategy" 
            }
        } -Debug

        It "Should have 'semverstrategy_description'" {
            $jsonContent | ForEach-Object { 
                $_.PSObject.Properties.Name | Should -Contain "semverstrategy_description" 
            }
        }

        It "Should not set 'semverstrategy_description' environment variable" {
            Set-EnvironmentVariablesFromSettings -envVarPrefix "PBP_" -settingsFilePath $filePath
            $env:PBP_SEMVERSTRATEGY_DESCRIPTION | Should -BeNullOrEmpty
        }
        

        It "Should set 'validKey' environment variable" {
            Set-EnvironmentVariablesFromSettings -envVarPrefix "PBP_" -settingsFilePath $filePath
            $env:PBP_VALIDKEY | Should -Be "valid-value"
        }

        It "Should set 'key with spaces' environment variable" {
            Set-EnvironmentVariablesFromSettings -envVarPrefix "PBP_" -settingsFilePath $filePath
            $env:PBP_KEYWITHSPACES | Should -Be "value with spaces"
        }

        It "Should set 'key-with-special-characters!' environment variable" {
            Set-EnvironmentVariablesFromSettings -envVarPrefix "PBP_" -settingsFilePath $filePath
            $env:PBP_KEYWITHSPECIALCHARACTERS | Should -Be "value-with-special-characters!"
        }

        It "Should set 'url' environment variable" {
            Set-EnvironmentVariablesFromSettings -envVarPrefix "PBP_" -settingsFilePath $filePath
            $env:PBP_URL | Should -Be "https://example.com"
        }

        It "Should set 'semver' environment variable" {
            Set-EnvironmentVariablesFromSettings -envVarPrefix "PBP_" -settingsFilePath $filePath
            $env:PBP_SEMVER | Should -Be "1.2.3"
        }

        It "Should set 'pathWindows' environment variable" {
            Set-EnvironmentVariablesFromSettings -envVarPrefix "PBP_" -settingsFilePath $filePath
            $env:PBP_PATHWINDOWS | Should -Be "C:\Program Files\MyApp"
        }

        It "Should set 'pathLinux' environment variable" {
            Set-EnvironmentVariablesFromSettings -envVarPrefix "PBP_" -settingsFilePath $filePath
            $env:PBP_PATHLINUX | Should -Be "/opt/myapp"
        }



    }

    Context "With Missing Settings File" {
        BeforeAll {
            # Load the script containing your function
            $scriptPath = "../Set-EnvVarsFromSettings.ps1"
            . $scriptPath
            # Mock the Test-Path cmdlet to return $false
            Mock Test-Path { $false } -ModuleName "Microsoft.PowerShell.Management"
        }

        It "Should exit with error code 1 when settings file is missing" {
            { Set-EnvironmentVariablesFromSettings -settingsFilePath "nonexistent.json" } | Should -Throw
        }
 
    }
}

