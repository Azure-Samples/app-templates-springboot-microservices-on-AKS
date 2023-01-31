@description('Location of the resource')
param location string
param hubVnetName string
param hubVnetAddressPrefix string
param tags object

param azFwSubnetName string = 'AzureFirewallSubnet'
param azFwSubnetCidr string
param bastionSubnetName string = 'AzureBastionSubnet'
param bastionSubnetCidr string
param jumpboxSubnetName string
param jumpboxSubnetCidr string

resource utils_vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: hubVnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        hubVnetAddressPrefix
      ]
    }
    dhcpOptions: {
      dnsServers: []
    }
    subnets: [
      {
        name: azFwSubnetName
        properties: {
          addressPrefix: azFwSubnetCidr
        }
      }
      {
        name: bastionSubnetName
        properties: {
          addressPrefix: bastionSubnetCidr
        }
      }
      {
        name: jumpboxSubnetName
        properties: {
          addressPrefix: jumpboxSubnetCidr
        }
      }
    ]
  }
}
//  Telemetry Deployment
@description('Enable usage and telemetry feedback to Microsoft.')
param enableTelemetry bool = true
var telemetryId = '69ef933a-eff0-450b-8a46-331cf62e160f-springmsaks-${location}'
resource telemetrydeployment 'Microsoft.Resources/deployments@2021-04-01' = if (enableTelemetry) {
  name: telemetryId
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
      contentVersion: '1.0.0.0'
      resources: {}
    }
  }
}
