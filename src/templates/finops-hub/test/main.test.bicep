// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

targetScope = 'resourceGroup'

param uniqueName string = 'ftk-hub-localtest1'
param location string = 'westus2'

// Test 1 - Creates a FinOps hub instance with default settings.
module hub '../main.bicep' = {
  name: 'finops-hub'
  params: {
    hubName: uniqueName
    location: location
  }
}

output hubName string = hub.outputs.name

// Test 2 - Creates a FinOps hub instance with customer-managed private network settings.
module customerNetworkHub '../main.bicep' = {
  name: 'finops-hub-customer-network'
  params: {
    hubName: '${uniqueName}-customer'
    location: location
    enablePublicAccess: false
    privateNetworkMode: 'customer'
    existingVirtualNetworkId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/virtualNetworks/customer-vnet'
    existingPrivateEndpointSubnetId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/virtualNetworks/customer-vnet/subnets/private-endpoints'
    existingScriptSubnetId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/virtualNetworks/customer-vnet/subnets/scripts'
    existingPrivateDnsZoneIds: {
      blob: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.${environment().suffixes.storage}'
      dfs: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.dfs.${environment().suffixes.storage}'
      file: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.${environment().suffixes.storage}'
      queue: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.queue.${environment().suffixes.storage}'
      table: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.table.${environment().suffixes.storage}'
      dataExplorer: ''
    }
  }
}

output customerNetworkHubName string = customerNetworkHub.outputs.name
