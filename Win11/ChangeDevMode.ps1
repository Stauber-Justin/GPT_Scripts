# Pruefen, ob das Skript mit Admin-Rechten läuft
$adminCheck = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $adminCheck.IsInRole($adminRole)) {
    # Starte das Skript mit Admin-Rechten neu
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Registrierungswert setzen
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Appx"
$registryName = "AllowDevelopmentWithoutDevLicense"
$registryValue = 1

# Ueberpruefen, ob der Schluessel existiert, andernfalls erstellen
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Setzt den Wert auf 1 (REG_DWORD)
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord

Write-Output "Der Wert wurde erfolgreich gesetzt!"
