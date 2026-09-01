$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$filePreRe = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\mob_skill_db.txt"
$fileRe = "d:\SERVER_RO\LevitationRO\rathena\db\re\mob_skill_db.txt"

$skillLines = @(
    "// Abomination of Souls (Mob 3484 - Custom Reworked Kit with Verified Skill IDs)",
    "3484,Abomination of Souls@NPC_COMBOATTACK,attack,171,5,1500,0,4000,yes,target,always,0,,,,,,,",
    "3484,Abomination of Souls@NPC_CRITICALSLASH,attack,170,5,2000,0,5000,yes,target,always,0,,,,,,,",
    "3484,Abomination of Souls@NPC_CRITICALWOUND,attack,673,4,2000,0,8000,yes,target,always,0,,,,,,,",
    "3484,Abomination of Souls@NPC_POISONATTACK,attack,188,5,3000,500,8000,no,target,always,0,,,,,,47,",
    "3484,Abomination of Souls@MH_POISON_MIST,attack,8020,1,4000,500,10000,no,target,always,0,,,,,,,",
    "3484,Abomination of Souls@ASC_METEORASSAULT,attack,406,5,4000,500,6000,no,self,attackpcge,3,,,,,,,",
    "3484,Abomination of Souls@ASC_BREAKER,attack,379,5,2500,800,7000,no,randomtarget,always,0,,,,,,,",
    "3484,Abomination of Souls@NPC_WIDEBLEEDING,attack,665,4,2000,500,15000,no,self,always,0,,,,,,47,",
    "3484,Abomination of Souls@NPC_POWERUP,attack,349,1,2000,0,120000,yes,self,myhpltmaxrate,30,,,,,,19,",
    "3484,Abomination of Souls@NPC_AGIUP,attack,350,1,2000,0,120000,yes,self,myhpltmaxrate,30,,,,,,19,"
)

# 1. Update pre-re
$linesPre = Get-Content -Path $filePreRe
$newLinesPre = @()
$has3484 = $false
foreach ($line in $linesPre) {
    if ($line.StartsWith("3484,") -or $line.Contains("Abomination of Souls")) {
        if (-not $has3484) {
            $has3484 = $true
            foreach ($sl in $skillLines) { $newLinesPre += $sl }
        }
    } else {
        $newLinesPre += $line
    }
}
[System.IO.File]::WriteAllLines($filePreRe, $newLinesPre, $utf8NoBom)
Write-Host "Updated db/pre-re/mob_skill_db.txt with MH_POISON_MIST (8020) Lv 1!"

# 2. Update re
if (Test-Path $fileRe) {
    $linesRe = Get-Content -Path $fileRe
    $newLinesRe = @()
    $has3484Re = $false
    foreach ($line in $linesRe) {
        if ($line.StartsWith("3484,") -or $line.Contains("Abomination of Souls")) {
            if (-not $has3484Re) {
                $has3484Re = $true
                foreach ($sl in $skillLines) { $newLinesRe += $sl }
            }
        } else {
            $newLinesRe += $line
        }
    }
    [System.IO.File]::WriteAllLines($fileRe, $newLinesRe, $utf8NoBom)
    Write-Host "Updated db/re/mob_skill_db.txt with MH_POISON_MIST (8020) Lv 1!"
}
