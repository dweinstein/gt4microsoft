# gt4microsoft

[Glamorous Toolkit](https://gtoolkit.com) tools for interacting with Microsoft Graph API and Intune.

## Features

### Intune Graph Client

`IntuneGraphClient` provides access to the Microsoft Graph API for Intune mobile app management. Primary use case: retrieving Azure Storage SAS URIs for LOB (Line of Business) app binaries.

**API chain:** `mobileApps` → `contentVersions` → `files` → `azureStorageUri`

**Domain model:**

| Class | Description |
|-------|-------------|
| `IntuneGraphClient` | Graph API client with OAuth2 client_credentials flow |
| `IntuneMobileApp` / `IntuneMobileApps` | Mobile apps (store + LOB) with rich metadata |
| `IntuneContentVersion` / `IntuneContentVersions` | Content versions for LOB apps |
| `IntuneContentFile` / `IntuneContentFiles` | Content files with Azure Blob Storage SAS URIs |

### Intune Data Warehouse Client

`IntuneDataWarehouseClient` provides access to the Intune OData reporting warehouse API for querying device and app management data.

## Installation

```smalltalk
Metacello new
    baseline: 'Gt4Microsoft';
    repository: 'github://dweinstein/gt4microsoft/src';
    load.
```

## Load Lepiter

After installing with Metacello:

```smalltalk
#BaselineOfGt4Microsoft asClass loadLepiter
```

## Configuration

Create `~/.secrets/intune-graph-config.json`:

```json
{
  "tenantId": "your-azure-tenant-id",
  "clientId": "your-app-client-id",
  "clientSecret": "/path/to/client-secret.txt"
}
```

The `clientSecret` value can be either the secret string directly or a file path (starting with `/`) whose contents will be read.

## Quick Start

```smalltalk
config := IntuneGraphClientExamples new clientConfig.
client := IntuneGraphClient new
    tenantId: (config at: #tenantId);
    clientId: (config at: #clientId);
    clientSecret: (config at: #clientSecret).

"List all mobile apps"
client mobileApps.

"Get LOB apps only"
client lobApps.

"Get Azure Storage download URL for a LOB app"
client lobApps items first storageUri.
```

## Azure AD Setup

1. Register an app in **Microsoft Entra ID** > App registrations
2. Save the **Application (client) ID** and **Directory (tenant) ID**
3. Create a **Client secret** under Certificates & secrets
4. Add API permissions: **Microsoft Graph** > Application permissions:
   - `DeviceManagementApps.Read.All`
   - `DeviceManagementManagedDevices.Read.All` (optional)
5. Grant admin consent

## Examples

`IntuneGraphClientExamples` provides both mock data examples (safe to run as tests) and integration examples (marked `<noTest>`) that hit the live API.

```smalltalk
"Run mock examples"
IntuneGraphClientExamples new lobApp.
IntuneGraphClientExamples new storeApp.
IntuneGraphClientExamples new contentFile.
IntuneGraphClientExamples new expiredContentFile.

"Run integration examples (requires config file)"
IntuneGraphClientExamples new mobileApps.
IntuneGraphClientExamples new lobAppsWithStorageUri.
```
