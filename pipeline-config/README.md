# Configuration for Project Basturma Pipelines

The `settings.json` file contains essential configuration settings for the Project Basturma Pipelines. Below is an explanation of each key in the configuration file.

## Environment Variable Name Sanitization

In the Set-EnvironmentVariables function, environment variable names are sanitized to contain only alphanumeric characters (letters and numbers) and underscores (\_).

## Configuration Keys

### General Configuration

- **`targetEnvironments`**:

  - An array of target environments where the pipeline will operate.
  - Typical values include `development`, `testing`, `staging`, and `production`.
  - Default: `["development", "testing", "staging", "production"]`.

- **`semverstrategy`**:

  - Defines the semantic versioning strategy used by the pipeline.
  - Options include `complete`, `core-prerelease`, `core`, `core-build`, `core-prerelease-build`.
  - Default: `"complete"`.

- **`scmProvider`**:

  - Specifies the source code management platform.
  - Initially implemented for `github.com`.
  - Default: `"github.com"`.

- **`ciCdTool`**:
  - The CI/CD tool used in the pipeline.
  - Supported tools: `GitHub Actions`, `Jenkins`, `Azure DevOps`, `GitLab`.
  - Default: `"GitHub Actions"`.

### UiPath.UiPCLI Configuration

- **`uipathUipcli`**:

  - Configuration specific to the UiPath.UiPCLI tool.

  - **`version`**:

    - The version of the UiPath.UiPCLI tool to use.
    - Default: `"23.6.8581.19168"`.

  - **`packageName`**:

    - The name of the UiPath.UiPCLI package.
    - Default: `"UiPath.UiPCLI"`.

  - **`packageUrlTemplate`**:

    - Template URL for downloading the package.
    - Default: `"https://uipath.pkgs.visualstudio.com/Public.Feeds/_packaging/UiPath-Official/nuget/v3/flat2/{packageName}/{version}/{packageName}.{version}.nupkg"`.

  - **`extractPathWindows`** and **`extractPathLinux`**:

    - File paths for extracting the package on Windows and Linux systems, respectively.
    - Defaults: `Windows: "C:\\Program Files\\uipcli"`, `Linux: "/opt/uipcli"`.

  - **`adminCheck`**:

    - Boolean to check for administrative privileges before extraction.
    - Default: `true`.

  - **`forceClean`**:

    - Boolean to clear the extraction directory before extraction.
    - Default: `true`.

  - **`downloadTimeout`**:

    - Timeout in seconds for the download process.
    - Default: `30`.

  - **`verifyIntegrity`**:
    - Boolean to verify the integrity of the downloaded package.
    - Default: `true`.

### Environment Variable Scope

- **`envVarScope`**:
  - Defines the scope for setting environment variables.
  - Options: `'Process'`, `'User'`, `'Machine'`.
  - Default: `'Process'`.

## Usage

The `settings.json` file is used by the CI/CD pipeline to configure various aspects of the build and deployment process. Ensure that this file is updated according to your project requirements and environment specifications.
