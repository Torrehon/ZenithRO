$itemFiles = @(
    "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_etc.yml",
    "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_usable.yml",
    "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_equipment.yml",
    "d:\SERVER_RO\LevitationRO\rathena\db\re\item_db_etc.yml",
    "d:\SERVER_RO\LevitationRO\rathena\db\import\item_db.yml",
    "d:\SERVER_RO\LevitationRO\rathena\db\import\item_db_etc.yml"
)

$ammoList = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($file in $itemFiles) {
    if (Test-Path $file) {
        Write-Host "Scanning $file ..."
        $lines = Get-Content -Path $file
        $currentId = 0
        $currentAegis = ""
        $currentName = ""
        $currentType = ""
        $currentSubType = ""
        $currentBuy = 0

        for ($i = 0; $i -lt $lines.Length; $i++) {
            $line = $lines[$i]
            if ($line -match "^\s*-\s*Id:\s*(\d+)") {
                if ($currentId -ne 0 -and ($currentType -eq "Ammo" -or $currentSubType -eq "Bullet" -or $currentSubType -eq "Grenade" -or $currentAegis -match "Bullet|Grenade|Sphere|Shell|Cannon|Mortar|Cartridge|Capsule")) {
                    $ammoList.Add([PSCustomObject]@{
                        Id = $currentId
                        AegisName = $currentAegis
                        Name = $currentName
                        Type = $currentType
                        SubType = $currentSubType
                        Buy = $currentBuy
                        File = $file
                    })
                }
                $currentId = [int]$matches[1]
                $currentAegis = ""
                $currentName = ""
                $currentType = ""
                $currentSubType = ""
                $currentBuy = 0
            }
            if ($line -match "AegisName:\s*(.+)") { $currentAegis = $matches[1].Trim() }
            if ($line -match "Name:\s*(.+)") { $currentName = $matches[1].Trim() }
            if ($line -match "Type:\s*(.+)") { $currentType = $matches[1].Trim() }
            if ($line -match "SubType:\s*(.+)") { $currentSubType = $matches[1].Trim() }
            if ($line -match "Buy:\s*(\d+)") { $currentBuy = [int]$matches[1] }
        }
        if ($currentId -ne 0 -and ($currentType -eq "Ammo" -or $currentSubType -eq "Bullet" -or $currentSubType -eq "Grenade" -or $currentAegis -match "Bullet|Grenade|Sphere|Shell|Cannon|Mortar|Cartridge|Capsule")) {
            $ammoList.Add([PSCustomObject]@{
                Id = $currentId
                AegisName = $currentAegis
                Name = $currentName
                Type = $currentType
                SubType = $currentSubType
                Buy = $currentBuy
                File = $file
            })
        }
    }
}

Write-Host "`n=== ALL FOUND AMMO / BULLETS / GRENADES ==="
$ammoList | Sort-Object -Property Id -Unique | ForEach-Object {
    Write-Host "ID: $($_.Id) | Aegis: $($_.AegisName) | Name: $($_.Name) | Type: $($_.Type) | SubType: $($_.SubType) | Buy: $($_.Buy) Zeny | File: $($_.File)"
}
