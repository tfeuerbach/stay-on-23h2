# stay-on-23h2.ps1
# Prevents Windows 11 from upgrading beyond version 23H2 by configuring Windows Update policies in the registry.

param(
    [switch]$elevated  # Used to track if the script is already running in elevated mode (admin)
)

# --- Elevation Check and Relaunch ---
# If not already elevated, relaunch the script as Administrator using PowerShell's Start-Process
if (-not $elevated) {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrator")) {
        Write-Host "Elevation required. Relaunching as Administrator..."
        $argList = "-ExecutionPolicy Bypass -File `"$PSCommandPath`" -elevated"
        Start-Process powershell -ArgumentList $argList -Verb RunAs
        exit
    }
}

# --- Define Registry Target ---
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$trvName = "TargetReleaseVersion"
$trvInfoName = "TargetReleaseVersionInfo"
$expectedVersion = "23H2"

# --- Create Registry Key If Missing ---
# This ensures the WindowsUpdate policy key exists before trying to modify its values
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# --- Read Current Registry Values (if they exist) ---
$currentTRV = Get-ItemProperty -Path $regPath -Name $trvName -ErrorAction SilentlyContinue
$currentInfo = Get-ItemProperty -Path $regPath -Name $trvInfoName -ErrorAction SilentlyContinue

# --- Check if the policy is already set to hold at 23H2 ---
if ($currentTRV.$trvName -eq 1 -and $currentInfo.$trvInfoName -eq $expectedVersion) {
    Write-Host "`nSystem is already configured to stay on Windows 11 $expectedVersion."

    # Prompt the user if they want to undo the lock
    $response = Read-Host "Do you want to remove this setting and allow updates beyond $expectedVersion? (yes/no)"
    if ($response.Trim().ToLower() -eq "yes") {
        # Remove the registry values to allow updates again
        Remove-ItemProperty -Path $regPath -Name $trvName -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $regPath -Name $trvInfoName -ErrorAction SilentlyContinue
        Write-Host "Settings reverted. System can now receive future feature updates."
    }
    else {
        Write-Host "No changes made."
    }
}
else {
    # --- Apply Registry Settings to Hold at 23H2 ---
    # These keys tell Windows Update to stop at version 23H2 and not offer newer feature updates
    Set-ItemProperty -Path $regPath -Name $trvName -Value 1 -Type DWord
    Set-ItemProperty -Path $regPath -Name $trvInfoName -Value $expectedVersion -Type String

    # Output confirmation
    Write-Host "`nRegistry keys set to stay on Windows 11 ${expectedVersion}:"
    Write-Host "  $trvName = 1"
    Write-Host "  $trvInfoName = $expectedVersion"
}

# --- Script Complete ---
Write-Host "`nDone."
Pause  # Keeps the window open so the user can read the final output
