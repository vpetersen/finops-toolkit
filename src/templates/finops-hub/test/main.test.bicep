// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

targetScope = 'resourceGroup'

param uniqueName string = 'ftk-hub-localtest1'
param location string = 'westus2'
param runNegativeTests bool = false

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
      keyVault: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink${replace(environment().suffixes.keyvaultDns, 'vault', 'vaultcore')}'
      queue: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.queue.${environment().suffixes.storage}'
      table: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.table.${environment().suffixes.storage}'
      dataExplorer: ''
    }
  }
}

output customerNetworkHubName string = customerNetworkHub.outputs.name

// Test 3 - Creates a customer-managed private network deployment with Azure Data Explorer enabled.
module customerNetworkHubWithDataExplorer '../main.bicep' = {
  name: 'finops-hub-customer-network-adx'
  params: {
    hubName: '${uniqueName}-customer-adx'
    location: location
    enablePublicAccess: false
    privateNetworkMode: 'customer'
    dataExplorerName: '${uniqueName}adx'
    existingVirtualNetworkId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/virtualNetworks/customer-vnet'
    existingPrivateEndpointSubnetId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/virtualNetworks/customer-vnet/subnets/private-endpoints'
    existingScriptSubnetId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/virtualNetworks/customer-vnet/subnets/scripts'
    existingDataExplorerSubnetId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/virtualNetworks/customer-vnet/subnets/data-explorer'
    existingPrivateDnsZoneIds: {
      blob: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.${environment().suffixes.storage}'
      dfs: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.dfs.${environment().suffixes.storage}'
      file: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.${environment().suffixes.storage}'
      keyVault: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink${replace(environment().suffixes.keyvaultDns, 'vault', 'vaultcore')}'
      queue: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.queue.${environment().suffixes.storage}'
      table: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.table.${environment().suffixes.storage}'
      dataExplorer: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.${location}.kusto.windows.net'
    }
  }
}

output customerNetworkHubWithDataExplorerName string = customerNetworkHubWithDataExplorer.outputs.name

// Negative test scaffolding - set runNegativeTests=true to verify fail-fast validation behavior.
module invalidCustomerNetworkMissingAdxInputs '../main.bicep' = if (runNegativeTests) {
  name: 'finops-hub-customer-network-missing-adx'
  params: {
    hubName: '${uniqueName}-invalid-adx'
    location: location
    enablePublicAccess: false
    privateNetworkMode: 'customer'
    dataExplorerName: '${uniqueName}adxinvalid'
    existingVirtualNetworkId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/virtualNetworks/customer-vnet'
    existingPrivateEndpointSubnetId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/virtualNetworks/customer-vnet/subnets/private-endpoints'
    existingScriptSubnetId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/virtualNetworks/customer-vnet/subnets/scripts'
    existingPrivateDnsZoneIds: {
      blob: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.${environment().suffixes.storage}'
      dfs: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.dfs.${environment().suffixes.storage}'
      file: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.${environment().suffixes.storage}'
      keyVault: ''
      queue: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.queue.${environment().suffixes.storage}'
      table: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.table.${environment().suffixes.storage}'
      dataExplorer: ''
    }
  }
}

module invalidCustomerNetworkMissingKeyVaultDns '../main.bicep' = if (runNegativeTests) {
  name: 'finops-hub-customer-network-missing-keyvault-dns'
  params: {
    hubName: '${uniqueName}-invalid-kv'
    location: location
    enablePublicAccess: false
    privateNetworkMode: 'customer'
    remoteHubStorageUri: 'https://example.blob.${environment().suffixes.storage}/'
    remoteHubStorageKey: 'placeholder'
    existingVirtualNetworkId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/virtualNetworks/customer-vnet'
    existingPrivateEndpointSubnetId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/virtualNetworks/customer-vnet/subnets/private-endpoints'
    existingScriptSubnetId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/virtualNetworks/customer-vnet/subnets/scripts'
    existingPrivateDnsZoneIds: {
      blob: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.${environment().suffixes.storage}'
      dfs: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.dfs.${environment().suffixes.storage}'
      file: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.${environment().suffixes.storage}'
      keyVault: ''
      queue: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.queue.${environment().suffixes.storage}'
      table: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/customer-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.table.${environment().suffixes.storage}'
      dataExplorer: ''
    }
  }
}
