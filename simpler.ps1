Write-Host "=== Optimizing Windows for Mendix VM ===" -ForegroundColor Cyan

# -----------------------------
# Disable heavy services
# -----------------------------
$services = @(
"SysMain",
"WSearch",
"DoSvc",
"XblAuthManager",
"XblGameSave",
"XboxGipSvc",
"XboxNetApiSvc"
)

foreach ($svc in $services) {
    Write-Host "Disabling service: $svc"
    Stop-Service $svc -Force -ErrorAction SilentlyContinue
    Set-Service $svc -StartupType Disabled -ErrorAction SilentlyContinue
}

# -----------------------------
# Disable transparency
# -----------------------------
Write-Host "Disabling transparency..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
-Name "EnableTransparency" -Value 0 -PropertyType DWord -Force | Out-Null

# -----------------------------
# Disable animations
# -----------------------------
Write-Host "Setting performance visual effects..."
Set-ItemProperty `
-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" `
-Name "VisualFXSetting" -Value 2

# -----------------------------
# Disable background apps
# -----------------------------
Write-Host "Disabling background apps..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" `
/v GlobalUserDisabled /t REG_DWORD /d 1 /f | Out-Null

# -----------------------------
# Disable Widgets
# -----------------------------
Write-Host "Disabling widgets..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
/v TaskbarDa /t REG_DWORD /d 0 /f | Out-Null

# -----------------------------
# Disable search web integration
# -----------------------------
Write-Host "Disabling web search..."
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" `
/v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f | Out-Null

# -----------------------------
# Remove Web Experience Pack
# -----------------------------
Write-Host "Removing Windows Web Experience Pack..."
Get-AppxPackage *WebExperience* | Remove-AppxPackage -ErrorAction SilentlyContinue

# -----------------------------
# Defender exclusions (modify to your own)
# -----------------------------
Write-Host "Adding Defender exclusions..."
Add-MpPreference -ExclusionPath "C:\projects" -ErrorAction SilentlyContinue

# -----------------------------
# Disable Defender realtime (optional but helpful)
# -----------------------------
Write-Host "Disabling Defender realtime scanning..."
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue

# -----------------------------
# Disable tips & suggestions
# -----------------------------
Write-Host "Disabling tips..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
/v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f | Out-Null

Write-Host "=== Optimization Complete. Please reboot. ===" -ForegroundColor Green