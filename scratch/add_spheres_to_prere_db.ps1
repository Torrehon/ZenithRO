$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$prePath = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_etc.yml"
$preText = [System.IO.File]::ReadAllText($prePath)

$spheresBlock = @"
  - Id: 13223
    AegisName: Flare_Sphere_
    Name: Flare Sphere
    Type: Ammo
    SubType: Grenade
    Buy: 15
    Weight: 5
    Attack: 50
    Classes:
      All: false
    Locations:
      Ammo: true
  - Id: 13224
    AegisName: Lighting_Sphere_
    Name: Lightning Sphere
    Type: Ammo
    SubType: Grenade
    Buy: 15
    Weight: 5
    Attack: 50
    Classes:
      All: false
    Locations:
      Ammo: true
  - Id: 13225
    AegisName: Poison_Sphere_
    Name: Poison Sphere
    Type: Ammo
    SubType: Grenade
    Buy: 15
    Weight: 5
    Attack: 50
    Classes:
      All: false
    Locations:
      Ammo: true
  - Id: 13226
    AegisName: Blind_Sphere_
    Name: Blind Sphere
    Type: Ammo
    SubType: Grenade
    Buy: 15
    Weight: 5
    Attack: 50
    Classes:
      All: false
    Locations:
      Ammo: true
  - Id: 13227
    AegisName: Freezing_Sphere_
    Name: Freezing Sphere
    Type: Ammo
    SubType: Grenade
    Buy: 15
    Weight: 5
    Attack: 50
    Classes:
      All: false
    Locations:
      Ammo: true
"@

if (-not $preText.Contains("13223")) {
    $newPreText = $preText.TrimEnd() + "`n" + $spheresBlock + "`n"
    [System.IO.File]::WriteAllText($prePath, $newPreText, $utf8NoBom)
    Write-Host "Added Renewal Grenade Spheres (13223-13227) into pre-re/item_db_etc.yml!"
} else {
    Write-Host "Spheres 13223-13227 already in pre-re/item_db_etc.yml"
}
