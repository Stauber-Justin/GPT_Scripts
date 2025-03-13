# Pruefen, ob das Skript mit Admin-Rechten lÃ¤uft
$adminCheck = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $adminCheck.IsInRole($adminRole)) {
    # Starte das Skript mit Admin-Rechten neu
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Festlegen des Pfades zur VHDX-Datei (bitte hier den korrekten Pfad eintragen)
$VHDPath = "E:\Virtual HDD\DevHome.vhdx"

try {
    # Versuchen, die VHDX-Datei einzubinden
    Mount-VHD -Path $VHDPath -ErrorAction Stop | Out-Null
    # Optional: Erfolgsmeldung (diese Ausgabe wird in einer Silent-Background-Ausführung nicht angezeigt)
    Write-Output "VHDX wurde erfolgreich eingebunden."
}
catch {
    # Fehlerbehandlung: Gibt eine Fehlermeldung aus, falls etwas schiefgeht
    Write-Error "Fehler beim Einbinden der VHDX: $_"
}
