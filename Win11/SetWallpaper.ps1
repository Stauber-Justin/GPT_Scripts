# PowerShell-Skript zum Setzen eines Hintergrundbilds für einen einzelnen Monitor unter Windows 11
# Direkte Manipulation der Windows-Registry

# Pfad zum Hintergrundbild (aus dem Netzwerk)
$Bild1 = "C:\Users\Numbo\Pictures\Bild1.jpg"

# Prüfen, ob die Datei existiert
if (!(Test-Path $Bild1)) { 
    Write-Output "Fehler: Bild nicht gefunden! ($Bild1)"
    exit
}

# Anzahl der Monitore abrufen
$MonitorCount = (Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams).Count
Write-Output "Gefundene Monitore: $MonitorCount"

# Registry für individuelles Hintergrundbild bearbeiten
Write-Output "Setze Hintergrundbild..."
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -Value $Bild1
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "TranscodedImageCache" -Value $Bild1
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -Value "10"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "TileWallpaper" -Value "0"

# Windows dazu zwingen, die Registry neu zu laden
Write-Output "Aktualisiere Registry..."
Start-Sleep -Seconds 1

# SystemParametersInfo aufrufen, um die Änderung zu übernehmen
Write-Output "Übernehme Änderungen mit SystemParametersInfo..."
if (-not ([System.Management.Automation.PSTypeName]'Wallpaper').Type) {
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@
}

[Wallpaper]::SystemParametersInfo(20, 0, $Bild1, 3)

# Desktop zusätzlich refreshen (Alternative Methode)
Write-Output "Erzwinge Desktop-Aktualisierung..."
Start-Sleep -Seconds 2  # Warten, um sicherzustellen, dass Explorer gestartet ist
$signature = @"
using System;
using System.Runtime.InteropServices;
public class RefreshDesktop {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr SendMessage(IntPtr hWnd, int Msg, IntPtr wParam, IntPtr lParam);
}
"@
Add-Type $signature
[IntPtr]$HWND_BROADCAST = [IntPtr]0xffff
$WM_SETTINGCHANGE = 0x001A
[RefreshDesktop]::SendMessage($HWND_BROADCAST, $WM_SETTINGCHANGE, [IntPtr]0, [IntPtr]0)

Write-Output "Hintergrundbild erfolgreich geändert!"
