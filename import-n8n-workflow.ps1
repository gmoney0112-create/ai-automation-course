$apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxNGRmMTRhYS1hOTE4LTQzOTgtOTU3Yy1hZTc3ZjAxNTA2MmIiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwianRpIjoiN2ZlYzE5M2UtNjIwZi00MDY4LWJhYTItM2I4NTdmODhjMGNiIiwiaWF0IjoxNzcyNzE3NDM1fQ.aL2FmgFyXXIrDGr57spsX4F-SWjTx5aXAE_WhZ4vD28"
$raw = Get-Content "C:\Users\gmone\Desktop\ai-automation-course\n8n-workflow-stripe-router.json" -Raw -Encoding UTF8 | ConvertFrom-Json
# n8n API v1 only accepts: name, nodes, connections, settings, staticData, tags
$payload = @{
    name        = $raw.name
    nodes       = $raw.nodes
    connections = $raw.connections
    settings    = $raw.settings
}
$body = $payload | ConvertTo-Json -Depth 20 -Compress

$headers = @{ "X-N8N-API-KEY" = $apiKey; "Content-Type" = "application/json" }
$r = Invoke-WebRequest `
    -Method POST `
    -Uri "https://soulprosperity.app.n8n.cloud/api/v1/workflows" `
    -Headers $headers `
    -Body $body `
    -UseBasicParsing

Write-Output "STATUS: $($r.StatusCode)"
Write-Output $r.Content
