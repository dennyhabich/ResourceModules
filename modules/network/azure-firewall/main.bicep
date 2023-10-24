metadata name = 'Azure Firewalls'
metadata description = 'This module deploys an Azure Firewall.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Azure Firewall.')
param name string

@description('Optional. Tier of an Azure Firewall.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param azureSkuTier string = 'Standard'

@description('Conditional. Shared services Virtual Network resource ID. The virtual network ID containing AzureFirewallSubnet. If a Public IP is not provided, then the Public IP that is created as part of this module will be applied with the subnet provided in this variable. Required if `virtualHubId` is empty.')
param vNetId string = ''

@description('Optional. The Public IP resource ID to associate to the AzureFirewallSubnet. If empty, then the Public IP that is created as part of this module will be applied to the AzureFirewallSubnet.')
param publicIPResourceID string = ''

@description('Optional. This is to add any additional Public IP configurations on top of the Public IP with subnet IP configuration.')
param additionalPublicIpConfigurations array = []

@description('Optional. Specifies if a Public IP should be created by default if one is not provided.')
param isCreateDefaultPublicIP bool = true

@description('Optional. Specifies the properties of the Public IP to create and be used by Azure Firewall. If it\'s not provided and publicIPResourceID is empty, a \'-pip\' suffix will be appended to the Firewall\'s name.')
param publicIPAddressObject object = {}

@description('Optional. The Management Public IP resource ID to associate to the AzureFirewallManagementSubnet. If empty, then the Management Public IP that is created as part of this module will be applied to the AzureFirewallManagementSubnet.')
param managementIPResourceID string = ''

@description('Optional. Specifies the properties of the Management Public IP to create and be used by Azure Firewall. If it\'s not provided and managementIPResourceID is empty, a \'-mip\' suffix will be appended to the Firewall\'s name.')
param managementIPAddressObject object = {}

@description('Optional. Collection of application rule collections used by Azure Firewall.')
param applicationRuleCollections array = []

@description('Optional. Collection of network rule collections used by Azure Firewall.')
param networkRuleCollections array = []

@description('Optional. Collection of NAT rule collections used by Azure Firewall.')
param natRuleCollections array = []

@description('Optional. Resource ID of the Firewall Policy that should be attached.')
param firewallPolicyId string = ''

@description('Conditional. IP addresses associated with AzureFirewall. Required if `virtualHubId` is supplied.')
param hubIPAddresses object = {}

@description('Conditional. The virtualHub resource ID to which the firewall belongs. Required if `vNetId` is empty.')
param virtualHubId string = ''

@allowed([
  'Alert'
  'Deny'
  'Off'
])
@description('Optional. The operation mode for Threat Intel.')
param threatIntelMode string = 'Deny'

@description('Optional. Zone numbers e.g. 1,2,3.')
param zones array = [
  '1'
  '2'
  '3'
]

@description('Optional. Diagnostic Storage Account resource identifier.')
param diagnosticStorageAccountId string = ''

@description('Optional. Log Analytics workspace resource identifier.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the Azure Firewall resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'AzureFirewallApplicationRule'
  'AzureFirewallNetworkRule'
  'AzureFirewallDnsProxy'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

var azureSkuName = empty(vNetId) ? 'AZFW_Hub' : 'AZFW_VNet'
var requiresManagementIp = azureSkuTier == 'Basic' ? true : false
var isCreateDefaultManagementIP = empty(managementIPResourceID) && requiresManagementIp

// ----------------------------------------------------------------------------
// Prep ipConfigurations object AzureFirewallSubnet for different uses cases:
// 1. Use existing Public IP
// 2. Use new Public IP created in this module
// 3. Do not use a Public IP if isCreateDefaultPublicIP is false

var additionalPublicIpConfigurationsVar = [for ipConfiguration in additionalPublicIpConfigurations: {
  name: ipConfiguration.name
  properties: {
    publicIPAddress: contains(ipConfiguration, 'publicIPAddressResourceId') ? {
      id: ipConfiguration.publicIPAddressResourceId
    } : null
  }
}]
var subnetVar = {
  subnet: {
    id: '${vNetId}/subnets/AzureFirewallSubnet' // The subnet name must be AzureFirewallSubnet
  }
}
var existingPip = {
  publicIPAddress: {
    id: publicIPResourceID
  }
}
var newPip = {
  publicIPAddress: (empty(publicIPResourceID) && isCreateDefaultPublicIP) ? {
    id: publicIPAddress.outputs.resourceId
  } : null
}
var ipConfigurations = concat([
    {
      name: !empty(publicIPResourceID) ? last(split(publicIPResourceID, '/')) : publicIPAddress.outputs.name
      //Use existing Public IP, new Public IP created in this module, or none if isCreateDefaultPublicIP is false
      properties: union(subnetVar, !empty(publicIPResourceID) ? existingPip : {}, (isCreateDefaultPublicIP ? newPip : {}))
    }
  ], additionalPublicIpConfigurationsVar)

// ----------------------------------------------------------------------------
// Prep managementIPConfiguration object for different uses cases:
// 1. Use existing Management Public IP
// 2. Use new Management Public IP created in this module

var managementSubnetVar = {
  subnet: {
    id: '${vNetId}/subnets/AzureFirewallManagementSubnet' // The subnet name must be AzureFirewallManagementSubnet for a 'Basic' SKU tier firewall
  }
}
var existingMip = {
  publicIPAddress: {
    id: managementIPResourceID
  }
}
var newMip = {
  publicIPAddress: empty(managementIPResourceID) && isCreateDefaultManagementIP ? {
    id: managementIPAddress.outputs.resourceId
  } : null
}
var managementIPConfiguration = {
  name: !empty(managementIPResourceID) ? last(split(managementIPResourceID, '/')) : managementIPAddress.outputs.name
  //Use existing Management Public IP, new Management Public IP created in this module, or none if isCreateDefaultManagementIP is false
  properties: union(managementSubnetVar, !empty(managementIPResourceID) ? existingMip : {}, (isCreateDefaultManagementIP ? newMip : {}))
}

// ----------------------------------------------------------------------------

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs' && item != ''): {
  category: category
  enabled: true
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
  }
] : contains(diagnosticLogCategoriesToEnable, '') ? [] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
}]

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

// create a Public IP address if one is not provided and the flag is true
module publicIPAddress '../../network/public-ip-address/main.bicep' = if (empty(publicIPResourceID) && isCreateDefaultPublicIP && azureSkuName == 'AZFW_VNet') {
  name: '${uniqueString(deployment().name, location)}-Firewall-PIP'
  params: {
    name: contains(publicIPAddressObject, 'name') ? (!(empty(publicIPAddressObject.name)) ? publicIPAddressObject.name : '${name}-pip') : '${name}-pip'
    publicIPPrefixResourceId: contains(publicIPAddressObject, 'publicIPPrefixResourceId') ? (!(empty(publicIPAddressObject.publicIPPrefixResourceId)) ? publicIPAddressObject.publicIPPrefixResourceId : '') : ''
    publicIPAllocationMethod: contains(publicIPAddressObject, 'publicIPAllocationMethod') ? (!(empty(publicIPAddressObject.publicIPAllocationMethod)) ? publicIPAddressObject.publicIPAllocationMethod : 'Static') : 'Static'
    skuName: contains(publicIPAddressObject, 'skuName') ? (!(empty(publicIPAddressObject.skuName)) ? publicIPAddressObject.skuName : 'Standard') : 'Standard'
    skuTier: contains(publicIPAddressObject, 'skuTier') ? (!(empty(publicIPAddressObject.skuTier)) ? publicIPAddressObject.skuTier : 'Regional') : 'Regional'
    roleAssignments: contains(publicIPAddressObject, 'roleAssignments') ? (!empty(publicIPAddressObject.roleAssignments) ? publicIPAddressObject.roleAssignments : []) : []
    diagnosticMetricsToEnable: contains(publicIPAddressObject, 'diagnosticMetricsToEnable') ? (!(empty(publicIPAddressObject.diagnosticMetricsToEnable)) ? publicIPAddressObject.diagnosticMetricsToEnable : [
      'AllMetrics'
    ]) : [
      'AllMetrics'
    ]
    diagnosticLogCategoriesToEnable: contains(publicIPAddressObject, 'diagnosticLogCategoriesToEnable') ? publicIPAddressObject.diagnosticLogCategoriesToEnable : [
      'allLogs'
    ]
    location: location
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticWorkspaceId: diagnosticWorkspaceId
    diagnosticEventHubAuthorizationRuleId: diagnosticEventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticEventHubName
    lock: lock
    tags: tags
    zones: zones
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

// create a Management Public IP address if one is not provided and the flag is true
module managementIPAddress '../../network/public-ip-address/main.bicep' = if (empty(managementIPResourceID) && isCreateDefaultManagementIP && azureSkuName == 'AZFW_VNet') {
  name: '${uniqueString(deployment().name, location)}-Firewall-MIP'
  params: {
    name: contains(managementIPAddressObject, 'name') ? (!(empty(managementIPAddressObject.name)) ? managementIPAddressObject.name : '${name}-mip') : '${name}-mip'
    publicIPPrefixResourceId: contains(managementIPAddressObject, 'managementIPPrefixResourceId') ? (!(empty(managementIPAddressObject.publicIPPrefixResourceId)) ? managementIPAddressObject.publicIPPrefixResourceId : '') : ''
    publicIPAllocationMethod: contains(managementIPAddressObject, 'managementIPAllocationMethod') ? (!(empty(managementIPAddressObject.publicIPAllocationMethod)) ? managementIPAddressObject.publicIPAllocationMethod : 'Static') : 'Static'
    skuName: contains(managementIPAddressObject, 'skuName') ? (!(empty(managementIPAddressObject.skuName)) ? managementIPAddressObject.skuName : 'Standard') : 'Standard'
    skuTier: contains(managementIPAddressObject, 'skuTier') ? (!(empty(managementIPAddressObject.skuTier)) ? managementIPAddressObject.skuTier : 'Regional') : 'Regional'
    roleAssignments: contains(managementIPAddressObject, 'roleAssignments') ? (!empty(managementIPAddressObject.roleAssignments) ? managementIPAddressObject.roleAssignments : []) : []
    diagnosticMetricsToEnable: contains(managementIPAddressObject, 'diagnosticMetricsToEnable') ? (!(empty(managementIPAddressObject.diagnosticMetricsToEnable)) ? managementIPAddressObject.diagnosticMetricsToEnable : [
      'AllMetrics'
    ]) : [
      'AllMetrics'
    ]
    diagnosticLogCategoriesToEnable: contains(managementIPAddressObject, 'diagnosticLogCategoriesToEnable') ? managementIPAddressObject.diagnosticLogCategoriesToEnable : [
      'allLogs'
    ]
    location: location
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticWorkspaceId: diagnosticWorkspaceId
    diagnosticEventHubAuthorizationRuleId: diagnosticEventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticEventHubName
    lock: lock
    tags: tags
    zones: zones
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2023-04-01' = {
  name: name
  location: location
  zones: length(zones) == 0 ? null : zones
  tags: tags
  properties: azureSkuName == 'AZFW_VNet' ? {
    threatIntelMode: threatIntelMode
    firewallPolicy: !empty(firewallPolicyId) ? {
      id: firewallPolicyId
    } : null
    ipConfigurations: ipConfigurations
    managementIpConfiguration: requiresManagementIp ? managementIPConfiguration : null
    sku: {
      name: azureSkuName
      tier: azureSkuTier
    }
    applicationRuleCollections: applicationRuleCollections
    natRuleCollections: natRuleCollections
    networkRuleCollections: networkRuleCollections
  } : {
    firewallPolicy: !empty(firewallPolicyId) ? {
      id: firewallPolicyId
    } : null
    sku: {
      name: azureSkuName
      tier: azureSkuTier
    }
    hubIPAddresses: !empty(hubIPAddresses) ? hubIPAddresses : null
    virtualHub: !empty(virtualHubId) ? {
      id: virtualHubId
    } : null
  }
  dependsOn: [
    publicIPAddress
    managementIPAddress
  ]
}

resource azureFirewall_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: azureFirewall
}

resource azureFirewall_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: azureFirewall
}

resource azureFirewall_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(azureFirewall.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: azureFirewall
}]

@description('The resource ID of the Azure Firewall.')
output resourceId string = azureFirewall.id

@description('The name of the Azure Firewall.')
output name string = azureFirewall.name

@description('The resource group the Azure firewall was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The private IP of the Azure firewall.')
output privateIp string = contains(azureFirewall.properties, 'ipConfigurations') ? azureFirewall.properties.ipConfigurations[0].properties.privateIPAddress : ''

@description('The Public IP configuration object for the Azure Firewall Subnet.')
output ipConfAzureFirewallSubnet object = contains(azureFirewall.properties, 'ipConfigurations') ? azureFirewall.properties.ipConfigurations[0] : {}

@description('List of Application Rule Collections.')
output applicationRuleCollections array = applicationRuleCollections

@description('List of Network Rule Collections.')
output networkRuleCollections array = networkRuleCollections

@description('Collection of NAT rule collections used by Azure Firewall.')
output natRuleCollections array = natRuleCollections

@description('The location the resource was deployed into.')
output location string = azureFirewall.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device' | null)?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
