$lubPath = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_C.lub"
$lubText = Get-Content -Path $lubPath -Raw -Encoding UTF8
$lubAdd = Get-Content -Path "scratch/lub_output.txt" -Raw -Encoding UTF8

if ($lubText -match "\n}\s*$") {
    $newLub = $lubText -replace "\n}\s*$", ("`n`n" + $lubAdd + "`n}`n")
    Set-Content -Path $lubPath -Value $newLub -Encoding UTF8
    Write-Host "OngoingQuests_C.lub updated successfully!"
} else {
    Write-Host "Pattern match failed for OngoingQuests_C.lub"
}

$txtPath = "d:\SERVER_RO\LevitationRO\ZenithRO\data\questid2display.txt"
$txtAdd = Get-Content -Path "scratch/txt_output.txt" -Raw -Encoding UTF8
Add-Content -Path $txtPath -Value ("`n`n" + $txtAdd) -Encoding UTF8
Write-Host "questid2display.txt updated successfully!"
