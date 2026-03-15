# System Health Dashboard
# Provides quick overview of OpenClaw workspace health metrics
# Run: .\system_health_dashboard.ps1

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "      OPENCLAW SYSTEM HEALTH DASHBOARD" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Memory System Status
Write-Host "🧠 MEMORY SYSTEM" -ForegroundColor Yellow
$todayFile = "memory/$(Get-Date -Format 'yyyy-MM-dd').md"
$yesterdayFile = "memory/$(Get-Date (Get-Date).AddDays(-1) -Format 'yyyy-MM-dd').md"

if (Test-Path $todayFile) {
    Write-Host "  ✓ Today's memory file exists: $todayFile" -ForegroundColor Green
} else {
    Write-Host "  ✗ Today's memory file missing: $todayFile" -ForegroundColor Red
}

if (Test-Path $yesterdayFile) {
    Write-Host "  ✓ Yesterday's memory file exists: $yesterdayFile" -ForegroundColor Green
} else {
    Write-Host "  ✗ Yesterday's memory file missing: $yesterdayFile" -ForegroundColor Red
}

if (Test-Path "memory/working-buffer.md") {
    $wbContent = Get-Content "memory/working-buffer.md" -TotalCount 5
    $active = $wbContent | Where-Object { $_ -match "Status:.*ACTIVE" }
    if ($active) {
        Write-Host "  ✓ Working buffer: ACTIVE" -ForegroundColor Green
    } else {
        # Check if it says INACTIVE or just doesn't have status line
        $inactive = $wbContent | Where-Object { $_ -match "Status:.*INACTIVE" }
        if ($inactive) {
            Write-Host "  ✗ Working buffer: INACTIVE" -ForegroundColor Red
        } else {
            Write-Host "  ⚠️ Working buffer: Status unknown" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "  ✗ Working buffer file missing" -ForegroundColor Red
}

Write-Host ""

# 2. Session State
Write-Host "📋 SESSION STATE" -ForegroundColor Yellow
if (Test-Path "SESSION-STATE.md") {
    $lastUpdate = Select-String -Path "SESSION-STATE.md" -Pattern "Last Updated" -Context 0,5
    if ($lastUpdate) {
        Write-Host "  ✓ SESSION-STATE.md exists" -ForegroundColor Green
        Write-Host "  Last update:" $lastUpdate.Line -ForegroundColor Gray
    }
} else {
    Write-Host "  ✗ SESSION-STATE.md missing" -ForegroundColor Red
}

Write-Host ""

# 3. File Management Status
Write-Host "📁 FILE MANAGEMENT" -ForegroundColor Yellow
# Check in current directory and workspace root
$uploadScripts = @("upload_simple.ps1", "upload_to_github_notion.ps1")
$uploadCount = 0
$foundScripts = @()
foreach ($script in $uploadScripts) {
    if (Test-Path $script) {
        $uploadCount++
        $foundScripts += $script
    } elseif (Test-Path "C:\Users\Thinkpad\.openclaw\workspace\$script") {
        $uploadCount++
        $foundScripts += $script
    }
}
Write-Host "  Upload scripts: $uploadCount/$($uploadScripts.Count) available" -ForegroundColor $(if ($uploadCount -eq $uploadScripts.Count) { "Green" } else { "Yellow" })
if ($foundScripts.Count -gt 0) {
    Write-Host "  Found: $($foundScripts -join ', ')" -ForegroundColor Gray
}

# Check for files scheduled for upload
$filesToUpload = Get-ChildItem -Path "." -File | Where-Object { $_.Name -match "\.(txt|md|json|yaml|yml|ps1|bat)$" -and $_.Length -lt 100KB } | Select-Object -First 10
Write-Host "  Files ready for upload: $($filesToUpload.Count)" -ForegroundColor $(if ($filesToUpload.Count -gt 0) { "Cyan" } else { "Gray" })

Write-Host ""

# 4. Notion Action Items Status (from SESSION-STATE.md)
Write-Host "📊 NOTION ACTION ITEMS" -ForegroundColor Yellow
if (Test-Path "SESSION-STATE.md") {
    $content = Get-Content "SESSION-STATE.md" -Raw
    if ($content -match "## Notion Action Items Status \(Critical Issue\)([\s\S]*?)##") {
        $notionSection = $matches[1]
        if ($notionSection -match "With Status.*?:.*?0") {
            Write-Host "  ⚠️ CRITICAL: No items have Status fields set" -ForegroundColor Red
        }
        if ($notionSection -match "Overdue.*?:.*?(\d+)") {
            Write-Host "  Overdue items: $($matches[1])" -ForegroundColor $(if ($matches[1] -gt 0) { "Red" } else { "Green" })
        }
        if ($notionSection -match "Total Items.*?:.*?(\d+)") {
            Write-Host "  Total items: $($matches[1])" -ForegroundColor Gray
        }
        if ($notionSection -match "Blocked.*?:.*?(Cannot determine|.*?)") {
            Write-Host "  Blocked status: $($matches[1])" -ForegroundColor $(if ($matches[1] -match "Cannot determine") { "Yellow" } else { "Gray" })
        }
    } else {
        Write-Host "  ℹ️ No Notion status found in SESSION-STATE.md" -ForegroundColor Gray
    }
}

Write-Host ""

# 5. Agent Collaboration Status
Write-Host "🤖 AGENT COLLABORATION" -ForegroundColor Yellow
if (Test-Path "SESSION-STATE.md") {
    $content = Get-Content "SESSION-STATE.md" -Raw
    if ($content -match "## Agent Collaboration Status([\s\S]*?)##") {
        $agentSection = $matches[1]
        if ($agentSection -match "Tested Roles.*?:.*?(\d+)/\d+") {
            Write-Host "  Tested roles: $($matches[1])" -ForegroundColor $(if ($matches[1] -ge 4) { "Green" } else { "Yellow" })
        }
        if ($agentSection -match "Success Rate.*?:.*?(\d+)%") {
            Write-Host "  Success rate: $($matches[1])%" -ForegroundColor $(if ($matches[1] -eq 100) { "Green" } else { "Yellow" })
        }
        if ($agentSection -match "Average Task Time.*?:.*?(.*)") {
            Write-Host "  Avg task time: $($matches[1])" -ForegroundColor Gray
        }
    } else {
        Write-Host "  ℹ️ No Agent status found in SESSION-STATE.md" -ForegroundColor Gray
    }
}

Write-Host ""

# 6. PM Role Status
Write-Host "👨‍💼 PM ROLE STATUS" -ForegroundColor Yellow
Write-Host "  Role: Strategic Analyst (Non-executive)" -ForegroundColor Cyan
Write-Host "  Focus: Planning, Monitoring, Risk Management" -ForegroundColor Cyan
Write-Host "  Mode: Automated checks + Event triggers" -ForegroundColor Cyan

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "     RUN: openclaw cron list (check tasks)" -ForegroundColor Gray
Write-Host "=========================================" -ForegroundColor Cyan