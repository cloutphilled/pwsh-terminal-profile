
# ----------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Code generated by Microsoft (R) AutoRest Code Generator.Changes may cause incorrect behavior and will be lost if the code
# is regenerated.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Send test notifications to a set of provided receivers
.Description
Send test notifications to a set of provided receivers
.Example
$email1 = New-AzActionGroupEmailReceiverObject -EmailAddress user@example.com -Name user1
Test-AzActionGroup -ActionGroupName actiongroup1 -ResourceGroupName monitor-action -AlertType servicehealth -EmailReceiver $email1

.Inputs
Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Models.IActionGroupIdentity
.Outputs
Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Models.ITestNotificationDetailsResponse
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

ARMROLERECEIVER <IArmRoleReceiver[]>: The list of ARM role receivers that are part of this action group. Roles are Azure RBAC roles and only built-in roles are supported.
  Name <String>: The name of the arm role receiver. Names must be unique across all receivers within an action group.
  RoleId <String>: The arm role id.
  [UseCommonAlertSchema <Boolean?>]: Indicates whether to use common alert schema.

AUTOMATIONRUNBOOKRECEIVER <IAutomationRunbookReceiver[]>: The list of AutomationRunbook receivers that are part of this action group.
  AutomationAccountId <String>: The Azure automation account Id which holds this runbook and authenticate to Azure resource.
  IsGlobalRunbook <Boolean>: Indicates whether this instance is global runbook.
  RunbookName <String>: The name for this runbook.
  WebhookResourceId <String>: The resource id for webhook linked to this runbook.
  [Name <String>]: Indicates name of the webhook.
  [ServiceUri <String>]: The URI where webhooks should be sent.
  [UseCommonAlertSchema <Boolean?>]: Indicates whether to use common alert schema.

AZUREAPPPUSHRECEIVER <IAzureAppPushReceiver[]>: The list of AzureAppPush receivers that are part of this action group.
  EmailAddress <String>: The email address registered for the Azure mobile app.
  Name <String>: The name of the Azure mobile app push receiver. Names must be unique across all receivers within an action group.

AZUREFUNCTIONRECEIVER <IAzureFunctionReceiver[]>: The list of azure function receivers that are part of this action group.
  FunctionAppResourceId <String>: The azure resource id of the function app.
  FunctionName <String>: The function name in the function app.
  HttpTriggerUrl <String>: The http trigger url where http request sent to.
  Name <String>: The name of the azure function receiver. Names must be unique across all receivers within an action group.
  [UseCommonAlertSchema <Boolean?>]: Indicates whether to use common alert schema.

EMAILRECEIVER <IEmailReceiver[]>: The list of email receivers that are part of this action group.
  EmailAddress <String>: The email address of this receiver.
  Name <String>: The name of the email receiver. Names must be unique across all receivers within an action group.
  [UseCommonAlertSchema <Boolean?>]: Indicates whether to use common alert schema.

EVENTHUBRECEIVER <IEventHubReceiver[]>: The list of event hub receivers that are part of this action group.
  EventHubName <String>: The name of the specific Event Hub queue
  EventHubNameSpace <String>: The Event Hub namespace
  Name <String>: The name of the Event hub receiver. Names must be unique across all receivers within an action group.
  SubscriptionId <String>: The Id for the subscription containing this event hub
  [TenantId <String>]: The tenant Id for the subscription containing this event hub
  [UseCommonAlertSchema <Boolean?>]: Indicates whether to use common alert schema.

INPUTOBJECT <IActionGroupIdentity>: Identity Parameter
  [ActionGroupName <String>]: The name of the action group.
  [Id <String>]: Resource identity path
  [NotificationId <String>]: The notification id
  [ResourceGroupName <String>]: The name of the resource group. The name is case insensitive.
  [SubscriptionId <String>]: The ID of the target subscription.

ITSMRECEIVER <IItsmReceiver[]>: The list of ITSM receivers that are part of this action group.
  ConnectionId <String>: Unique identification of ITSM connection among multiple defined in above workspace.
  Name <String>: The name of the Itsm receiver. Names must be unique across all receivers within an action group.
  Region <String>: Region in which workspace resides. Supported values:'centralindia','japaneast','southeastasia','australiasoutheast','uksouth','westcentralus','canadacentral','eastus','westeurope'
  TicketConfiguration <String>: JSON blob for the configurations of the ITSM action. CreateMultipleWorkItems option will be part of this blob as well.
  WorkspaceId <String>: OMS LA instance identifier.

LOGICAPPRECEIVER <ILogicAppReceiver[]>: The list of logic app receivers that are part of this action group.
  CallbackUrl <String>: The callback url where http request sent to.
  Name <String>: The name of the logic app receiver. Names must be unique across all receivers within an action group.
  ResourceId <String>: The azure resource id of the logic app receiver.
  [UseCommonAlertSchema <Boolean?>]: Indicates whether to use common alert schema.

SMSRECEIVER <ISmsReceiver[]>: The list of SMS receivers that are part of this action group.
  CountryCode <String>: The country code of the SMS receiver.
  Name <String>: The name of the SMS receiver. Names must be unique across all receivers within an action group.
  PhoneNumber <String>: The phone number of the SMS receiver.

VOICERECEIVER <IVoiceReceiver[]>: The list of voice receivers that are part of this action group.
  CountryCode <String>: The country code of the voice receiver.
  Name <String>: The name of the voice receiver. Names must be unique across all receivers within an action group.
  PhoneNumber <String>: The phone number of the voice receiver.

WEBHOOKRECEIVER <IWebhookReceiver[]>: The list of webhook receivers that are part of this action group.
  Name <String>: The name of the webhook receiver. Names must be unique across all receivers within an action group.
  ServiceUri <String>: The URI where webhooks should be sent.
  [IdentifierUri <String>]: Indicates the identifier uri for aad auth.
  [ObjectId <String>]: Indicates the webhook app object Id for aad auth.
  [TenantId <String>]: Indicates the tenant id for aad auth.
  [UseAadAuth <Boolean?>]: Indicates whether or not use AAD authentication.
  [UseCommonAlertSchema <Boolean?>]: Indicates whether to use common alert schema.
.Link
https://learn.microsoft.com/powershell/module/az.monitor/test-azactiongroup
#>
function Test-AzActionGroup {
[OutputType([Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Models.ITestNotificationDetailsResponse])]
[CmdletBinding(DefaultParameterSetName='CreateExpanded', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
param(
    [Parameter(ParameterSetName='CreateExpanded', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Path')]
    [System.String]
    # The name of the action group.
    ${ActionGroupName},

    [Parameter(ParameterSetName='CreateExpanded', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Path')]
    [System.String]
    # The name of the resource group.
    # The name is case insensitive.
    ${ResourceGroupName},

    [Parameter(ParameterSetName='CreateExpanded')]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Path')]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
    [System.String]
    # The ID of the target subscription.
    ${SubscriptionId},

    [Parameter(ParameterSetName='CreateViaIdentityExpanded', Mandatory, ValueFromPipeline)]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Path')]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Models.IActionGroupIdentity]
    # Identity Parameter
    # To construct, see NOTES section for INPUTOBJECT properties and create a hash table.
    ${InputObject},

    [Parameter(ParameterSetName='CreateExpanded', Mandatory)]
    [Parameter(ParameterSetName='CreateViaIdentityExpanded', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Body')]
    [System.String]
    # The value of the supported alert type.
    # Supported alert type values are: servicehealth, metricstaticthreshold, metricsdynamicthreshold, logalertv2, smartalert, webtestalert, logalertv1numresult, logalertv1metricmeasurement, resourcehealth, activitylog, actualcostbudget, forecastedbudget
    ${AlertType},

    [Parameter(ParameterSetName='CreateExpanded', Mandatory)]
    [Parameter(ParameterSetName='CreateViaIdentityExpanded', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Models.IActionGroupReceiver[]]
    # The list of receivers that are part of this action group.
    ${Receiver},

    [Parameter()]
    [Alias('AzureRMContext', 'AzureCredential')]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Azure')]
    [System.Management.Automation.PSObject]
    # The DefaultProfile parameter is not functional.
    # Use the SubscriptionId parameter when available if executing the cmdlet against a different subscription.
    ${DefaultProfile},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Run the command as a job
    ${AsJob},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Wait for .NET debugger to attach
    ${Break},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Runtime')]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Runtime.SendAsyncStep[]]
    # SendAsync Pipeline Steps to be appended to the front of the pipeline
    ${HttpPipelineAppend},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Runtime')]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Runtime.SendAsyncStep[]]
    # SendAsync Pipeline Steps to be prepended to the front of the pipeline
    ${HttpPipelinePrepend},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Run the command asynchronously
    ${NoWait},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Runtime')]
    [System.Uri]
    # The URI for the proxy server to use
    ${Proxy},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Runtime')]
    [System.Management.Automation.PSCredential]
    # Credentials for a proxy server to use for the remote call
    ${ProxyCredential},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.Monitor.ActionGroup.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Use the default credentials for the proxy
    ${ProxyUseDefaultCredentials}
)

process {
  try{
      $receivers = @{}

      foreach ($subReceiver in $Receiver)
      {
        Write-Host $subReceiver.GetType().Name
        if ($subReceiver.GetType().Name -eq 'ArmRoleReceiver')
        {
          if (-not $receivers.contains('ArmRoleReceiver'))
          {
            $receivers['ArmRoleReceiver'] = @()
          }
          $receivers['ArmRoleReceiver'] = $receivers['ArmRoleReceiver'] + $subReceiver
        }
        if ($subReceiver.GetType().Name -eq 'AutomationRunbookReceiver')
        {
          if (-not $receivers.contains('AutomationRunbookReceiver'))
          {
            $receivers['AutomationRunbookReceiver'] = @()
          }
          $receivers['AutomationRunbookReceiver'] = $receivers['AutomationRunbookReceiver'] + $subReceiver
        }
        if ($subReceiver.GetType().Name -eq 'AzureAppPushReceiver')
        {
          if (-not $receivers.contains('AzureAppPushReceiver'))
          {
            $receivers['AzureAppPushReceiver'] = @()
          }
          $receivers['AzureAppPushReceiver'] = $receivers['AzureAppPushReceiver'] + $subReceiver
        }
        if ($subReceiver.GetType().Name -eq 'AzureFunctionReceiver')
        {
          if (-not $receivers.contains('AzureFunctionReceiver'))
          {
            $receivers['AzureFunctionReceiver'] = @()
          }
          $receivers['AzureFunctionReceiver'] = $receivers['AzureFunctionReceiver'] + $subReceiver
        }
        if ($subReceiver.GetType().Name -eq 'EmailReceiver')
        {
          if (-not $receivers.contains('EmailReceiver'))
          {
            $receivers['EmailReceiver'] = @()
          }
          $receivers['EmailReceiver'] = $receivers['EmailReceiver'] + $subReceiver
        }
        if ($subReceiver.GetType().Name -eq 'EventHubReceiver')
        {
          if (-not $receivers.contains('EventHubReceiver'))
          {
            $receivers['EventHubReceiver'] = @()
          }
          $receivers['EventHubReceiver'] = $receivers['EventHubReceiver'] + $subReceiver
        }
        if ($subReceiver.GetType().Name -eq 'ItsmReceiver')
        {
          if (-not $receivers.contains('ItsmReceiver'))
          {
            $receivers['ItsmReceiver'] = @()
          }
          $receivers['ItsmReceiver'] = $receivers['ItsmReceiver'] + $subReceiver
        }
        if ($subReceiver.GetType().Name -eq 'LogicAppReceiver')
        {
          if (-not $receivers.contains('LogicAppReceiver'))
          {
            $receivers['LogicAppReceiver'] = @()
          }
          $receivers['LogicAppReceiver'] = $receivers['LogicAppReceiver'] + $subReceiver
        }
        if ($subReceiver.GetType().Name -eq 'SmsReceiver')
        {
          if (-not $receivers.contains('SmsReceiver'))
          {
            $receivers['SmsReceiver'] = @()
          }
          $receivers['SmsReceiver'] = $receivers['SmsReceiver'] + $subReceiver
        }
        if ($subReceiver.GetType().Name -eq 'VoiceReceiver')
        {
          if (-not $receivers.contains('VoiceReceiver'))
          {
            $receivers['VoiceReceiver'] = @()
          }
          $receivers['VoiceReceiver'] = $receivers['VoiceReceiver'] + $subReceiver
        }
        if ($subReceiver.GetType().Name -eq 'WebhookReceiver')
        {
          if (-not $receivers.contains('WebhookReceiver'))
          {
            $receivers['WebhookReceiver'] = @()
          }
          $receivers['WebhookReceiver'] = $receivers['WebhookReceiver'] + $subReceiver
        }
      }

      $null = $PSBoundParameters.Remove('Receiver')
      Az.ActionGroup.internal\Test-AzActionGroup @receivers @PSBoundParameters
  } catch {

        throw
    }
}
}

# SIG # Begin signature block
# MIInvgYJKoZIhvcNAQcCoIInrzCCJ6sCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDiTUrYU7lHNvMH
# XB7nEDQIbQWAfEIMW0+w9HwUmfuONKCCDXYwggX0MIID3KADAgECAhMzAAADrzBA
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGZ4wghmaAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEICwAymGLslZnKU7CaAKhGObs
# CkjV8h5GNxuch4CEKG2wMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAgwcldLUdzAy3gk7F4y1X1odaDoD0kDh/phCx13z2vlqf8qdQ04UV9Pfn
# A5Npk+Pe/iRcNjcncUp9ryASR0W070ZJtvWQkj04+xEvch+31fK2Kw95VWNwWJAi
# /hbCBjr6L+95Eyysu+H9PugnAJ4UuzqsQUp4/PEfA7OD1ljMT1FRHyNnS7yZram2
# E0Yp5NEYUMxLBHK3YRrKqbJ31plUNfhhQVB2gfwAMt6r6YsQ7EdAKUEU4XKlBI/o
# r48LtbPMlSrJoJZmhgfSnboLNxeptbf1OecHpUvPFSvsj8+NmFPQ88Buao+Y4pCK
# ICBGlVeWr8Y2XSMACvGdrsvyrfe2/KGCFygwghckBgorBgEEAYI3AwMBMYIXFDCC
# FxAGCSqGSIb3DQEHAqCCFwEwghb9AgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFYBgsq
# hkiG9w0BCRABBKCCAUcEggFDMIIBPwIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCAcPIsCHOEPjIgboafpsS08hQFCVvXUKmQcWj76hpuk6AIGZjOtMlBf
# GBIyMDI0MDUxNjA2NDIxNC4xNlowBIACAfSggdikgdUwgdIxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVs
# YW5kIE9wZXJhdGlvbnMgTGltaXRlZDEmMCQGA1UECxMdVGhhbGVzIFRTUyBFU046
# RDA4Mi00QkZELUVFQkExJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNl
# cnZpY2WgghF4MIIHJzCCBQ+gAwIBAgITMwAAAdzB4IzCX1hejgABAAAB3DANBgkq
# hkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0yMzEw
# MTIxOTA3MDZaFw0yNTAxMTAxOTA3MDZaMIHSMQswCQYDVQQGEwJVUzETMBEGA1UE
# CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
# b2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJlbGFuZCBPcGVy
# YXRpb25zIExpbWl0ZWQxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOkQwODItNEJG
# RC1FRUJBMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIIC
# IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAi8izIDWyOD2RIonN6WtRYXlK
# GphYvzdqafdITknIhU9QLsXqpNwumGEdn2J1/bV/RFoatTwQfJ0Xw3E8xHYpU2IC
# 0IY8lryRXUIa+fdt4YHabaW2aolqcbvWYDLCuQoBNieLAos9AsnTQSRfDlNLB+Yl
# dt2BAsWUfJ8DkqD6lSwlfOq6aQi8SvQNc++m0AaqR0UsrCjgFOUSCe/N5N9e6TNf
# y9C1MAt9Um5NSBFTvOg/9EVa3dZqBqFnpSWgjQULxeUFANUNfkl4wSzHuOAkN0Sc
# rjhjyAe4RZEOr5Ib1ejQYg6OK5NYPm6/e+USYgDJH/utIW9wufACox2pzL+KpA8y
# UM5x3QBueI/yJrUFARSd9lPdTHIr2ssH9JGIo/IcOWDyhbBfKK/f5sYHp2Z0zrW6
# vqdS18N/nWU9wqErhWjzek4TX+eJaVWcQdBX00nn8NtRKpbZGpNRrY7Yq6+zJEYw
# SCMYkDXb9KqtGqW8TZ+I3lmZlW2pI9ZohqzHtrQYH591PD6B5GfoyjZLr79tkTBL
# /QgnmBwoaKc1t/JDXGu9Zc+1fMo5+OSHvmJG5ei6sZU9GqSbPlRjP5HnJswlaP6Z
# 9warPaFdXyJmcJkMGuudmK+cSsIyHkWV+Dzj3qlPSmGNRMfYYKEci8ThINKTaHBY
# /+4cH2ASzyn/097+a30CAwEAAaOCAUkwggFFMB0GA1UdDgQWBBToc9IF3Q58Rfe4
# 1ax2RKtpQZ7d2zAfBgNVHSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBfBgNV
# HR8EWDBWMFSgUqBQhk5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2Ny
# bC9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmwwbAYI
# KwYBBQUHAQEEYDBeMFwGCCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NlcnRzL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAy
# MDEwKDEpLmNydDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMI
# MA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0BAQsFAAOCAgEA2etvwTCvx5f8fWwq
# 3eufBMPHgCqAduQw1Cj6RQbAIg1dLfLUZRx2qwr9HWDpN/u03HWrQ2kqTUlO6lQl
# 8d0TEq2S6EcD7zaVPvIhKn9jvh2onTdEJPhD7yihBdMzPGJ7B8StUu3xZ595udxJ
# PSLrKkq/zukJiTEzbhtupsz9X4zlUGmkJSztH5wROLP/MQDUBtkv++Je0eavIDQI
# Z34+31z5p2xh+bup7lQydLR/9gmYQQyQSoZcLPIsr52H5SwWLR3iWR1wT5mrkk2M
# gd6xfXDO0ZUC29fQNgNl03ZZnWST6E4xuVRX8vyfVhbOE//ldCdiXTcB9cSuf7UR
# q3KWJ/N3cKEnXG4YbvphtaCJFecO8KLAOq9Ql69VFjWrLjLi+VUppKG1t1+A/IZ5
# 4n9hxIE405zQM1NZuMxsvnSp4gQLSUdKkvatFg1W7eGwfMbyfm7kJBqM/DH0/Omx
# kh4VM0fJUXqS6MjhWj0287/MXw63jggyPgztRf1lrhDAZ/kHvXHns6NpfneDFPi/
# Oge8QFcX2oKYdGBcEttGiYl8OfrRqXO/t2kJVAi5DTrafIhkqexfHO4oVvRONdbD
# o4WkbVuyNek6jkMweTKyuJvEeivhjPl1mNXIcA3IqjRtKsCVV6KFxobkXvhJlPwW
# 3IcBboiAtznD/cP5HWhsOEpnbVYwggdxMIIFWaADAgECAhMzAAAAFcXna54Cm0mZ
# AAAAAAAVMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMDAeFw0yMTA5MzAxODIyMjVaFw0zMDA5MzAxODMyMjVa
# MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMT
# HU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMIICIjANBgkqhkiG9w0BAQEF
# AAOCAg8AMIICCgKCAgEA5OGmTOe0ciELeaLL1yR5vQ7VgtP97pwHB9KpbE51yMo1
# V/YBf2xK4OK9uT4XYDP/XE/HZveVU3Fa4n5KWv64NmeFRiMMtY0Tz3cywBAY6GB9
# alKDRLemjkZrBxTzxXb1hlDcwUTIcVxRMTegCjhuje3XD9gmU3w5YQJ6xKr9cmmv
# Haus9ja+NSZk2pg7uhp7M62AW36MEBydUv626GIl3GoPz130/o5Tz9bshVZN7928
# jaTjkY+yOSxRnOlwaQ3KNi1wjjHINSi947SHJMPgyY9+tVSP3PoFVZhtaDuaRr3t
# pK56KTesy+uDRedGbsoy1cCGMFxPLOJiss254o2I5JasAUq7vnGpF1tnYN74kpEe
# HT39IM9zfUGaRnXNxF803RKJ1v2lIH1+/NmeRd+2ci/bfV+AutuqfjbsNkz2K26o
# ElHovwUDo9Fzpk03dJQcNIIP8BDyt0cY7afomXw/TNuvXsLz1dhzPUNOwTM5TI4C
# vEJoLhDqhFFG4tG9ahhaYQFzymeiXtcodgLiMxhy16cg8ML6EgrXY28MyTZki1ug
# poMhXV8wdJGUlNi5UPkLiWHzNgY1GIRH29wb0f2y1BzFa/ZcUlFdEtsluq9QBXps
# xREdcu+N+VLEhReTwDwV2xo3xwgVGD94q0W29R6HXtqPnhZyacaue7e3PmriLq0C
# AwEAAaOCAd0wggHZMBIGCSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYE
# FCqnUv5kxJq+gpE8RjUpzxD/LwTuMB0GA1UdDgQWBBSfpxVdAF5iXYP05dJlpxtT
# NRnpcjBcBgNVHSAEVTBTMFEGDCsGAQQBgjdMg30BATBBMD8GCCsGAQUFBwIBFjNo
# dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9yeS5o
# dG0wEwYDVR0lBAwwCgYIKwYBBQUHAwgwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBD
# AEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZW
# y4/oolxiaNE9lJBb186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5t
# aWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAt
# MDYtMjMuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0y
# My5jcnQwDQYJKoZIhvcNAQELBQADggIBAJ1VffwqreEsH2cBMSRb4Z5yS/ypb+pc
# FLY+TkdkeLEGk5c9MTO1OdfCcTY/2mRsfNB1OW27DzHkwo/7bNGhlBgi7ulmZzpT
# Td2YurYeeNg2LpypglYAA7AFvonoaeC6Ce5732pvvinLbtg/SHUB2RjebYIM9W0j
# VOR4U3UkV7ndn/OOPcbzaN9l9qRWqveVtihVJ9AkvUCgvxm2EhIRXT0n4ECWOKz3
# +SmJw7wXsFSFQrP8DJ6LGYnn8AtqgcKBGUIZUnWKNsIdw2FzLixre24/LAl4FOmR
# sqlb30mjdAy87JGA0j3mSj5mO0+7hvoyGtmW9I/2kQH2zsZ0/fZMcm8Qq3UwxTSw
# ethQ/gpY3UA8x1RtnWN0SCyxTkctwRQEcb9k+SS+c23Kjgm9swFXSVRk2XPXfx5b
# RAGOWhmRaw2fpCjcZxkoJLo4S5pu+yFUa2pFEUep8beuyOiJXk+d0tBMdrVXVAmx
# aQFEfnyhYWxz/gq77EFmPWn9y8FBSX5+k77L+DvktxW/tM4+pTFRhLy/AsGConsX
# HRWJjXD+57XQKBqJC4822rpM+Zv/Cuk0+CQ1ZyvgDbjmjJnW4SLq8CdCPSWU5nR0
# W2rRnj7tfqAxM328y+l7vzhwRNGQ8cirOoo6CGJ/2XBjU02N7oJtpQUQwXEGahC0
# HVUzWLOhcGbyoYIC1DCCAj0CAQEwggEAoYHYpIHVMIHSMQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJlbGFu
# ZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOkQw
# ODItNEJGRC1FRUJBMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2
# aWNloiMKAQEwBwYFKw4DAhoDFQAcOf9zP7fJGQhQIl9Jsvd2OdASpqCBgzCBgKR+
# MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMT
# HU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBBQUAAgUA
# 6e/2qTAiGA8yMDI0MDUxNjExMDYxN1oYDzIwMjQwNTE3MTEwNjE3WjB0MDoGCisG
# AQQBhFkKBAExLDAqMAoCBQDp7/apAgEAMAcCAQACAg4cMAcCAQACAhIsMAoCBQDp
# 8UgpAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMH
# oSChCjAIAgEAAgMBhqAwDQYJKoZIhvcNAQEFBQADgYEASssy8GQdvgp7Nm822yTj
# zj6PnXQtZMpDBe1wrwvxioDT7CVaVjtC5sfaGZ1MCYP8QI9zFs0jWlMooniGVdRT
# nqCt3P4GHmNpblnpeHRyGL2kcnvHVw0V4XQt3OW+PgPEGQidPfQrpP6YTKtxTevz
# +Z/Q+aDe1f81epWai5ZK2ZExggQNMIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1T
# dGFtcCBQQ0EgMjAxMAITMwAAAdzB4IzCX1hejgABAAAB3DANBglghkgBZQMEAgEF
# AKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEi
# BCDc0RbsGMFz70druTt3th1mxEKqCYh8RHWJkr4ZWNN6ODCB+gYLKoZIhvcNAQkQ
# Ai8xgeowgecwgeQwgb0EIFOnF4pq2UQ/jLypnOO5YvQ67QirEQsOFfZMvKXEgg03
# MIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
# BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEm
# MCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHcweCM
# wl9YXo4AAQAAAdwwIgQgxO9sfqQgdSt65QP8errS69UTQy2qPmxIgasCQRWTU0Uw
# DQYJKoZIhvcNAQELBQAEggIAJNOHD/f9SdEHEHg8p1OKiKp98llzckbD9dtNA3G/
# v08ucKhZ81iMel+n7UmHmdZnh2FTCz4QJ1ESuKPr5boPomKr0+iJjkHRPvIb1rCv
# XllnpH82fApqB+Lup+nIG/GZKXh62ksn8CIuYB6HhT5aMLaWTcG2hm+skezz4MaT
# R7iAL1gqfBXy7EXW5MDVuuCJxSEn4zQZJ/LPBSTLsl7THDMcIWpnm5jT870ZLsVb
# 67dlGc3fX8ee7Of2uraXKQuGmYM3SkmbLU9BFIY8WPsYESmphTZ1m2aOfAsBRFKs
# wxaPMKP8UHGAnSPtVXawaPh1SfKWRHYlIL2KgmYoqOgJNvNo7K/SUQvLYAsHMb1T
# h2FaJl19owsWiuxGEKIUBlNmnHs6Xz4a2CGVoVeC7Uy1tU+y7gC0nPGQzvQh4cOB
# C8nFTMMZi4+M8QO7LDpgyKMzI1zrSrSEgKpOhOCGUkX6L8F04vz+r1FBkYd7ARbI
# X5fyZSBPEYRY6TrNaEZH6dQR2mjb92Ij5LAh4l/d0HK7eAZ4ZBYrhcVsV/uc5pwE
# ZMSGhOfNxrIIpgk7V4VaRua6lj9o+Qw1wlSQ0XKDJb+NyNGcW0sdd+gxvDBr8Zm4
# yJXYBZso+KZVAf4Xx2vdbSz2Bo4HD/KlFrc+rzbdM9nNzi9ZYcWm5EmcHmBPwRV7
# dts=
# SIG # End signature block
