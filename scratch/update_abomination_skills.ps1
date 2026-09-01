$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$filePreRe = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\mob_skill_db.txt"
$fileRe = "d:\SERVER_RO\LevitationRO\rathena\db\re\mob_skill_db.txt"

# 1. Read existing lines and replace 3484 lines in pre-re
$linesPre = Get-Content -Path $filePreRe
$newLinesPre = @()

$has3484 = $false
foreach ($line in $linesPre) {
    if ($line.StartsWith("3484,")) {
        if (-not $has3484) {
            $has3484 = $true
            $newLinesPre += "// Abomination of Souls (Mob 3484 - Custom Reworked Kit)"
            $newLinesPre += "3484,Abomination of Souls@NPC_COMBOATTACK,attack,171,5,1500,0,4000,yes,target,always,0,,,,,,,"
            $newLinesPre += "3484,Abomination of Souls@NPC_CRITICALSLASH,attack,170,5,2000,0,5000,yes,target,always,0,,,,,,,"
            $newLinesPre += "3484,Abomination of Souls@NPC_CRITICALWOUND,attack,673,4,2000,0,8000,yes,target,always,0,,,,,,,"
            $newLinesPre += "3484,Abomination of Souls@NPC_WIDEPOISON,attack,664,5,3000,500,12000,no,self,always,0,,,,,,47,"
            $newLinesPre += "3484,Abomination of Souls@ASC_METEORASSAULT,attack,383,5,4000,500,6000,no,self,attackpcge,3,,,,,,,"
            $newLinesPre += "3484,Abomination of Souls@ASC_SOULBREAKER,attack,381,5,2500,800,7000,no,randomtarget,always,0,,,,,,,"
            $newLinesPre += "3484,Abomination of Souls@NPC_WIDEBLEEDING,attack,665,4,2000,500,15000,no,self,always,0,,,,,,47,"
            $newLinesPre += "3484,Abomination of Souls@NPC_POWERUP,attack,349,1,2000,0,120000,yes,self,myhpltmaxrate,30,,,,,,19,"
            $newLinesPre += "3484,Abomination of Souls@NPC_AGIUP,attack,350,1,2000,0,120000,yes,self,myhpltmaxrate,30,,,,,,19,"
        }
    } else {
        $newLinesPre += $line
    }
}

[System.IO.File]::WriteAllLines($filePreRe, $newLinesPre, $utf8NoBom)
Write-Host "Updated db/pre-re/mob_skill_db.txt successfully!"

# 2. Also check if 3484 is in re/mob_skill_db.txt
if (Test-Path $fileRe) {
    $linesRe = Get-Content -Path $fileRe
    $newLinesRe = @()
    $has3484Re = $false
    foreach ($line in $linesRe) {
        if ($line.StartsWith("3484,")) {
            if (-not $has3484Re) {
                $has3484Re = $true
                $newLinesRe += "// Abomination of Souls (Mob 3484 - Custom Reworked Kit)"
                $newLinesRe += "3484,Abomination of Souls@NPC_COMBOATTACK,attack,171,5,1500,0,4000,yes,target,always,0,,,,,,,"
                $newLinesRe += "3484,Abomination of Souls@NPC_CRITICALSLASH,attack,170,5,2000,0,5000,yes,target,always,0,,,,,,,"
                $newLinesRe += "3484,Abomination of Souls@NPC_CRITICALWOUND,attack,673,4,2000,0,8000,yes,target,always,0,,,,,,,"
                $newLinesRe += "3484,Abomination of Souls@NPC_WIDEPOISON,attack,664,5,3000,500,12000,no,self,always,0,,,,,,47,"
                $newLinesRe += "3484,Abomination of Souls@ASC_METEORASSAULT,attack,383,5,4000,500,6000,no,self,attackpcge,3,,,,,,,"
                $newLinesRe += "3484,Abomination of Souls@ASC_SOULBREAKER,attack,381,5,2500,800,7000,no,randomtarget,always,0,,,,,,,"
                $newLinesRe += "3484,Abomination of Souls@NPC_WIDEBLEEDING,attack,665,4,2000,500,15000,no,self,always,0,,,,,,47,"
                $newLinesRe += "3484,Abomination of Souls@NPC_POWERUP,attack,349,1,2000,0,120000,yes,self,myhpltmaxrate,30,,,,,,19,"
                $newLinesRe += "3484,Abomination of Souls@NPC_AGIUP,attack,350,1,2000,0,120000,yes,self,myhpltmaxrate,30,,,,,,19,"
            }
        } else {
            $newLinesRe += $line
        }
    }
    [System.IO.File]::WriteAllLines($fileRe, $newLinesRe, $utf8NoBom)
    Write-Host "Updated db/re/mob_skill_db.txt successfully!"
}
