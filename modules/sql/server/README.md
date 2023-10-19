# Azure SQL Servers `[Microsoft.Sql/servers]`

This module deploys an Azure SQL Server.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Sql/servers` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers) |
| `Microsoft.Sql/servers/databases` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/databases) |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/databases/backupShortTermRetentionPolicies) |
| `Microsoft.Sql/servers/elasticPools` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/elasticPools) |
| `Microsoft.Sql/servers/encryptionProtector` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/encryptionProtector) |
| `Microsoft.Sql/servers/firewallRules` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/firewallRules) |
| `Microsoft.Sql/servers/keys` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/keys) |
| `Microsoft.Sql/servers/securityAlertPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/securityAlertPolicies) |
| `Microsoft.Sql/servers/virtualNetworkRules` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/virtualNetworkRules) |
| `Microsoft.Sql/servers/vulnerabilityAssessments` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/vulnerabilityAssessments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/sql.server:1.0.0`.

- [Admin](#example-1-admin)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [Pe](#example-3-pe)
- [Secondary](#example-4-secondary)

### Example 1: _Admin_

<details>

<summary>via Bicep module</summary>

```bicep
module server 'br:bicep/modules/sql.server:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-sqlsadmin'
  params: {
    // Required parameters
    name: 'sqlsadmin'
    // Non-required parameters
    administrators: {
      azureADOnlyAuthentication: true
      login: 'myspn'
      principalType: 'Application'
      sid: '<sid>'
      tenantId: '<tenantId>'
    }
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "sqlsadmin"
    },
    // Non-required parameters
    "administrators": {
      "value": {
        "azureADOnlyAuthentication": true,
        "login": "myspn",
        "principalType": "Application",
        "sid": "<sid>",
        "tenantId": "<tenantId>"
      }
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module server 'br:bicep/modules/sql.server:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-sqlscom'
  params: {
    // Required parameters
    name: 'sqlscom'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    databases: [
      {
        backupLongTermRetentionPolicy: {
          monthlyRetention: 'P6M'
        }
        backupShortTermRetentionPolicy: {
          retentionDays: 14
        }
        capacity: 0
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
        diagnosticEventHubName: '<diagnosticEventHubName>'
        diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
        diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
        elasticPoolId: '<elasticPoolId>'
        encryptionProtectorObj: {
          serverKeyName: '<serverKeyName>'
          serverKeyType: 'AzureKeyVault'
        }
        licenseType: 'LicenseIncluded'
        maxSizeBytes: 34359738368
        name: 'sqlscomdb-001'
        skuName: 'ElasticPool'
        skuTier: 'GeneralPurpose'
      }
    ]
    elasticPools: [
      {
        maintenanceConfigurationId: '<maintenanceConfigurationId>'
        name: 'sqlscom-ep-001'
        skuCapacity: 10
        skuName: 'GP_Gen5'
        skuTier: 'GeneralPurpose'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    firewallRules: [
      {
        endIpAddress: '0.0.0.0'
        name: 'AllowAllWindowsAzureIps'
        startIpAddress: '0.0.0.0'
      }
    ]
    keys: [
      {
        name: '<name>'
        serverKeyType: 'AzureKeyVault'
        uri: '<uri>'
      }
    ]
    location: '<location>'
    lock: 'CanNotDelete'
    primaryUserAssignedIdentityId: '<primaryUserAssignedIdentityId>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSResourceId>'
          ]
        }
        service: 'sqlServer'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    restrictOutboundNetworkAccess: 'Disabled'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    securityAlertPolicies: [
      {
        emailAccountAdmins: true
        name: 'Default'
        state: 'Enabled'
      }
    ]
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
    virtualNetworkRules: [
      {
        ignoreMissingVnetServiceEndpoint: true
        name: 'newVnetRule1'
        virtualNetworkSubnetId: '<virtualNetworkSubnetId>'
      }
    ]
    vulnerabilityAssessmentsObj: {
      emailSubscriptionAdmins: true
      name: 'default'
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      recurringScansIsEnabled: true
      storageAccountResourceId: '<storageAccountResourceId>'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "sqlscom"
    },
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "databases": {
      "value": [
        {
          "backupLongTermRetentionPolicy": {
            "monthlyRetention": "P6M"
          },
          "backupShortTermRetentionPolicy": {
            "retentionDays": 14
          },
          "capacity": 0,
          "collation": "SQL_Latin1_General_CP1_CI_AS",
          "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
          "diagnosticEventHubName": "<diagnosticEventHubName>",
          "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
          "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
          "elasticPoolId": "<elasticPoolId>",
          "encryptionProtectorObj": {
            "serverKeyName": "<serverKeyName>",
            "serverKeyType": "AzureKeyVault"
          },
          "licenseType": "LicenseIncluded",
          "maxSizeBytes": 34359738368,
          "name": "sqlscomdb-001",
          "skuName": "ElasticPool",
          "skuTier": "GeneralPurpose"
        }
      ]
    },
    "elasticPools": {
      "value": [
        {
          "maintenanceConfigurationId": "<maintenanceConfigurationId>",
          "name": "sqlscom-ep-001",
          "skuCapacity": 10,
          "skuName": "GP_Gen5",
          "skuTier": "GeneralPurpose"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "firewallRules": {
      "value": [
        {
          "endIpAddress": "0.0.0.0",
          "name": "AllowAllWindowsAzureIps",
          "startIpAddress": "0.0.0.0"
        }
      ]
    },
    "keys": {
      "value": [
        {
          "name": "<name>",
          "serverKeyType": "AzureKeyVault",
          "uri": "<uri>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "primaryUserAssignedIdentityId": {
      "value": "<primaryUserAssignedIdentityId>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSResourceId>"
            ]
          },
          "service": "sqlServer",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "restrictOutboundNetworkAccess": {
      "value": "Disabled"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "securityAlertPolicies": {
      "value": [
        {
          "emailAccountAdmins": true,
          "name": "Default",
          "state": "Enabled"
        }
      ]
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    },
    "virtualNetworkRules": {
      "value": [
        {
          "ignoreMissingVnetServiceEndpoint": true,
          "name": "newVnetRule1",
          "virtualNetworkSubnetId": "<virtualNetworkSubnetId>"
        }
      ]
    },
    "vulnerabilityAssessmentsObj": {
      "value": {
        "emailSubscriptionAdmins": true,
        "name": "default",
        "recurringScansEmails": [
          "test1@contoso.com",
          "test2@contoso.com"
        ],
        "recurringScansIsEnabled": true,
        "storageAccountResourceId": "<storageAccountResourceId>"
      }
    }
  }
}
```

</details>
<p>

### Example 3: _Pe_

<details>

<summary>via Bicep module</summary>

```bicep
module server 'br:bicep/modules/sql.server:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-sqlspe'
  params: {
    // Required parameters
    name: 'sqlspe'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSResourceId>'
          ]
        }
        service: 'sqlServer'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "sqlspe"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSResourceId>"
            ]
          },
          "service": "sqlServer",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

### Example 4: _Secondary_

<details>

<summary>via Bicep module</summary>

```bicep
module server 'br:bicep/modules/sql.server:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-sqlsec'
  params: {
    // Required parameters
    name: 'sqlsec-sec'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    databases: [
      {
        createMode: 'Secondary'
        maxSizeBytes: 2147483648
        name: '<name>'
        skuName: 'Basic'
        skuTier: 'Basic'
        sourceDatabaseResourceId: '<sourceDatabaseResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "sqlsec-sec"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "databases": {
      "value": [
        {
          "createMode": "Secondary",
          "maxSizeBytes": 2147483648,
          "name": "<name>",
          "skuName": "Basic",
          "skuTier": "Basic",
          "sourceDatabaseResourceId": "<sourceDatabaseResourceId>"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the server. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorLogin`](#parameter-administratorlogin) | string | The administrator username for the server. Required if no `administrators` object for AAD authentication is provided. |
| [`administratorLoginPassword`](#parameter-administratorloginpassword) | securestring | The administrator login password. Required if no `administrators` object for AAD authentication is provided. |
| [`administrators`](#parameter-administrators) | object | The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided. |
| [`primaryUserAssignedIdentityId`](#parameter-primaryuserassignedidentityid) | string | The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databases`](#parameter-databases) | array | The databases to create in the server. |
| [`elasticPools`](#parameter-elasticpools) | array | The Elastic Pools to create in the server. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`encryptionProtectorObj`](#parameter-encryptionprotectorobj) | object | The encryption protection configuration. |
| [`firewallRules`](#parameter-firewallrules) | array | The firewall rules to create in the server. |
| [`keys`](#parameter-keys) | array | The keys to configure. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`minimalTlsVersion`](#parameter-minimaltlsversion) | string | Minimal TLS version allowed. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and neither firewall rules nor virtual network rules are set. |
| [`restrictOutboundNetworkAccess`](#parameter-restrictoutboundnetworkaccess) | string | Whether or not to restrict outbound network access for this server. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`securityAlertPolicies`](#parameter-securityalertpolicies) | array | The security alert policies to create in the server. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |
| [`virtualNetworkRules`](#parameter-virtualnetworkrules) | array | The virtual network rules to create in the server. |
| [`vulnerabilityAssessmentsObj`](#parameter-vulnerabilityassessmentsobj) | object | The vulnerability assessment configuration. |

### Parameter: `administratorLogin`

The administrator username for the server. Required if no `administrators` object for AAD authentication is provided.
- Required: No
- Type: string
- Default: `''`

### Parameter: `administratorLoginPassword`

The administrator login password. Required if no `administrators` object for AAD authentication is provided.
- Required: No
- Type: securestring
- Default: `''`

### Parameter: `administrators`

The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `databases`

The databases to create in the server.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `elasticPools`

The Elastic Pools to create in the server.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `encryptionProtectorObj`

The encryption protection configuration.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `firewallRules`

The firewall rules to create in the server.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `keys`

The keys to configure.
- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `minimalTlsVersion`

Minimal TLS version allowed.
- Required: No
- Type: string
- Default: `'1.2'`
- Allowed: `[1.0, 1.1, 1.2]`

### Parameter: `name`

The name of the server.
- Required: Yes
- Type: string

### Parameter: `primaryUserAssignedIdentityId`

The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty.
- Required: No
- Type: string
- Default: `''`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and neither firewall rules nor virtual network rules are set.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', Disabled, Enabled]`

### Parameter: `restrictOutboundNetworkAccess`

Whether or not to restrict outbound network access for this server.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', Disabled, Enabled]`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `securityAlertPolicies`

The security alert policies to create in the server.
- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `virtualNetworkRules`

The virtual network rules to create in the server.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `vulnerabilityAssessmentsObj`

The vulnerability assessment configuration.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed SQL server. |
| `resourceGroupName` | string | The resource group of the deployed SQL server. |
| `resourceId` | string | The resource ID of the deployed SQL server. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |

## Notes

### Parameter Usage: `administrators`

Configure Azure Active Directory Authentication method for server administrator.
<https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers/administrators?tabs=bicep>

<details>

<summary>Parameter JSON format</summary>

```json
"administrators": {
    "value": {
        "azureADOnlyAuthentication": true,
        "login": "John Doe", // if application can be anything
        "sid": "[[objectId]]", // if application, the object ID
        "principalType" : "User", // options: "User", "Group", "Application"
        "tenantId": "[[tenantId]]"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
administrators: {
    azureADOnlyAuthentication: true
    login: 'John Doe' // if application can be anything
    sid: '[[objectId]]' // if application the object ID
    'principalType' : 'User' // options: 'User' 'Group' 'Application'
    tenantId: '[[tenantId]]'
}
```

</details>
<p>
