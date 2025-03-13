Set objShell = CreateObject("WScript.Shell")
objShell.Run "powershell.exe -ExecutionPolicy Bypass -File C:\Users\Numbo\Scripts\MountDevDrive.ps1", 0, False
Set objShell = Nothing