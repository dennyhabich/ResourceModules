# Relay Namespace Hybrid Connections `[Microsoft.Relay/namespaces/hybridConnections]`

This module deploys a Relay Namespace Hybrid Connection.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Relay/namespaces/hybridConnections` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Relay/2021-11-01/namespaces/hybridConnections) |
| `Microsoft.Relay/namespaces/hybridConnections/authorizationRules` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Relay/2021-11-01/namespaces/hybridConnections/authorizationRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the hybrid connection. |
| [`userMetadata`](#parameter-usermetadata) | string | The user metadata is a placeholder to store user-defined string data for the hybrid connection endpoint. For example, it can be used to store descriptive data, such as a list of teams and their contact information. Also, user-defined configuration settings can be stored. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent Relay Namespace for the Relay Hybrid Connection. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationRules`](#parameter-authorizationrules) | array | Authorization Rules for the Relay Hybrid Connection. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`requiresClientAuthorization`](#parameter-requiresclientauthorization) | bool | A value indicating if this hybrid connection requires client authorization. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

### Parameter: `authorizationRules`

Authorization Rules for the Relay Hybrid Connection.
- Required: No
- Type: array
- Default: `[System.Management.Automation.OrderedHashtable, System.Management.Automation.OrderedHashtable, System.Management.Automation.OrderedHashtable]`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

The name of the hybrid connection.
- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent Relay Namespace for the Relay Hybrid Connection. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `requiresClientAuthorization`

A value indicating if this hybrid connection requires client authorization.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `userMetadata`

The user metadata is a placeholder to store user-defined string data for the hybrid connection endpoint. For example, it can be used to store descriptive data, such as a list of teams and their contact information. Also, user-defined configuration settings can be stored.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed hybrid connection. |
| `resourceGroupName` | string | The resource group of the deployed hybrid connection. |
| `resourceId` | string | The resource ID of the deployed hybrid connection. |

## Cross-referenced modules

_None_
