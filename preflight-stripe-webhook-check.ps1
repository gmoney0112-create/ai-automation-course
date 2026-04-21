param(
    [string]$StripeSecretKey,
    [string]$WebhookUrl = "https://soulprosperity.app.n8n.cloud/webhook/ai-course-stripe",
    [string]$CorePriceId,
    [string]$LaunchPriceId,
    [string]$MembershipPriceId,
    [string]$CorePaymentLinkId,
    [string]$LaunchPaymentLinkId,
    [string]$MembershipPaymentLinkId,
    [string]$N8nApiKey,
    [string]$N8nBaseUrl = "https://soulprosperity.app.n8n.cloud",
    [string]$WorkflowId = "5zzkYEiCcjOOccoZ"
)

$ErrorActionPreference = "Stop"

function Get-RequiredValue {
    param(
        [string]$Value,
        [string]$Prompt
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return Read-Host $Prompt
    }

    return $Value
}

function Invoke-StripeGet {
    param(
        [string]$Secret,
        [string]$Path
    )

    $uri = "https://api.stripe.com$Path"
    $headers = @{
        Authorization = "Bearer $Secret"
    }

    return Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
}

function Invoke-N8nGet {
    param(
        [string]$ApiKey,
        [string]$BaseUrl,
        [string]$Path
    )

    $uri = "$($BaseUrl.TrimEnd('/'))$Path"
    $headers = @{
        "X-N8N-API-KEY" = $ApiKey
    }

    return Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
}

function Test-Price {
    param(
        [string]$Secret,
        [string]$PriceId,
        [string]$Label
    )

    try {
        $price = Invoke-StripeGet -Secret $Secret -Path "/v1/prices/$PriceId"

        return [PSCustomObject]@{
            Check      = "Price $Label"
            Target     = $PriceId
            Pass       = $true
            Notes      = "Found. Active=$($price.active) Currency=$($price.currency) Type=$($price.type)"
        }
    }
    catch {
        return [PSCustomObject]@{
            Check      = "Price $Label"
            Target     = $PriceId
            Pass       = $false
            Notes      = "Not found or inaccessible. $($_.Exception.Message)"
        }
    }
}

function Test-Webhook {
    param(
        [string]$Secret,
        [string]$ExpectedUrl
    )

    try {
        $result = Invoke-StripeGet -Secret $Secret -Path "/v1/webhook_endpoints?limit=100"
        $endpoint = $result.data | Where-Object { $_.url -eq $ExpectedUrl } | Select-Object -First 1

        if (-not $endpoint) {
            return [PSCustomObject]@{
                Check  = "Webhook endpoint exists"
                Target = $ExpectedUrl
                Pass   = $false
                Notes  = "No Stripe webhook endpoint found with this URL"
            }
        }

        $requiredEvents = @(
            "checkout.session.completed",
            "customer.subscription.deleted",
            "invoice.payment_failed"
        )

        $missing = @($requiredEvents | Where-Object { $_ -notin $endpoint.enabled_events })

        if ($missing.Count -gt 0) {
            return [PSCustomObject]@{
                Check  = "Webhook events configured"
                Target = $ExpectedUrl
                Pass   = $false
                Notes  = "Missing events: $($missing -join ', ')"
            }
        }

        return [PSCustomObject]@{
            Check  = "Webhook events configured"
            Target = $ExpectedUrl
            Pass   = $true
            Notes  = "All required events present"
        }
    }
    catch {
        return [PSCustomObject]@{
            Check  = "Webhook endpoint lookup"
            Target = $ExpectedUrl
            Pass   = $false
            Notes  = "Stripe API error. $($_.Exception.Message)"
        }
    }
}

function Test-PaymentLinkMetadata {
    param(
        [string]$Secret,
        [string]$PaymentLinkId,
        [string]$ExpectedTier,
        [string]$Label
    )

    if ([string]::IsNullOrWhiteSpace($PaymentLinkId)) {
        return [PSCustomObject]@{
            Check  = "Payment Link metadata $Label"
            Target = "<skipped>"
            Pass   = $false
            Notes  = "Missing Payment Link ID. Provide plink_... to verify metadata.tier"
        }
    }

    try {
        $link = Invoke-StripeGet -Secret $Secret -Path "/v1/payment_links/$PaymentLinkId"
        $actualTier = $link.metadata.tier

        if ($actualTier -ne $ExpectedTier) {
            return [PSCustomObject]@{
                Check  = "Payment Link metadata $Label"
                Target = $PaymentLinkId
                Pass   = $false
                Notes  = "Expected metadata.tier=$ExpectedTier but got '$actualTier'"
            }
        }

        return [PSCustomObject]@{
            Check  = "Payment Link metadata $Label"
            Target = $PaymentLinkId
            Pass   = $true
            Notes  = "metadata.tier=$actualTier"
        }
    }
    catch {
        return [PSCustomObject]@{
            Check  = "Payment Link metadata $Label"
            Target = $PaymentLinkId
            Pass   = $false
            Notes  = "Payment Link not found or inaccessible. $($_.Exception.Message)"
        }
    }
}

function Test-N8nWorkflowInactive {
    param(
        [string]$ApiKey,
        [string]$BaseUrl,
        [string]$Id
    )

    if ([string]::IsNullOrWhiteSpace($ApiKey)) {
        return [PSCustomObject]@{
            Check  = "n8n workflow inactive"
            Target = $Id
            Pass   = $false
            Notes  = "Missing n8n API key. Provide -N8nApiKey to verify workflow state"
        }
    }

    try {
        $workflow = Invoke-N8nGet -ApiKey $ApiKey -BaseUrl $BaseUrl -Path "/api/v1/workflows/$Id"

        if ($workflow.active -eq $true) {
            return [PSCustomObject]@{
                Check  = "n8n workflow inactive"
                Target = $Id
                Pass   = $false
                Notes  = "Workflow is ACTIVE. Keep it inactive until preflight and one full test purchase pass"
            }
        }

        return [PSCustomObject]@{
            Check  = "n8n workflow inactive"
            Target = $Id
            Pass   = $true
            Notes  = "Workflow is inactive"
        }
    }
    catch {
        return [PSCustomObject]@{
            Check  = "n8n workflow inactive"
            Target = $Id
            Pass   = $false
            Notes  = "n8n API error. $($_.Exception.Message)"
        }
    }
}

$StripeSecretKey = Get-RequiredValue -Value $StripeSecretKey -Prompt "Enter Stripe secret key (sk_live or sk_test)"
$CorePriceId = Get-RequiredValue -Value $CorePriceId -Prompt "Enter Core price ID"
$LaunchPriceId = Get-RequiredValue -Value $LaunchPriceId -Prompt "Enter Launch price ID"
$MembershipPriceId = Get-RequiredValue -Value $MembershipPriceId -Prompt "Enter Membership price ID"
$WebhookUrl = Get-RequiredValue -Value $WebhookUrl -Prompt "Enter Stripe webhook endpoint URL"
$CorePaymentLinkId = Get-RequiredValue -Value $CorePaymentLinkId -Prompt "Enter Core Payment Link ID (plink_...)"
$LaunchPaymentLinkId = Get-RequiredValue -Value $LaunchPaymentLinkId -Prompt "Enter Launch Payment Link ID (plink_...)"
$MembershipPaymentLinkId = Get-RequiredValue -Value $MembershipPaymentLinkId -Prompt "Enter Membership Payment Link ID (plink_...)"
$N8nApiKey = Get-RequiredValue -Value $N8nApiKey -Prompt "Enter n8n API key"

$checks = @()
$checks += Test-Price -Secret $StripeSecretKey -PriceId $CorePriceId -Label "Core"
$checks += Test-Price -Secret $StripeSecretKey -PriceId $LaunchPriceId -Label "Launch"
$checks += Test-Price -Secret $StripeSecretKey -PriceId $MembershipPriceId -Label "Membership"
$checks += Test-Webhook -Secret $StripeSecretKey -ExpectedUrl $WebhookUrl
$checks += Test-PaymentLinkMetadata -Secret $StripeSecretKey -PaymentLinkId $CorePaymentLinkId -ExpectedTier "core" -Label "Core"
$checks += Test-PaymentLinkMetadata -Secret $StripeSecretKey -PaymentLinkId $LaunchPaymentLinkId -ExpectedTier "launch_system" -Label "Launch"
$checks += Test-PaymentLinkMetadata -Secret $StripeSecretKey -PaymentLinkId $MembershipPaymentLinkId -ExpectedTier "membership" -Label "Membership"
$checks += Test-N8nWorkflowInactive -ApiKey $N8nApiKey -BaseUrl $N8nBaseUrl -Id $WorkflowId

Write-Host ""
Write-Host "Stripe preflight results" -ForegroundColor Cyan
$checks | Select-Object Check, Target, Pass, Notes | Format-Table -AutoSize

$failed = @($checks | Where-Object { -not $_.Pass })
$nonWorkflowFails = @($failed | Where-Object { $_.Check -ne "n8n workflow inactive" })
$workflowInactiveCheck = $checks | Where-Object { $_.Check -eq "n8n workflow inactive" } | Select-Object -First 1

Write-Host ""
if ($failed.Count -eq 0) {
    Write-Host "PASS: All Stripe preflight checks passed." -ForegroundColor Green
    exit 0
}
elseif ($nonWorkflowFails.Count -eq 0 -and $workflowInactiveCheck -and -not $workflowInactiveCheck.Pass) {
    Write-Host "CAUTION: Stripe checks passed, but workflow is already active." -ForegroundColor Yellow
    Write-Host "Confirm whether activation is intentional before continuing:" -ForegroundColor Yellow
    Write-Host "- If unintentional: deactivate workflow, then rerun preflight." -ForegroundColor Yellow
    Write-Host "- If intentional for controlled testing: proceed carefully." -ForegroundColor Yellow
    exit 2
}
else {
    Write-Host "FAIL: $($failed.Count) check(s) failed. Do not activate workflow yet." -ForegroundColor Red
    exit 1
}
