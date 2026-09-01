$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$filePreReSkill = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\mob_skill_db.txt"

$skillLines = @(
    "// Abomination of Souls (Mob 3484 - Custom Reworked Kit with Slaves: 3x Zombie Guard 3452, 1x Fallen Crusader 2434, 1x Lost Knight 2415)",
    "3484,Abomination of Souls@NPC_SUMMONSLAVE,idle,196,5,10000,0,0,no,self,onspawn,0,3452,3452,3452,2434,2415,,",
    "3484,Abomination of Souls@NPC_SUMMONSLAVE,attack,196,5,5000,1000,15000,no,self,slavele,1,3452,3452,3452,2434,2415,,",
    "3484,Abomination of Souls@NPC_SUMMONSLAVE,idle,196,5,5000,1000,15000,no,self,slavele,1,3452,3452,3452,2434,2415,,",
    "3484,Abomination of Souls@NPC_COMBOATTACK,attack,171,5,1500,0,4000,yes,target,always,0,,,,,,,",
    "3484,Abomination of Souls@NPC_CRITICALSLASH,attack,170,5,2000,0,5000,yes,target,always,0,,,,,,,",
    "3484,Abomination of Souls@NPC_CRITICALWOUND,attack,673,4,2000,0,8000,yes,target,always,0,,,,,,,",
    "3484,Abomination of Souls@NPC_POISONATTACK,attack,188,5,3000,500,8000,no,target,always,0,,,,,,47,",
    "3484,Abomination of Souls@ASC_METEORASSAULT,attack,406,5,4000,500,6000,no,self,attackpcge,3,,,,,,,",
    "3484,Abomination of Souls@ASC_BREAKER,attack,379,1,2500,800,7000,no,randomtarget,always,0,,,,,,,",
    "3484,Abomination of Souls@NPC_WIDEBLEEDING,attack,665,4,2000,500,15000,no,self,always,0,,,,,,47,",
    "3484,Abomination of Souls@NPC_POWERUP,attack,349,1,2000,0,120000,yes,self,myhpltmaxrate,30,,,,,,19,",
    "3484,Abomination of Souls@NPC_AGIUP,attack,350,1,2000,0,120000,yes,self,myhpltmaxrate,30,,,,,,19,"
)

$linesPre = Get-Content -Path $filePreReSkill
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
[System.IO.File]::WriteAllLines($filePreReSkill, $newLinesPre, $utf8NoBom)
Write-Host "Removed MH_POISON_MIST from 3484 in db/pre-re/mob_skill_db.txt!"
