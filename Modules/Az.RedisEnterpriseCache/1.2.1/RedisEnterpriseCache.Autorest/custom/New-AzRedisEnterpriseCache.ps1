
# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Creates a Redis Enterprise cache.
.Description
Creates or updates an existing (overwrite/recreate, with potential downtime) cache cluster with an associated database.
.Example
PS C:\> New-AzRedisEnterpriseCache -Name "MyCache" -ResourceGroupName "MyGroup" -Location "West US" -Sku "Enterprise_E10"

Location Name    Type                            Zone Database
-------- ----    ----                            ---- --------
West US  MyCache Microsoft.Cache/redisEnterprise      {default}

.Example
PS C:\> New-AzRedisEnterpriseCache -Name "MyCache" -ResourceGroupName "MyGroup" -Location "East US" -Sku "Enterprise_E20" -Capacity 4 -MinimumTlsVersion "1.2" -Zone "1","2","3" -Tag @{"tag1" = "value1"} -Module "{name:RedisBloom, args:`"ERROR_RATE 0.00 INITIAL_SIZE 400`"}","{name:RedisTimeSeries, args:`"RETENTION_POLICY 20`"}","{name:RediSearch}" -ClientProtocol "Plaintext" -EvictionPolicy "NoEviction" -ClusteringPolicy "EnterpriseCluster" -AofPersistenceEnabled -AofPersistenceFrequency "1s"

Location Name    Type                            Zone      Database
-------- ----    ----                            ----      --------
East US  MyCache Microsoft.Cache/redisEnterprise {1, 2, 3} {default}

.Example
PS C:\> New-AzRedisEnterpriseCache -Name "MyCache" -ResourceGroupName "MyGroup" -Location "East US" -Sku "EnterpriseFlash_F300" -NoDatabase

Location Name    Type                            Zone Database
-------- ----    ----                            ---- --------
East US  MyCache Microsoft.Cache/redisEnterprise      {}

.Outputs
Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Models.Api20230301Preview.ICluster
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

MODULE <IModule[]>: Optional set of redis modules to enable in this database - modules can only be added at creation time.
  Name <String>: The name of the module, e.g. 'RedisBloom', 'RediSearch', 'RedisTimeSeries'
  [Arg <String>]: Configuration options for the module, e.g. 'ERROR_RATE 0.00 INITIAL_SIZE 400'.

.Link
https://learn.microsoft.com/powershell/module/az.redisenterprisecache/new-azredisenterprisecache
#>
function New-AzRedisEnterpriseCache {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Models.Api20230301Preview.ICluster])]
    [CmdletBinding(DefaultParameterSetName='CreateClusterWithDatabase', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory)]
        [Alias('Name')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Path')]
        [System.String]
        # The name of the Redis Enterprise cluster.
        ${ClusterName},

        [Parameter(Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Path')]
        [System.String]
        # The name of the resource group.
        # The name is case insensitive.
        ${ResourceGroupName},

        [Parameter(Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [System.String]
        # The geo-location where the resource lives.
        ${Location},

        [Parameter(Mandatory)]
        [Alias('SkuName')]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.SkuName])]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.SkuName]
        # The type of Redis Enterprise cluster to deploy.
        # Allowed values: Enterprise_E10, Enterprise_E20, Enterprise_E50, Enterprise_E100, EnterpriseFlash_F300, EnterpriseFlash_F700, EnterpriseFlash_F1500
        ${Sku},

        [Parameter()]
        [Alias('SkuCapacity')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [System.Int32]
        # The size of the Redis Enterprise cluster - defaults to 2 or 3 depending on SKU.
        # Allowed values are (2, 4, 6, ...) for Enterprise SKUs and (3, 9, 15, ...) for Flash SKUs.
        ${Capacity},

        [Parameter()]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.TlsVersion])]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.TlsVersion]
        # The minimum TLS version for the cluster to support - default is 1.2
        # Allowed values: 1.0, 1.1, 1.2
        ${MinimumTlsVersion},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [System.String[]]
        # The Availability Zones where this cluster will be deployed.
        ${Zone},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Models.Api30.ITrackedResourceTags]))]
        [System.Collections.Hashtable]
        # Cluster resource tags.
        ${Tag},

        [Parameter(ParameterSetName='CreateClusterWithDatabase')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Models.Api20230301Preview.IModule[]]
        # Optional set of redis modules to enable in this database - modules can only be added at create time.
        # To construct, see NOTES section for MODULE properties and create a hash table.
        ${Module},

        [Parameter(ParameterSetName='CreateClusterWithDatabase')]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.Protocol])]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.Protocol]
        # Specifies whether redis clients can connect using TLS-encrypted or plaintext redis protocols - default is Encrypted
        # Allowed values: Encrypted, Plaintext
        ${ClientProtocol},

        [Parameter(ParameterSetName='CreateClusterWithDatabase')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [System.Int32]
        # TCP port of the database endpoint - defaults to an available port
        # Specified at create time.
        ${Port},

        [Parameter(ParameterSetName='CreateClusterWithDatabase')]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.EvictionPolicy])]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.EvictionPolicy]
        # Redis eviction policy - default is VolatileLRU
        # Allowed values: AllKeysLFU, AllKeysLRU, AllKeysRandom, VolatileLRU, VolatileLFU, VolatileTTL, VolatileRandom, NoEviction
        ${EvictionPolicy},

        [Parameter(ParameterSetName='CreateClusterWithDatabase')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [System.String]
        # Name for the group of linked database resources
        ${GroupNickname},

        [Parameter(ParameterSetName='CreateClusterWithDatabase')]
        [AllowEmptyCollection()]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Models.Api20230301Preview.ILinkedDatabase[]]
        # List of database resources to link with this database
        # To construct, see NOTES section for GEOREPLICATIONLINKEDDATABASE properties and create a hash table.
        ${LinkedDatabase},

        [Parameter(ParameterSetName='CreateClusterWithDatabase')]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.ClusteringPolicy])]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.ClusteringPolicy]
        # Clustering policy - default is OSSCluster
        # Specified at create time.
        # Allowed values: EnterpriseCluster, OSSCluster
        ${ClusteringPolicy},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [System.String]
        # Key encryption key Url versioned only. Ex: https://contosovault.vault.azure.net/keys/contosokek/562a4bb76b524a1493a6afe8e536ee78"
        ${CustomerManagedKeyEncryptionKeyUrl},

        [Parameter()]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.ManagedServiceIdentityType])]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.ManagedServiceIdentityType]
        # Type of managed service identity (where both SystemAssigned and UserAssigned types are allowed).
        ${IdentityType},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Models.Api40.IUserAssignedIdentities]))]
        [System.Collections.Hashtable]
        # The set of user assigned identities associated with the resource. The userAssignedIdentities dictionary keys will be ARM resource ids in the form: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}. The dictionary values can be empty objects ({}) in requests.
        ${IdentityUserAssignedIdentity},

        [Parameter()]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.CmkIdentityType])]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.CmkIdentityType]
        # Only userAssignedIdentity is supported in this API version; other types may be supported in the future
        ${KeyEncryptionKeyIdentityType},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [System.String]
        # User assigned identity to use for accessing key encryption key Url. Ex: /subscriptions/<sub uuid>/resourceGroups/<resource group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myId.
        ${KeyEncryptionKeyIdentityUserAssignedIdentityResourceId},

        [Parameter(ParameterSetName='CreateClusterWithDatabase')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # [Preview] Sets whether AOF persistence is enabled.
        # After enabling AOF persistence, you will be unable to disable it.
        # Support for disabling AOF persistence after enabling will be added at a later date.
        ${AofPersistenceEnabled},

        [Parameter(ParameterSetName='CreateClusterWithDatabase')]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.AofFrequency])]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.AofFrequency]
        # [Preview] Sets the frequency at which data is written to disk if AOF persistence is enabled.
        # Allowed values: 1s, always
        ${AofPersistenceFrequency},

        [Parameter(ParameterSetName='CreateClusterWithDatabase')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # [Preview] Sets whether RDB persistence is enabled.
        # After enabling RDB persistence, you will be unable to disable it.
        # Support for disabling RDB persistence after enabling will be added at a later date.
        ${RdbPersistenceEnabled},

        [Parameter(ParameterSetName='CreateClusterWithDatabase')]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.RdbFrequency])]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Support.RdbFrequency]
        # [Preview] Sets the frequency at which a snapshot of the database is created if RDB persistence is enabled.
        # Allowed values: 1h, 6h, 12h
        ${RdbPersistenceFrequency},

        [Parameter(ParameterSetName='CreateClusterOnly', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Advanced - Do not automatically create a default database.
        # Warning: The cache will not be usable until you create a database.
        ${NoDatabase},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String]
        # The ID of the target subscription.
        ${SubscriptionId},

        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command as a job
        ${AsJob},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command asynchronously
        ${NoWait},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.RedisEnterpriseCache.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )

    process {
        $GetPSBoundParameters = @{} + $PSBoundParameters
        $null = $GetPSBoundParameters.Remove("NoDatabase")
        $null = $GetPSBoundParameters.Remove("Module")
        $null = $GetPSBoundParameters.Remove("ClientProtocol")
        $null = $GetPSBoundParameters.Remove("Port")
        $null = $GetPSBoundParameters.Remove("EvictionPolicy")
        $null = $GetPSBoundParameters.Remove("ClusteringPolicy")
        $null = $GetPSBoundParameters.Remove("AofPersistenceEnabled")
        $null = $GetPSBoundParameters.Remove("AofPersistenceFrequency")
        $null = $GetPSBoundParameters.Remove("RdbPersistenceEnabled")
        $null = $GetPSBoundParameters.Remove("RdbPersistenceFrequency")
        $null = $GetPSBoundParameters.Remove("GroupNickname")
        $null = $GetPSBoundParameters.Remove("LinkedDatabase")
        $cluster = Az.RedisEnterpriseCache.internal\New-AzRedisEnterpriseCache @GetPSBoundParameters

        if (('CreateClusterOnly') -contains $PSCmdlet.ParameterSetName)
        {
            $cluster.Database = @{}
            return $cluster
        }

        $null = $PSBoundParameters.Remove("NoDatabase")
        $null = $PSBoundParameters.Remove("Location")
        $null = $PSBoundParameters.Remove("Sku")
        $null = $PSBoundParameters.Remove("Capacity")
        $null = $PSBoundParameters.Remove("MinimumTlsVersion")
        $null = $PSBoundParameters.Remove("Zone")
        $null = $PSBoundParameters.Remove("Tag")
        $null = $PSBoundParameters.Remove("IdentityType")
        $null = $PSBoundParameters.Remove("IdentityUserAssignedIdentity")
        $null = $PSBoundParameters.Remove("CustomerManagedKeyEncryptionKeyUrl")
        $null = $PSBoundParameters.Remove("KeyEncryptionKeyIdentityType")
        $null = $PSBoundParameters.Remove("KeyEncryptionKeyIdentityUserAssignedIdentityResourceId")
        $null = $PSBoundParameters.Add("DatabaseName", "default")
        $database = Az.RedisEnterpriseCache.internal\New-AzRedisEnterpriseCacheDatabase @PSBoundParameters
        $cluster.Database = @{$database.Name = $database}

        return $cluster
    }
}

# SIG # Begin signature block
# MIIoLQYJKoZIhvcNAQcCoIIoHjCCKBoCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCD0rj/Ys59Pqbjp
# n/50XheYjnoR5poqF84TjyzKHegNIKCCDXYwggX0MIID3KADAgECAhMzAAADrzBA
# DkyjTQVBAAAAAAOvMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwOTAwWhcNMjQxMTE0MTkwOTAwWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDOS8s1ra6f0YGtg0OhEaQa/t3Q+q1MEHhWJhqQVuO5amYXQpy8MDPNoJYk+FWA
# hePP5LxwcSge5aen+f5Q6WNPd6EDxGzotvVpNi5ve0H97S3F7C/axDfKxyNh21MG
# 0W8Sb0vxi/vorcLHOL9i+t2D6yvvDzLlEefUCbQV/zGCBjXGlYJcUj6RAzXyeNAN
# xSpKXAGd7Fh+ocGHPPphcD9LQTOJgG7Y7aYztHqBLJiQQ4eAgZNU4ac6+8LnEGAL
# go1ydC5BJEuJQjYKbNTy959HrKSu7LO3Ws0w8jw6pYdC1IMpdTkk2puTgY2PDNzB
# tLM4evG7FYer3WX+8t1UMYNTAgMBAAGjggFzMIIBbzAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQURxxxNPIEPGSO8kqz+bgCAQWGXsEw
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwMDEyKzUwMTgyNjAfBgNVHSMEGDAWgBRIbmTlUAXTgqoXNzci
# tW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3JsMGEG
# CCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3J0
# MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAISxFt/zR2frTFPB45Yd
# mhZpB2nNJoOoi+qlgcTlnO4QwlYN1w/vYwbDy/oFJolD5r6FMJd0RGcgEM8q9TgQ
# 2OC7gQEmhweVJ7yuKJlQBH7P7Pg5RiqgV3cSonJ+OM4kFHbP3gPLiyzssSQdRuPY
# 1mIWoGg9i7Y4ZC8ST7WhpSyc0pns2XsUe1XsIjaUcGu7zd7gg97eCUiLRdVklPmp
# XobH9CEAWakRUGNICYN2AgjhRTC4j3KJfqMkU04R6Toyh4/Toswm1uoDcGr5laYn
# TfcX3u5WnJqJLhuPe8Uj9kGAOcyo0O1mNwDa+LhFEzB6CB32+wfJMumfr6degvLT
# e8x55urQLeTjimBQgS49BSUkhFN7ois3cZyNpnrMca5AZaC7pLI72vuqSsSlLalG
# OcZmPHZGYJqZ0BacN274OZ80Q8B11iNokns9Od348bMb5Z4fihxaBWebl8kWEi2O
# PvQImOAeq3nt7UWJBzJYLAGEpfasaA3ZQgIcEXdD+uwo6ymMzDY6UamFOfYqYWXk
# ntxDGu7ngD2ugKUuccYKJJRiiz+LAUcj90BVcSHRLQop9N8zoALr/1sJuwPrVAtx
# HNEgSW+AKBqIxYWM4Ev32l6agSUAezLMbq5f3d8x9qzT031jMDT+sUAoCw0M5wVt
# CUQcqINPuYjbS1WgJyZIiEkBMIIHejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkq
# hkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
# IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEwOTA5WjB+MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQg
# Q29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
# CgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+laUKq4BjgaBEm6f8MMHt03
# a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc6Whe0t+bU7IKLMOv2akr
# rnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4Ddato88tt8zpcoRb0Rrrg
# OGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+lD3v++MrWhAfTVYoonpy
# 4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nkkDstrjNYxbc+/jLTswM9
# sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6A4aN91/w0FK/jJSHvMAh
# dCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmdX4jiJV3TIUs+UsS1Vz8k
# A/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL5zmhD+kjSbwYuER8ReTB
# w3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zdsGbiwZeBe+3W7UvnSSmn
# Eyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3T8HhhUSJxAlMxdSlQy90
# lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS4NaIjAsCAwEAAaOCAe0w
# ggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRIbmTlUAXTgqoXNzcitW2o
# ynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYD
# VR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBDuRQFTuHqp8cx0SOJNDBa
# BgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2Ny
# bC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3JsMF4GCCsG
# AQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3J0MIGfBgNV
# HSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEFBQcCARYzaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1hcnljcHMuaHRtMEAGCCsG
# AQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkAYwB5AF8AcwB0AGEAdABl
# AG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn8oalmOBUeRou09h0ZyKb
# C5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7v0epo/Np22O/IjWll11l
# hJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0bpdS1HXeUOeLpZMlEPXh6
# I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/KmtYSWMfCWluWpiW5IP0
# wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvyCInWH8MyGOLwxS3OW560
# STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBpmLJZiWhub6e3dMNABQam
# ASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJihsMdYzaXht/a8/jyFqGa
# J+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYbBL7fQccOKO7eZS/sl/ah
# XJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbSoqKfenoi+kiVH6v7RyOA
# 9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sLgOppO6/8MO0ETI7f33Vt
# Y5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtXcVZOSEXAQsmbdlsKgEhr
# /Xmfwb1tbWrJUnMTDXpQzTGCGg0wghoJAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIEBXO/psFHF4H+pwpJ9Qs2tm
# PJRklbAwArz17aCDQZKGMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAkWGgtqmMXDZ5pku13lRaVzQC2oTPwSny4iXyCVN7gcstTAIPNfu2nUpY
# 6AyKmT1QzZGrGF152kXTaRPF9CITMzU5Aap21LjSmvmLBxUuMboCIh6DWisGKqYe
# YBhGstczkz7JOHjyDe4ro1Yo+3L6mjU7l5Ou1SozdDrq/YCogsIH51amApBuPNRS
# qFjZJJVHBuaXss+QWJOrWnEvGFEYtt1gD90Y4JODx4oSvx9q5fNxzRcswcLRs26/
# 8cFk3voFmraPxxi/UzpZJ7awDhB2uhXPVo1xThy2XPiB3cE2mb/7807pvNIMsPQr
# rB3GcqpwFiKkcZyeTUDjxmbfuZAYg6GCF5cwgheTBgorBgEEAYI3AwMBMYIXgzCC
# F38GCSqGSIb3DQEHAqCCF3AwghdsAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFSBgsq
# hkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCARRpXVuH5b8izgVBQ+pOtq4ZCmM1hpdVfGEn55XZz2QwIGZhfd8erJ
# GBMyMDI0MDQyMzEzMTUxMC40MDVaMASAAgH0oIHRpIHOMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046QTAwMC0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Wg
# ghHtMIIHIDCCBQigAwIBAgITMwAAAevgGGy1tu847QABAAAB6zANBgkqhkiG9w0B
# AQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0yMzEyMDYxODQ1
# MzRaFw0yNTAzMDUxODQ1MzRaMIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25z
# MScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046QTAwMC0wNUUwLUQ5NDcxJTAjBgNV
# BAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQDBFWgh2lbgV3eJp01oqiaFBuYbNc7hSKmktvJ15NrB
# /DBboUow8WPOTPxbn7gcmIOGmwJkd+TyFx7KOnzrxnoB3huvv91fZuUugIsKTnAv
# g2BU/nfN7Zzn9Kk1mpuJ27S6xUDH4odFiX51ICcKl6EG4cxKgcDAinihT8xroJWV
# ATL7p8bbfnwsc1pihZmcvIuYGnb1TY9tnpdChWr9EARuCo3TiRGjM2Lp4piT2lD5
# hnd3VaGTepNqyakpkCGV0+cK8Vu/HkIZdvy+z5EL3ojTdFLL5vJ9IAogWf3XAu3d
# 7SpFaaoeix0e1q55AD94ZwDP+izqLadsBR3tzjq2RfrCNL+Tmi/jalRto/J6bh4f
# PhHETnDC78T1yfXUQdGtmJ/utI/ANxi7HV8gAPzid9TYjMPbYqG8y5xz+gI/SFyj
# +aKtHHWmKzEXPttXzAcexJ1EH7wbuiVk3sErPK9MLg1Xb6hM5HIWA0jEAZhKEyd5
# hH2XMibzakbp2s2EJQWasQc4DMaF1EsQ1CzgClDYIYG6rUhudfI7k8L9KKCEufRb
# K5ldRYNAqddr/ySJfuZv3PS3+vtD6X6q1H4UOmjDKdjoW3qs7JRMZmH9fkFkMzb6
# YSzr6eX1LoYm3PrO1Jea43SYzlB3Tz84OvuVSV7NcidVtNqiZeWWpVjfavR+Jj/J
# OQIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFHSeBazWVcxu4qT9O5jT2B+qAerhMB8G
# A1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1UdHwRYMFYwVKBSoFCG
# Tmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUy
# MFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggrBgEFBQcBAQRgMF4w
# XAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2Vy
# dHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3J0MAwG
# A1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQD
# AgeAMA0GCSqGSIb3DQEBCwUAA4ICAQCDdN8voPd8C+VWZP3+W87c/QbdbWK0sOt9
# Z4kEOWng7Kmh+WD2LnPJTJKIEaxniOct9wMgJ8yQywR8WHgDOvbwqdqsLUaM4Nre
# rtI6FI9rhjheaKxNNnBZzHZLDwlkL9vCEDe9Rc0dGSVd5Bg3CWknV3uvVau14F55
# ESTWIBNaQS9Cpo2Opz3cRgAYVfaLFGbArNcRvSWvSUbeI2IDqRxC4xBbRiNQ+1qH
# XDCPn0hGsXfL+ynDZncCfszNrlgZT24XghvTzYMHcXioLVYo/2Hkyow6dI7uULJb
# KxLX8wHhsiwriXIDCnjLVsG0E5bR82QgcseEhxbU2d1RVHcQtkUE7W9zxZqZ6/jP
# maojZgXQO33XjxOHYYVa/BXcIuu8SMzPjjAAbujwTawpazLBv997LRB0ZObNckJY
# yQQpETSflN36jW+z7R/nGyJqRZ3HtZ1lXW1f6zECAeP+9dy6nmcCrVcOqbQHX7Zr
# 8WPcghHJAADlm5ExPh5xi1tNRk+i6F2a9SpTeQnZXP50w+JoTxISQq7vBij2nitA
# sSLaVeMqoPi+NXlTUNZ2NdtbFr6Iir9ZK9ufaz3FxfvDZo365vLOozmQOe/Z+pu4
# vY5zPmtNiVIcQnFy7JZOiZVDI5bIdwQRai2quHKJ6ltUdsi3HjNnieuE72fT4eWh
# xtmnN5HYCDCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZI
# hvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# MjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAy
# MDEwMB4XDTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIyNVowfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoIC
# AQDk4aZM57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXIyjVX9gF/bErg4r25Phdg
# M/9cT8dm95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjoYH1qUoNEt6aORmsHFPPF
# dvWGUNzBRMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1yaa8dq6z2Nr41JmTamDu6
# GnszrYBbfowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v3byNpOORj7I5LFGc6XBp
# Dco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pGve2krnopN6zL64NF50Zu
# yjLVwIYwXE8s4mKyzbnijYjklqwBSru+cakXW2dg3viSkR4dPf0gz3N9QZpGdc3E
# XzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYrbqgSUei/BQOj0XOmTTd0
# lBw0gg/wEPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlMjgK8QmguEOqEUUbi0b1q
# GFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSLW6CmgyFdXzB0kZSU2LlQ
# +QuJYfM2BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AFemzFER1y7435UsSFF5PA
# PBXbGjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIurQIDAQABo4IB3TCCAdkw
# EgYJKwYBBAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIEFgQUKqdS/mTEmr6CkTxG
# NSnPEP8vBO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMFwGA1UdIARV
# MFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEWM2h0dHA6Ly93d3cubWlj
# cm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0bTATBgNVHSUEDDAK
# BggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvX
# zpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
# cGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYI
# KwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDANBgkqhkiG
# 9w0BAQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv6lwUtj5OR2R4sQaTlz0x
# M7U518JxNj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZnOlNN3Zi6th542DYunKmC
# VgADsAW+iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1bSNU5HhTdSRXud2f8449
# xvNo32X2pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4rPf5KYnDvBewVIVCs/wM
# nosZiefwC2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU6ZGyqVvfSaN0DLzskYDS
# PeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDFNLB62FD+CljdQDzHVG2d
# Y3RILLFORy3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/HltEAY5aGZFrDZ+kKNxn
# GSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2tVdUCbFpAUR+fKFhbHP+Crvs
# QWY9af3LwUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKiexcdFYmNcP7ntdAoGokL
# jzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTmdHRbatGePu1+oDEzfbzL
# 6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggNQ
# MIICOAIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEn
# MCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOkEwMDAtMDVFMC1EOTQ3MSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQCA
# Bol1u1wwwYgUtUowMnqYvbul3qCBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6dIswjAiGA8yMDI0MDQyMzEyNDkw
# NloYDzIwMjQwNDI0MTI0OTA2WjB3MD0GCisGAQQBhFkKBAExLzAtMAoCBQDp0izC
# AgEAMAoCAQACAiCOAgH/MAcCAQACAhLpMAoCBQDp035CAgEAMDYGCisGAQQBhFkK
# BAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJ
# KoZIhvcNAQELBQADggEBALwnR++F4evTR8/9iUVFiChCAH5sK+PsG42zTlXA7fnD
# dk+M7uELqLlaJX7RU6PfrxAKkyMCN++/y79mfMJvwiDMYd9VPJ6iAeHPc8wbqUuA
# nam1sufj3B/pY+arL0rGSaGTBQ4Kvl8jTQppUReErW5KRBFcOfELDEwsFLaYTD/K
# W4Afhqy488DKDUUbkOt4adfYXhC1BQnHqQzV+sk2raZj/cg80vuyrkIR29PlcJKV
# doH2xZ84DMA/e2gJJBn3UnPQANyaw4b6ojaAdIMt8671J/Nm1z04dcOX7q6o7HKM
# HEcsC2EOe9A3mxBC30+YiwYN1miUC2E+RKVfickz3mQxggQNMIIECQIBATCBkzB8
# MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
# bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1N
# aWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAevgGGy1tu847QABAAAB
# 6zANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEE
# MC8GCSqGSIb3DQEJBDEiBCCpbNvA1xqOyrp35rG/buWNAx+ujtv1rIDULe7hPnnZ
# oTCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIM63a75faQPhf8SBDTtk2DSU
# gIbdizXsz76h1JdhLCz4MIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENB
# IDIwMTACEzMAAAHr4BhstbbvOO0AAQAAAeswIgQgdp8Jl1s8iM14llKg2SCG18dq
# UIGTHEUl2ZdAhVhNPYMwDQYJKoZIhvcNAQELBQAEggIADucV/1Xq3EIEm+qp4x3i
# Z9ZZO/+w5GyVEaRCFoKnqf4gsdA4ytKiQbBzOqTgaQ1AqYeyuh/4L30Q0xxuVzn8
# qea8yzoRAU+TtM2QQqCRvrO2/8WTrqqcUF7LJgLqkEA9zUFVV/H7seNOC5CIe472
# rOZuIPjDalhEuVT1xatKt07BPNu4dvTy2NI7rCJL20B4udZ0assOQEYDvQ7Jf6FV
# FSr5D4C8jxYK4x8B+0qYQOXzqdlr8dbyile3PNwenqqebPrMEhZ7/4HQvf0xub+u
# uEXKQ8OSOaeMj32t1nv0uTWNnopRm4qMn3kdF6/KHpK0kOQvmEYb8Dw9Tx2efEqF
# 4pTB2OqUeUVJeWWXKJJGa/trkyjgwWiyTDEukRkww9LBxX0YuX0xv39ZXQBiPbGv
# DT5kY5XzAcz0dM8LAOuc93vnaGUFmvcDXAGiy499EnUZGzP43dyUdA+E54oHGs6F
# 08A8sa2h3Bwhcla/EhKkPYJDKSs7ngT11guqFkD/0kFd1T9fv4uOTj84GRhYRC8O
# bPXg4mCZWeXi/ti2DQpAkyFmOtlF08T7fBfVvgJ9cOhvRs1a5mkUbnLhP787cKmx
# U7/WZmcgFkPjXvAFAXSCcY26UQfmQ3NqCFWqRcMGnxnVaL9QeGJqC3QgCf5jwB51
# NeAJkbzKao+OhezE8LsX4Rc=
# SIG # End signature block