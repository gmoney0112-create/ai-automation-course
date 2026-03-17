@echo off
echo 🚀 Deploying Modern Success Page...

REM Step 1: Replace old success.html with modern version
echo Updating success.html with modern design...
copy success_modern.html success.html /Y >nul

REM Step 2: Check if we're in the right place
echo Checking directory...
dir success.html

echo.
echo ✅ Modern success page ready!
echo.
echo 📋 To deploy:
echo 1. Go to: https://github.com/gmoney0112-create/ai-automation-course
echo 2. Click "Add file" -> "Upload files"
echo 3. Drag and drop success.html
echo 4. Click "Commit changes"
echo.
echo 🔧 Then update Stripe success URL to:
echo https://gmoney0112-create.github.io/ai-automation-course/success.html
echo.
pause