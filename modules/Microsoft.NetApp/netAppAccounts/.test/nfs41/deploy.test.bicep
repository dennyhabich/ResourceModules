targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.netapp.netappaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nanaanfs41'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>${serviceShort}001'
    capacityPools: [
      {
        name: '<<namePrefix>>-${serviceShort}-cp-001'
        roleAssignments: [
          {
            principalIds: [
              resourceGroupResources.outputs.managedIdentityPrincipalId
            ]
            roleDefinitionIdOrName: 'Reader'
            principalType: 'ServicePrincipal'
          }
        ]
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: [
          {
            exportPolicyRules: [
              {
                allowedClients: '0.0.0.0/0'
                nfsv3: false
                nfsv41: true
                ruleIndex: 1
                unixReadOnly: false
                unixReadWrite: true
              }
            ]
            name: '<<namePrefix>>-${serviceShort}-vol-001'
            protocolTypes: [
              'NFSv4.1'
            ]
            roleAssignments: [
              {
                principalIds: [
                  resourceGroupResources.outputs.managedIdentityPrincipalId
                ]
                roleDefinitionIdOrName: 'Reader'
                principalType: 'ServicePrincipal'
              }
            ]
            subnetResourceId: resourceGroupResources.outputs.subnetResourceId
            usageThreshold: 107374182400
          }
          {
            exportPolicyRules: [
              {
                allowedClients: '0.0.0.0/0'
                nfsv3: false
                nfsv41: true
                ruleIndex: 1
                unixReadOnly: false
                unixReadWrite: true
              }
            ]
            name: '<<namePrefix>>-${serviceShort}-vol-002'
            protocolTypes: [
              'NFSv4.1'
            ]
            subnetResourceId: resourceGroupResources.outputs.subnetResourceId
            usageThreshold: 107374182400
          }
        ]
      }
      {
        name: '<<namePrefix>>-${serviceShort}-cp-002'
        roleAssignments: [
          {
            principalIds: [
              resourceGroupResources.outputs.managedIdentityPrincipalId
            ]
            roleDefinitionIdOrName: 'Reader'
            principalType: 'ServicePrincipal'
          }
        ]
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: []
      }
    ]
    roleAssignments: [
      {
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
        roleDefinitionIdOrName: 'Reader'
        principalType: 'ServicePrincipal'
      }
    ]
    tags: {
      Contact: 'test.user@testcompany.com'
      CostCenter: '7890'
      Environment: 'Non-Prod'
      PurchaseOrder: '1234'
      Role: 'DeploymentValidation'
      ServiceName: 'DeploymentValidation'
    }
  }
}