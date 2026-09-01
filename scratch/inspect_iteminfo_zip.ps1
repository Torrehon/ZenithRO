Add-Type -AssemblyName System.IO.Compression.FileSystem

$zipPath = "D:\SERVER_RO\PARA CLIENTE PRE-RENEWAL\System\itemInfo.zip"
if (Test-Path $zipPath) {
    $zip = [System.IO.Compression.ZipFile]::OpenRead($zipPath)
    foreach ($entry in $zip.Entries) {
        Write-Host "Zip entry: $($entry.FullName) - Size: $($entry.Length) bytes"
    }
    $zip.Dispose()
}
