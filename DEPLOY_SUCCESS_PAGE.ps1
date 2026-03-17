# DEPLOY SUCCESS PAGE SCRIPT
# Run this in PowerShell as Administrator

Write-Host "🚀 Deploying success.html to GitHub..." -ForegroundColor Green

# Step 1: Navigate to the directory
cd C:\temp\ai-course-deploy

# Step 2: Initialize git if not already done
if (!(Test-Path .git)) {
    Write-Host "Initializing git repository..." -ForegroundColor Yellow
    git init
}

# Step 3: Add all files
Write-Host "Adding files to git..." -ForegroundColor Yellow
git add .

# Step 4: Commit changes
Write-Host "Committing changes..." -ForegroundColor Yellow
git commit -m "Add success page with real contact info"

# Step 5: Add remote origin (if not already added)
Write-Host "Checking remote origin..." -ForegroundColor Yellow
$remote = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Adding remote origin..." -ForegroundColor Yellow
    git remote add origin https://github.com/gmoney0112-create/ai-automation-course.git
}

# Step 6: Push to GitHub
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
git branch -M main
git push -u origin main --force

Write-Host "✅ Success page deployed!" -ForegroundColor Green
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "1. Update Stripe payment link success URL:" -ForegroundColor White
Write-Host "   https://gmoney0112-create.github.io/ai-automation-course/success.html" -ForegroundColor Yellow
Write-Host "2. Test the complete flow:" -ForegroundColor White
Write-Host "   https://gmoney0112-create.github.io/ai-automation-course/" -ForegroundColor Yellow
Write-Host "3. Create Discord server (10 min)" -ForegroundColor White
Write-Host "4. Set up Google Drive folder for course materials" -ForegroundColor White
Write-Host "5. Configure email automation" -ForegroundColor White