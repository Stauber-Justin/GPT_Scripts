# How to use the script:
# .\OutputFiles_Complete.ps1 E:\Path\To\Files "cpp" | Set-Clipboard
# FilePathFromScript FilePathFromFiles "datatype" | OutputToClipboard

param
(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$FolderPath,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Extension
)

# Check if the provided folder path exists
if (-not (Test-Path -Path $FolderPath))
{
    Write-Error "The folder path '$FolderPath' does not exist."
    exit
}

# Ensure the extension starts with a dot. (E.g. "txt" becomes ".txt")
if ($Extension[0] -ne '.')
{
    $Extension = '.' + $Extension
}

# Create a search pattern. For example, if extension is ".txt", pattern becomes "*.txt"
$pattern = "*$Extension"

# Retrieve all files (recursively) that match the pattern
Get-ChildItem -Path $FolderPath -Recurse -Filter $pattern -File | ForEach-Object
{
    # Output the file's full name
    Write-Output "File Name: $($_.FullName)"
    Write-Output "--------------------------------------"

    # Output the file's content
    try
    {
        Get-Content -Path $_.FullName | ForEach-Object { Write-Output $_ }
    }
    catch
    {
        Write-Warning "Could not read file: $($_.FullName)"
    }

        Write-Output "======================================="
}