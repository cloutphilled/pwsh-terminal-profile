
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
Starts the test migration for the replicating server.
.Description
The Start-AzMigrateTestMigration cmdlet initiates the test migration for the replicating server. 
.Link
https://learn.microsoft.com/powershell/module/az.migrate/start-azmigratetestmigration
#>
function Start-AzMigrateTestMigration {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.IJob])]
    [CmdletBinding(DefaultParameterSetName = 'ByIDVMwareCbt', PositionalBinding = $false)]
    param(
        [Parameter(ParameterSetName = 'ByIDVMwareCbt', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the replicating server for which the test migration needs to be initiated. The ID should be retrieved using the Get-AzMigrateServerReplication cmdlet.
        ${TargetObjectID},

        [Parameter(ParameterSetName = 'ByInputObjectVMwareCbt', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.IMigrationItem]
        # Specifies the replicating server for which the test migration needs to be initiated. The server object can be retrieved using the Get-AzMigrateServerReplication cmdlet.
        ${InputObject},

        [Parameter(Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Updates the Virtual Network id within the destination Azure subscription to be used for test migration.
        ${TestNetworkID},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the target version to which the Os has to be upgraded to. The valid values can be selected from SupportedOSVersions retrieved using Get-AzMigrateServerReplication cmdlet.
        ${OsUpgradeVersion},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.IVMwareCbtNicInput[]]
        # Updates the NIC for the Azure VM to be created.
        ${NicToUpdate},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.DefaultInfo(Script = '(Get-AzContext).Subscription.Id')]
        [System.String]
        # Azure Subscription ID.
        ${SubscriptionId},

        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )
    
    process {
        $null = $PSBoundParameters.Remove('TargetObjectID')
        $null = $PSBoundParameters.Remove('OsUpgradeVersion')
        $null = $PSBoundParameters.Remove('TestNetworkID')
        $null = $PSBoundParameters.Remove('NicToUpdate')
        $null = $PSBoundParameters.Remove('ResourceGroupName')
        $null = $PSBoundParameters.Remove('ProjectName')
        $null = $PSBoundParameters.Remove('MachineName')
        $null = $PSBoundParameters.Remove('InputObject')
        $parameterSet = $PSCmdlet.ParameterSetName
            
           
        if ($parameterSet -eq 'ByInputObjectVMwareCbt') {
            $TargetObjectID = $InputObject.Id
        }
        $MachineIdArray = $TargetObjectID.Split("/")
        $ResourceGroupName = $MachineIdArray[4]
        $VaultName = $MachineIdArray[8]
        $FabricName = $MachineIdArray[10]
        $ProtectionContainerName = $MachineIdArray[12]
        $MachineName = $MachineIdArray[14]

        $null = $PSBoundParameters.Add("ResourceGroupName", $ResourceGroupName)
        $null = $PSBoundParameters.Add("ResourceName", $VaultName)
        $null = $PSBoundParameters.Add("FabricName", $FabricName)
        $null = $PSBoundParameters.Add("MigrationItemName", $MachineName)
        $null = $PSBoundParameters.Add("ProtectionContainerName", $ProtectionContainerName)

        $ReplicationMigrationItem = Az.Migrate.internal\Get-AzMigrateReplicationMigrationItem @PSBoundParameters
        $AvSetId = $ReplicationMigrationItem.ProviderSpecificDetail.TargetAvailabilitySetId
        if ($AvSetId)
        {
            Import-module -Name Az.Compute
            Import-module -Name Az.Network
            $AvSetName = $AvSetId.Split("/")[-1];
            $AvSetRg = $AvSetId.Split("/")[-5];            
            $TargetSubscriptionId = $AvSetId.Split("/")[-7];
            $SourceSubscriptionId = (Get-AzContext -ErrorVariable notPresent -ErrorAction SilentlyContinue).Subscription.Id
            Set-AzContext -SubscriptionId $TargetSubscriptionId -ErrorVariable notPresent -ErrorAction SilentlyContinue
            $AvSet = Get-AzAvailabilitySet -ResourceGroupName $AvSetRg -Name $AvSetName -ErrorVariable notPresent -ErrorAction SilentlyContinue
            if (!$AvSet)
            {
                Set-AzContext -SubscriptionId $SourceSubscriptionId -ErrorVariable notPresent -ErrorAction SilentlyContinue
                throw "Availability Set '$($AvSetId)' does not exist."
            }
            if ($AvSet.VirtualMachinesReferences -And ($AvSet.VirtualMachinesReferences.Count -gt 0))
            {
                $VminAvSet = $AvSet.VirtualMachinesReferences[0].Id
                if ($VminAvSet)
                {
                    $VmNameinAvSet = $VminAvSet.Split("/")[-1]
                    $VM = Get-AzVM -ResourceGroupName $AvSetRg -Name $VmNameinAvSet -ErrorVariable notPresent -ErrorAction SilentlyContinue
                    if ($VM)
                    {
                        $NicId = $VM.NetworkProfile.NetworkInterfaces[0].Id
                        $Nic = Get-AzNetworkInterface -resourceid $NicId -ErrorVariable notPresent -ErrorAction SilentlyContinue
                        if($Nic -And ($Nic.IpConfigurations) -And ($Nic.IpConfigurations[0].Subnet) -And ($Nic.IpConfigurations[0].Subnet.Id))
                        {
                            $Subnet = $Nic.IpConfigurations[0].Subnet.Id.Split("/")
                            $VnetID = "/$($Subnet[1])/$($Subnet[2])/$($Subnet[3])/$($Subnet[4])/$($Subnet[5])/$($Subnet[6])/$($Subnet[7])/$($Subnet[8])"
                        }

                        if ($TestNetworkID -ne $VnetID)
                        {
                            Set-AzContext -SubscriptionId $SourceSubscriptionId -ErrorVariable notPresent -ErrorAction SilentlyContinue
                            throw "Virtual Machines in the availability set '$AvSetName' can only be connected to virtual network '$VnetID'. Change the virtual network selected for the test or update the availability set for the machines, and retry the operation."
                        }
                    }
                }
            }
            Set-AzContext -SubscriptionId $SourceSubscriptionId -ErrorVariable notPresent -ErrorAction SilentlyContinue
        }

        if ($ReplicationMigrationItem -and ($ReplicationMigrationItem.ProviderSpecificDetail.InstanceType -eq 'VMwarecbt') -and ($ReplicationMigrationItem.AllowedOperation -contains 'TestMigrate' )) {
            $ProviderSpecificDetailInput = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.VMwareCbtTestMigrateInput]::new()
            $ProviderSpecificDetailInput.InstanceType = 'VMwareCbt'
            $ProviderSpecificDetailInput.NetworkId = $TestNetworkID
            if ($OsUpgradeVersion) {
                $SupportedOSVersions = $ReplicationMigrationItem.ProviderSpecificDetail.SupportedOSVersion
                if ($null -eq $SupportedOSVersions) {
                    throw "There is no supported target OS available. Please check or remove the OsUpgradeVersion input." 
                }
                elseif ($SupportedOSVersions -contains $OsUpgradeVersion) {
                    $ProviderSpecificDetailInput.OsUpgradeVersion = $OsUpgradeVersion
                }
                else {
                    throw "Please choose the appropriate option from SupportedOSVersions retrieved using Get-AzMigrateServerReplication cmdlet"
                }
            }
            $ProviderSpecificDetailInput.VMNic = $NicToUpdate
            $ProviderSpecificDetailInput.RecoveryPointId = $ReplicationMigrationItem.ProviderSpecificDetail.LastRecoveryPointId

            $null = $PSBoundParameters.Add('ProviderSpecificDetail', $ProviderSpecificDetailInput)
            $null = $PSBoundParameters.Add('NoWait', $true)
            $output = Az.Migrate.internal\Test-AzMigrateReplicationMigrationItemMigrate @PSBoundParameters
            $JobName = $output.Target.Split("/")[12].Split("?")[0]
            $null = $PSBoundParameters.Remove('NoWait')
            $null = $PSBoundParameters.Remove('ProviderSpecificDetail')
            $null = $PSBoundParameters.Remove("ResourceGroupName")
            $null = $PSBoundParameters.Remove("ResourceName")
            $null = $PSBoundParameters.Remove("FabricName")
            $null = $PSBoundParameters.Remove("MigrationItemName")
            $null = $PSBoundParameters.Remove("ProtectionContainerName")

            $null = $PSBoundParameters.Add('JobName', $JobName)
            $null = $PSBoundParameters.Add('ResourceName', $VaultName)
            $null = $PSBoundParameters.Add('ResourceGroupName', $ResourceGroupName)

            return Az.Migrate.internal\Get-AzMigrateReplicationJob @PSBoundParameters
        }
        else {
            throw "Either machine doesn't exist or provider/action isn't supported for this machine"
        }
    }
}

# SIG # Begin signature block
# MIInvwYJKoZIhvcNAQcCoIInsDCCJ6wCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBe8P2QyQ4QCDXu
# OacFmy/Fo6DtoqCdGqArZ/Dc7/DfnqCCDXYwggX0MIID3KADAgECAhMzAAADrzBA
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGZ8wghmbAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIKgd8l6pD5McgFiyQrT48vom
# nQ2pBbE3EItsohFTUx6xMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAhOSE4RAt6hA093XiEK8/C2pj9rQV/JZ0UPWImfZGrerDlEJcUlsEAXMx
# 0Hn7G+KBVgb8/8GDJIybMCwsTR5SYUOxmg7u0VXaET/zvhDeZrOELNGmdmTtCc4A
# BXFgm3TZDsyPfewg5S5pg9pCeRFwFaTmGP4J93NoFpUSN/wWHw4M+in3fBU+CpGx
# fY3doUySLt4pgz+ufjOdXQfkJ7HT98GnEFbxY09JZc/y2C5uO99M0BED7T4bWiIa
# ossbr+u4InIbWkZAe2OcAeukgDJASteBJqS7eOs09taQ4Ml0FtuwmXLF5dYucEdG
# 1PMN5qd+Y8iQc1M1zZS+HFH81WKOCqGCFykwghclBgorBgEEAYI3AwMBMYIXFTCC
# FxEGCSqGSIb3DQEHAqCCFwIwghb+AgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFZBgsq
# hkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCDAH4PP6SyaNESttIwSbyyq1sWp/35oyqkuffKC9NxEAAIGZh+4i4kG
# GBMyMDI0MDQyMzEzMTUyMi43MzFaMASAAgH0oIHYpIHVMIHSMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJl
# bGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNO
# OjA4NDItNEJFNi1DMjlBMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNloIIReDCCBycwggUPoAMCAQICEzMAAAHajtXJWgDREbEAAQAAAdowDQYJ
# KoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMjMx
# MDEyMTkwNjU5WhcNMjUwMTEwMTkwNjU5WjCB0jELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxhbmQgT3Bl
# cmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjowODQyLTRC
# RTYtQzI5QTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZTCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJOQBgh2tVFR1j8jQA4NDf8b
# cVrXSN080CNKPSQo7S57sCnPU0FKF47w2L6qHtwm4EnClF2cruXFp/l7PpMQg25E
# 7X8xDmvxr8BBE6iASAPCfrTebuvAsZWcJYhy7prgCuBf7OidXpgsW1y8p6Vs7sD2
# aup/0uveYxeXlKtsPjMCplHkk0ba+HgLho0J68Kdji3DM2K59wHy9xrtsYK+X9er
# bDGZ2mmX3765aS5Q7/ugDxMVgzyj80yJn6ULnknD9i4kUQxVhqV1dc/DF6UBeuzf
# ukkMed7trzUEZMRyla7qhvwUeQlgzCQhpZjz+zsQgpXlPczvGd0iqr7lACwfVGog
# 5plIzdExvt1TA8Jmef819aTKwH1IVEIwYLA6uvS8kRdA6RxvMcb//ulNjIuGceyy
# kMAXEynVrLG9VvK4rfrCsGL3j30Lmidug+owrcCjQagYmrGk1hBykXilo9YB8Qyy
# 5Q1KhGuH65V3zFy8a0kwbKBRs8VR4HtoPYw9z1DdcJfZBO2dhzX3yAMipCGm6Smv
# mvavRsXhy805jiApDyN+s0/b7os2z8iRWGJk6M9uuT2493gFV/9JLGg5YJJCJXI+
# yxkO/OXnZJsuGt0+zWLdHS4XIXBG17oPu5KsFfRTHREloR2dI6GwaaxIyDySHYOt
# vIydla7u4lfnfCjY/qKTAgMBAAGjggFJMIIBRTAdBgNVHQ4EFgQUoXyNyVE9ZhOV
# izEUVwhNgL8PX0UwHwYDVR0jBBgwFoAUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXwYD
# VR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9j
# cmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3JsMGwG
# CCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIw
# MjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcD
# CDAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQADggIBALmDVdTtuI0jAEt4
# 1O2OM8CU237TGMyhrGr7FzKCEFaXxtoqk/IObQriq1caHVh2vyuQ24nz3TdOBv7r
# cs/qnPjOxnXFLyZPeaWLsNuARVmUViyVYXjXYB5DwzaWZgScY8GKL7yGjyWrh78W
# JUgh7rE1+5VD5h0/6rs9dBRqAzI9fhZz7spsjt8vnx50WExbBSSH7rfabHendpeq
# bTmW/RfcaT+GFIsT+g2ej7wRKIq/QhnsoF8mpFNPHV1q/WK/rF/ChovkhJMDvlqt
# ETWi97GolOSKamZC9bYgcPKfz28ed25WJy10VtQ9P5+C/2dOfDaz1RmeOb27Kbeg
# ha0SfPcriTfORVvqPDSa3n9N7dhTY7+49I8evoad9hdZ8CfIOPftwt3xTX2RhMZJ
# CVoFlabHcvfb84raFM6cz5EYk+x1aVEiXtgK6R0xn1wjMXHf0AWlSjqRkzvSnRKz
# FsZwEl74VahlKVhI+Ci9RT9+6Gc0xWzJ7zQIUFE3Jiix5+7KL8ArHfBY9UFLz4sn
# boJ7Qip3IADbkU4ZL0iQ8j8Ixra7aSYfToUefmct3dM69ff4Eeh2Kh9NsKiiph58
# 9Ap/xS1jESlrfjL/g/ZboaS5d9a2fA598mubDvLD5x5PP37700vm/Y+PIhmp2fTv
# uS2sndeZBmyTqcUNHRNmCk+njV3nMIIHcTCCBVmgAwIBAgITMwAAABXF52ueAptJ
# mQAAAAAAFTANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNh
# dGUgQXV0aG9yaXR5IDIwMTAwHhcNMjEwOTMwMTgyMjI1WhcNMzAwOTMwMTgzMjI1
# WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCCAiIwDQYJKoZIhvcNAQEB
# BQADggIPADCCAgoCggIBAOThpkzntHIhC3miy9ckeb0O1YLT/e6cBwfSqWxOdcjK
# NVf2AX9sSuDivbk+F2Az/1xPx2b3lVNxWuJ+Slr+uDZnhUYjDLWNE893MsAQGOhg
# fWpSg0S3po5GawcU88V29YZQ3MFEyHFcUTE3oAo4bo3t1w/YJlN8OWECesSq/XJp
# rx2rrPY2vjUmZNqYO7oaezOtgFt+jBAcnVL+tuhiJdxqD89d9P6OU8/W7IVWTe/d
# vI2k45GPsjksUZzpcGkNyjYtcI4xyDUoveO0hyTD4MmPfrVUj9z6BVWYbWg7mka9
# 7aSueik3rMvrg0XnRm7KMtXAhjBcTyziYrLNueKNiOSWrAFKu75xqRdbZ2De+JKR
# Hh09/SDPc31BmkZ1zcRfNN0Sidb9pSB9fvzZnkXftnIv231fgLrbqn427DZM9itu
# qBJR6L8FA6PRc6ZNN3SUHDSCD/AQ8rdHGO2n6Jl8P0zbr17C89XYcz1DTsEzOUyO
# ArxCaC4Q6oRRRuLRvWoYWmEBc8pnol7XKHYC4jMYctenIPDC+hIK12NvDMk2ZItb
# oKaDIV1fMHSRlJTYuVD5C4lh8zYGNRiER9vcG9H9stQcxWv2XFJRXRLbJbqvUAV6
# bMURHXLvjflSxIUXk8A8FdsaN8cIFRg/eKtFtvUeh17aj54WcmnGrnu3tz5q4i6t
# AgMBAAGjggHdMIIB2TASBgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQW
# BBQqp1L+ZMSavoKRPEY1Kc8Q/y8E7jAdBgNVHQ4EFgQUn6cVXQBeYl2D9OXSZacb
# UzUZ6XIwXAYDVR0gBFUwUzBRBgwrBgEEAYI3TIN9AQEwQTA/BggrBgEFBQcCARYz
# aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9Eb2NzL1JlcG9zaXRvcnku
# aHRtMBMGA1UdJQQMMAoGCCsGAQUFBwMIMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIA
# QwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFNX2
# VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwu
# bWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEw
# LTA2LTIzLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYt
# MjMuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQCdVX38Kq3hLB9nATEkW+Geckv8qW/q
# XBS2Pk5HZHixBpOXPTEztTnXwnE2P9pkbHzQdTltuw8x5MKP+2zRoZQYIu7pZmc6
# U03dmLq2HnjYNi6cqYJWAAOwBb6J6Gngugnue99qb74py27YP0h1AdkY3m2CDPVt
# I1TkeFN1JFe53Z/zjj3G82jfZfakVqr3lbYoVSfQJL1AoL8ZthISEV09J+BAljis
# 9/kpicO8F7BUhUKz/AyeixmJ5/ALaoHCgRlCGVJ1ijbCHcNhcy4sa3tuPywJeBTp
# kbKpW99Jo3QMvOyRgNI95ko+ZjtPu4b6MhrZlvSP9pEB9s7GdP32THJvEKt1MMU0
# sHrYUP4KWN1APMdUbZ1jdEgssU5HLcEUBHG/ZPkkvnNtyo4JvbMBV0lUZNlz138e
# W0QBjloZkWsNn6Qo3GcZKCS6OEuabvshVGtqRRFHqfG3rsjoiV5PndLQTHa1V1QJ
# sWkBRH58oWFsc/4Ku+xBZj1p/cvBQUl+fpO+y/g75LcVv7TOPqUxUYS8vwLBgqJ7
# Fx0ViY1w/ue10CgaiQuPNtq6TPmb/wrpNPgkNWcr4A245oyZ1uEi6vAnQj0llOZ0
# dFtq0Z4+7X6gMTN9vMvpe784cETRkPHIqzqKOghif9lwY1NNje6CbaUFEMFxBmoQ
# tB1VM1izoXBm8qGCAtQwggI9AgEBMIIBAKGB2KSB1TCB0jELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxh
# bmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjow
# ODQyLTRCRTYtQzI5QTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vy
# dmljZaIjCgEBMAcGBSsOAwIaAxUAQqIfIYljHUbNoY0/wjhXRn/sSA2ggYMwgYCk
# fjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIF
# AOnSH4QwIhgPMjAyNDA0MjMxOTUyMzZaGA8yMDI0MDQyNDE5NTIzNlowdDA6Bgor
# BgEEAYRZCgQBMSwwKjAKAgUA6dIfhAIBADAHAgEAAgIU6jAHAgEAAgIRVDAKAgUA
# 6dNxBAIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIBAAID
# B6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUAA4GBACaiRtshc9G8WfVMjQ9x
# gEYZNyoQzv72BU6LutxlZM2r2C6LuYvcx7q63PWs3MxkStXHAb2esRYvBMPDXsgq
# +NN6fYXSMTKwpnHYRiK/t3Uv3SwtPXjykiR2mqVxj6/PkN2nsimpupdSo/lnOZCf
# y706cQscQBC5MafJvRllTUbaMYIEDTCCBAkCAQEwgZMwfDELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgUENBIDIwMTACEzMAAAHajtXJWgDREbEAAQAAAdowDQYJYIZIAWUDBAIB
# BQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQx
# IgQgdOXbqmFmDDtG9/BnQIK0GWuGG+GkEdBq2K9qe+mWFVAwgfoGCyqGSIb3DQEJ
# EAIvMYHqMIHnMIHkMIG9BCAipaNpYsDvnqTe95Dj1C09020I5ljibrW/ndICOxg9
# xjCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# JjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB2o7V
# yVoA0RGxAAEAAAHaMCIEIFb/iamaUnR+fesQaHni5azXdqy22buGhS1oKaTDDm+J
# MA0GCSqGSIb3DQEBCwUABIICAHsc4cNNdj2lCsC7u84Ns3n7PmrRKAyP99PuYDNc
# vRjnW7Rfyy5UEqLbYfqf8LQfAN6cEzR45MbrQGxpEtBD/Ue3a/5Imy/UlUgWjcvN
# xvOIJNvXTTayWa+fy9H3erQJCl/F4pry3lfKe1zLL/E/aG7usVIiNmu4Plxo4qSw
# 2fcGR2vRRV9pR6pDIVAYOWCZ4kXGCJaCKqL+PEtbN41GDMh0UAQ+NElDx+j0Gi72
# hRvC9jXGnU6yZY0fybUR8VDOaH/iRCHewu1tlEQ4D25KDQa2+xuILB5+H2BPOqtP
# m6eg4jlSDuxOgQlZyozhO9lkOh6W4qF30cyClGBXTqhqeoU9IAQiyVvMbdf/8KWs
# cayEWx/9s8wu7QbgyLe6OxNn2Rdn7szKtfXo8cC+1PcrrfViHdPEj0xfbdqDACoK
# C5Okuad5V0EJlF9iTYjoCN5+E6FA+pycNEDra9lN9lXPJ0t2iih+sXj1Sx1196JQ
# +s5m9K6x80JvQDJvg9O59lVMIGoecyLcE5ZjXCwHDMua6XyB5Wwi4VBuZtA4SNE0
# GVBjw8bGN+qnNA/rBjrHWpldmqACaJThMshOmUZWjETgE4jEAyT/TroY5sb/5s1E
# pUP1/DJmeoWk7goE7yxkJPeTbRJOXG0HGnA8nXT/pjpHtc0gzAB/Ax3iWM8LDT0p
# CDmF
# SIG # End signature block
