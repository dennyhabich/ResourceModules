# Healthcare API Workspace FHIR Services `[Microsoft.HealthcareApis/workspaces/fhirservices]`

This module deploys a Healthcare API Workspace FHIR Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.HealthcareApis/workspaces/fhirservices` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/workspaces) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the FHIR service. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent health data services workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessPolicyObjectIds`](#parameter-accesspolicyobjectids) | array | List of Azure AD object IDs (User or Apps) that is allowed access to the FHIR service. |
| [`acrLoginServers`](#parameter-acrloginservers) | array | The list of the Azure container registry login servers. |
| [`acrOciArtifacts`](#parameter-acrociartifacts) | array | The list of Open Container Initiative (OCI) artifacts. |
| [`authenticationAudience`](#parameter-authenticationaudience) | string | The audience url for the service. |
| [`authenticationAuthority`](#parameter-authenticationauthority) | string | The authority url for the service. |
| [`corsAllowCredentials`](#parameter-corsallowcredentials) | bool | Use this setting to indicate that cookies should be included in CORS requests. |
| [`corsHeaders`](#parameter-corsheaders) | array | Specify HTTP headers which can be used during the request. Use "*" for any header. |
| [`corsMaxAge`](#parameter-corsmaxage) | int | Specify how long a result from a request can be cached in seconds. Example: 600 means 10 minutes. |
| [`corsMethods`](#parameter-corsmethods) | array | Specify the allowed HTTP methods. |
| [`corsOrigins`](#parameter-corsorigins) | array | Specify URLs of origin sites that can access this API, or use "*" to allow access from any site. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| [`exportStorageAccountName`](#parameter-exportstorageaccountname) | string | The name of the default export storage account. |
| [`importEnabled`](#parameter-importenabled) | bool | If the import operation is enabled. |
| [`importStorageAccountName`](#parameter-importstorageaccountname) | string | The name of the default integration storage account. |
| [`initialImportMode`](#parameter-initialimportmode) | bool | If the FHIR service is in InitialImportMode. |
| [`kind`](#parameter-kind) | string | The kind of the service. Defaults to R4. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Control permission for data plane traffic coming from public networks while private endpoint is enabled. |
| [`resourceVersionOverrides`](#parameter-resourceversionoverrides) | object | A list of FHIR Resources and their version policy overrides. |
| [`resourceVersionPolicy`](#parameter-resourceversionpolicy) | string | The default value for tracking history across all resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`smartProxyEnabled`](#parameter-smartproxyenabled) | bool | If the SMART on FHIR proxy is enabled. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |

### Parameter: `accessPolicyObjectIds`

List of Azure AD object IDs (User or Apps) that is allowed access to the FHIR service.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `acrLoginServers`

The list of the Azure container registry login servers.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `acrOciArtifacts`

The list of Open Container Initiative (OCI) artifacts.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `authenticationAudience`

The audience url for the service.
- Required: No
- Type: string
- Default: `[format('https://{0}-{1}.fhir.azurehealthcareapis.com', parameters('workspaceName'), parameters('name'))]`

### Parameter: `authenticationAuthority`

The authority url for the service.
- Required: No
- Type: string
- Default: `[uri(environment().authentication.loginEndpoint, subscription().tenantId)]`

### Parameter: `corsAllowCredentials`

Use this setting to indicate that cookies should be included in CORS requests.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `corsHeaders`

Specify HTTP headers which can be used during the request. Use "*" for any header.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `corsMaxAge`

Specify how long a result from a request can be cached in seconds. Example: 600 means 10 minutes.
- Required: No
- Type: int
- Default: `-1`

### Parameter: `corsMethods`

Specify the allowed HTTP methods.
- Required: No
- Type: array
- Default: `[]`
- Allowed: `[DELETE, GET, OPTIONS, PATCH, POST, PUT]`

### Parameter: `corsOrigins`

Specify URLs of origin sites that can access this API, or use "*" to allow access from any site.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticLogCategoriesToEnable`

The name of logs that will be streamed.
- Required: No
- Type: array
- Default: `[AuditLogs]`
- Allowed: `[AuditLogs]`

### Parameter: `diagnosticMetricsToEnable`

The name of metrics that will be streamed.
- Required: No
- Type: array
- Default: `[AllMetrics]`
- Allowed: `[AllMetrics]`

### Parameter: `diagnosticSettingsName`

The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource ID of the diagnostic log analytics workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via the Customer Usage Attribution ID (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `exportStorageAccountName`

The name of the default export storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `importEnabled`

If the import operation is enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `importStorageAccountName`

The name of the default integration storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `initialImportMode`

If the FHIR service is in InitialImportMode.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `kind`

The kind of the service. Defaults to R4.
- Required: No
- Type: string
- Default: `'fhir-R4'`
- Allowed: `[fhir-R4, fhir-Stu3]`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

The name of the FHIR service.
- Required: Yes
- Type: string

### Parameter: `publicNetworkAccess`

Control permission for data plane traffic coming from public networks while private endpoint is enabled.
- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed: `[Disabled, Enabled]`

### Parameter: `resourceVersionOverrides`

A list of FHIR Resources and their version policy overrides.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `resourceVersionPolicy`

The default value for tracking history across all resources.
- Required: No
- Type: string
- Default: `'versioned'`
- Allowed: `[no-version, versioned, versioned-update]`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `smartProxyEnabled`

If the SMART on FHIR proxy is enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `workspaceName`

The name of the parent health data services workspace. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the fhir service. |
| `resourceGroupName` | string | The resource group where the namespace is deployed. |
| `resourceId` | string | The resource ID of the fhir service. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |
| `workspaceName` | string | The name of the fhir workspace. |

## Cross-referenced modules

_None_

## Notes

### Parameter Usage: `acrOciArtifacts`

You can specify multiple Azure Container OCI artifacts using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"acrOciArtifacts": {
    "value": {
        [{
          "digest": "sha256:0a2e01852872580b2c2fea9380ff8d7b637d3928783c55beb3f21a6e58d5d108",
          "imageName": "myimage:v1",
          "loginServer": "myregistry.azurecr.io"
        }]
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
acrOciArtifacts: [
    {
        digest: 'sha256:0a2e01852872580b2c2fea9380ff8d7b637d3928783c55beb3f21a6e58d5d108'
        imageName: 'myimage:v1'
        loginServer: 'myregistry.azurecr.io'
    }
]
```

</details>

<p>
