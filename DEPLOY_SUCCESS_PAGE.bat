@echo off
echo 🚀 Deploying success.html to GitHub...

REM Step 1: Navigate to the directory
cd /d C:\temp\ai-course-deploy

REM Step 2: Initialize git if not already done
if not exist ".git" (
    echo Initializing git repository...
    git init
)

REM Step 3: Add all files
echo Adding files to git...
git add .

REM Step 4: Commit changes
echo Committing changes...
git commit -m "Add success page with real contact info"

REM Step 5: Add remote origin (if not already added)
echo Checking remote origin...
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo Adding remote origin...
    git remote add origin https://github.com/gmoney0112-create/ai-automation-course.git
)

REM Step 6: Push to GitHub
echo Pushing to GitHub...
git branch -M main
git push -u origin main --force

echo ✅ Success page deployed!
echo.
echo 📋 Next steps:
echo 1. Update Stripe payment link success URL:
echo    https://gmoney0112-create.github.io/ai-automation-course/success.html
echo 2. Test the complete flow:
echo    https://gmoney0112-create.github.io/ai-automation-course/
echo 3. Create Discord server (10 min)
echo 4. Set up Google Drive folder for course materials
echo 5. Configure email automation
pause