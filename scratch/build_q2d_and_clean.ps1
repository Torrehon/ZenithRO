$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# Build complete clean questid2display.txt
$q2dPath = "d:\SERVER_RO\LevitationRO\ZenithRO\data\questid2display.txt"
$q2dText = [System.IO.File]::ReadAllText($q2dPath)

$q2dMarker = "70001#Prontera Hunt: Poring"
if ($q2dText.Contains($q2dMarker)) {
    $firstIdx = $q2dText.IndexOf($q2dMarker)
    $cleanQ2d = $q2dText.Substring(0, $firstIdx).TrimEnd()

    # Re-generate custom block for 70001 to 70413
    $customLines = [System.Collections.Generic.List[string]]::new()
    
    # Prontera
    $customLines.Add("70001#Prontera Hunt: Poring#SG_FEEL#Que_god#Hunt 25 Poring.#")
    $customLines.Add("70002#Prontera Hunt: Lunatic#SG_FEEL#Que_god#Hunt 25 Lunatic.#")
    $customLines.Add("70003#Prontera Hunt: Thief Bug#SG_FEEL#Que_god#Hunt 25 Thief Bug.#")
    $customLines.Add("70004#Prontera Hunt: Rocker#SG_FEEL#Que_god#Hunt 25 Rocker.#")
    $customLines.Add("70005#Prontera Hunt: Tarou#SG_FEEL#Que_god#Hunt 25 Tarou.#")
    $customLines.Add("70006#Prontera Hunt: Poporing#SG_FEEL#Que_god#Hunt 25 Poporing.#")
    $customLines.Add("70007#Prontera Hunt: Mandragora#SG_FEEL#Que_god#Hunt 25 Mandragora.#")
    $customLines.Add("70008#Prontera Hunt: Vadon#SG_FEEL#Que_god#Hunt 20 Vadon.#")
    $customLines.Add("70009#Prontera Hunt: Yoyo#SG_FEEL#Que_god#Hunt 20 Yoyo.#")
    $customLines.Add("70010#Prontera Hunt: Cornutus#SG_FEEL#Que_god#Hunt 20 Cornutus.#")
    $customLines.Add("70011#Prontera Hunt: Marc#SG_FEEL#Que_god#Hunt 15 Marc.#")
    $customLines.Add("70012#Prontera Hunt: Swordfish#SG_FEEL#Que_god#Hunt 15 Swordfish.#")
    $customLines.Add("70013#Prontera Hunt: Merman#SG_FEEL#Que_god#Hunt 15 Merman.#")
    $customLines.Add("70014#Prontera Hunt: Strouf#SG_FEEL#Que_god#Hunt 15 Strouf.#")
    $customLines.Add("70015#Prontera Hunt: Deviace#SG_FEEL#Que_god#Hunt 15 Deviace.#")
    $customLines.Add("70016#Prontera Hunt: Lost Knight#SG_FEEL#Que_god#Hunt 15 Lost Knight.#")
    $customLines.Add("70017#Prontera Hunt: Fallen Crusader#SG_FEEL#Que_god#Hunt 15 Fallen Crusader.#")
    $customLines.Add("70018#Prontera Hunt: Zombie Guard#SG_FEEL#Que_god#Hunt 15 Zombie Guard.#")
    $customLines.Add("70019#Prontera Hunt: Mastering#SG_FEEL#Que_god#Hunt 1 Mastering.#")
    $customLines.Add("70020#Prontera Hunt: Vocal#SG_FEEL#Que_god#Hunt 1 Vocal.#")
    $customLines.Add("70021#Prontera Hunt: Eclipse#SG_FEEL#Que_god#Hunt 1 Eclipse.#")

    # Geffen
    $customLines.Add("70101#Geffen Hunt: Fabre#SG_FEEL#Que_god#Hunt 25 Fabre.#")
    $customLines.Add("70102#Geffen Hunt: Chonchon#SG_FEEL#Que_god#Hunt 25 Chonchon.#")
    $customLines.Add("70103#Geffen Hunt: Rodda Frog#SG_FEEL#Que_god#Hunt 25 Rodda Frog.#")
    $customLines.Add("70104#Geffen Hunt: Poison Spore#SG_FEEL#Que_god#Hunt 25 Poison Spore.#")
    $customLines.Add("70105#Geffen Hunt: Ambernite#SG_FEEL#Que_god#Hunt 25 Ambernite.#")
    $customLines.Add("70106#Geffen Hunt: Coco#SG_FEEL#Que_god#Hunt 25 Coco.#")
    $customLines.Add("70107#Geffen Hunt: Caramel#SG_FEEL#Que_god#Hunt 25 Caramel.#")
    $customLines.Add("70108#Geffen Hunt: Goblin#SG_FEEL#Que_god#Hunt 20 Goblin.#")
    $customLines.Add("70109#Geffen Hunt: Bigfoot#SG_FEEL#Que_god#Hunt 20 Bigfoot.#")
    $customLines.Add("70110#Geffen Hunt: Horn#SG_FEEL#Que_god#Hunt 20 Horn.#")
    $customLines.Add("70111#Geffen Hunt: Orc Warrior#SG_FEEL#Que_god#Hunt 20 Orc Warrior.#")
    $customLines.Add("70112#Geffen Hunt: Orc Zombie#SG_FEEL#Que_god#Hunt 20 Orc Zombie.#")
    $customLines.Add("70113#Geffen Hunt: Orc Skeleton#SG_FEEL#Que_god#Hunt 20 Orc Skeleton.#")
    $customLines.Add("70114#Geffen Hunt: Ghoul#SG_FEEL#Que_god#Hunt 15 Ghoul.#")
    $customLines.Add("70115#Geffen Hunt: Nightmare#SG_FEEL#Que_god#Hunt 15 Nightmare.#")
    $customLines.Add("70116#Geffen Hunt: Deviruchi#SG_FEEL#Que_god#Hunt 15 Deviruchi.#")
    $customLines.Add("70117#Geffen Hunt: Baphomet Jr.#SG_FEEL#Que_god#Hunt 15 Baphomet Jr..#")
    $customLines.Add("70118#Geffen Hunt: Wraith#SG_FEEL#Que_god#Hunt 15 Wraith.#")
    $customLines.Add("70119#Geffen Hunt: Dragon Fly#SG_FEEL#Que_god#Hunt 1 Dragon Fly.#")
    $customLines.Add("70120#Geffen Hunt: Vagabond Wolf#SG_FEEL#Que_god#Hunt 1 Vagabond Wolf.#")
    $customLines.Add("70121#Geffen Hunt: Ghostring#SG_FEEL#Que_god#Hunt 1 Ghostring.#")

    # Morroc
    $customLines.Add("70201#Morroc Hunt: Condor#SG_FEEL#Que_god#Hunt 25 Condor.#")
    $customLines.Add("70202#Morroc Hunt: Pickicky#SG_FEEL#Que_god#Hunt 25 Pickicky.#")
    $customLines.Add("70203#Morroc Hunt: Dromader#SG_FEEL#Que_god#Hunt 25 Dromader.#")
    $customLines.Add("70204#Morroc Hunt: Peco Peco#SG_FEEL#Que_god#Hunt 25 Peco Peco.#")
    $customLines.Add("70205#Morroc Hunt: Mukuka#SG_FEEL#Que_god#Hunt 25 Mukuka.#")
    $customLines.Add("70206#Morroc Hunt: Hode#SG_FEEL#Que_god#Hunt 25 Hode.#")
    $customLines.Add("70207#Morroc Hunt: Metaller#SG_FEEL#Que_god#Hunt 25 Metaller.#")
    $customLines.Add("70208#Morroc Hunt: Desert Wolf Baby#SG_FEEL#Que_god#Hunt 20 Desert Wolf Baby.#")
    $customLines.Add("70209#Morroc Hunt: Frilldora#SG_FEEL#Que_god#Hunt 20 Frilldora.#")
    $customLines.Add("70210#Morroc Hunt: Sandman#SG_FEEL#Que_god#Hunt 20 Sandman.#")
    $customLines.Add("70211#Morroc Hunt: Golem#SG_FEEL#Que_god#Hunt 20 Golem.#")
    $customLines.Add("70212#Morroc Hunt: Mummy#SG_FEEL#Que_god#Hunt 15 Mummy.#")
    $customLines.Add("70213#Morroc Hunt: Verit#SG_FEEL#Que_god#Hunt 15 Verit.#")
    $customLines.Add("70214#Morroc Hunt: Matyr#SG_FEEL#Que_god#Hunt 15 Matyr.#")
    $customLines.Add("70215#Morroc Hunt: Minorous#SG_FEEL#Que_god#Hunt 15 Minorous.#")
    $customLines.Add("70216#Morroc Hunt: Pasana#SG_FEEL#Que_god#Hunt 15 Pasana.#")
    $customLines.Add("70217#Morroc Hunt: Anubis#SG_FEEL#Que_god#Hunt 15 Anubis.#")
    $customLines.Add("70218#Morroc Hunt: Strouf#SG_FEEL#Que_god#Hunt 15 Strouf.#")

    # Payon
    $customLines.Add("70301#Payon Hunt: Willow#SG_FEEL#Que_god#Hunt 25 Willow.#")
    $customLines.Add("70302#Payon Hunt: Spore#SG_FEEL#Que_god#Hunt 25 Spore.#")
    $customLines.Add("70303#Payon Hunt: Boa#SG_FEEL#Que_god#Hunt 25 Boa.#")
    $customLines.Add("70304#Payon Hunt: Wormtail#SG_FEEL#Que_god#Hunt 25 Wormtail.#")
    $customLines.Add("70305#Payon Hunt: Zombie#SG_FEEL#Que_god#Hunt 25 Zombie.#")
    $customLines.Add("70306#Payon Hunt: Skeleton#SG_FEEL#Que_god#Hunt 25 Skeleton.#")
    $customLines.Add("70307#Payon Hunt: Mandragora#SG_FEEL#Que_god#Hunt 25 Mandragora.#")
    $customLines.Add("70308#Payon Hunt: Eggyra#SG_FEEL#Que_god#Hunt 20 Eggyra.#")
    $customLines.Add("70309#Payon Hunt: Munak#SG_FEEL#Que_god#Hunt 20 Munak.#")
    $customLines.Add("70310#Payon Hunt: Bongun#SG_FEEL#Que_god#Hunt 20 Bongun.#")
    $customLines.Add("70311#Payon Hunt: Soldier Skeleton#SG_FEEL#Que_god#Hunt 20 Soldier Skeleton.#")
    $customLines.Add("70312#Payon Hunt: Archer Skeleton#SG_FEEL#Que_god#Hunt 20 Archer Skeleton.#")
    $customLines.Add("70313#Payon Hunt: Nine Tail#SG_FEEL#Que_god#Hunt 15 Nine Tail.#")
    $customLines.Add("70314#Payon Hunt: Dragon Tail#SG_FEEL#Que_god#Hunt 15 Dragon Tail.#")
    $customLines.Add("70315#Payon Hunt: Skeleton General#SG_FEEL#Que_god#Hunt 15 Skeleton General.#")
    $customLines.Add("70316#Payon Hunt: Vagabond Wolf#SG_FEEL#Que_god#Hunt 1 Vagabond Wolf.#")

    # Aldebaran
    $customLines.Add("70401#Aldebaran Hunt: Thief Bug Female#SG_FEEL#Que_god#Hunt 25 Thief Bug Female.#")
    $customLines.Add("70402#Aldebaran Hunt: Dustiness#SG_FEEL#Que_god#Hunt 25 Dustiness.#")
    $customLines.Add("70403#Aldebaran Hunt: Argos#SG_FEEL#Que_god#Hunt 25 Argos.#")
    $customLines.Add("70404#Aldebaran Hunt: Flora#SG_FEEL#Que_god#Hunt 25 Flora.#")
    $customLines.Add("70405#Aldebaran Hunt: Stem Worm#SG_FEEL#Que_god#Hunt 20 Stem Worm.#")
    $customLines.Add("70406#Aldebaran Hunt: Argiope#SG_FEEL#Que_god#Hunt 20 Argiope.#")
    $customLines.Add("70407#Aldebaran Hunt: Earth Petite#SG_FEEL#Que_god#Hunt 20 Earth Petite.#")
    $customLines.Add("70408#Aldebaran Hunt: Bathory#SG_FEEL#Que_god#Hunt 20 Bathory.#")
    $customLines.Add("70409#Aldebaran Hunt: Punk#SG_FEEL#Que_god#Hunt 20 Punk.#")
    $customLines.Add("70410#Aldebaran Hunt: Grand Peco#SG_FEEL#Que_god#Hunt 15 Grand Peco.#")
    $customLines.Add("70411#Aldebaran Hunt: Rideword#SG_FEEL#Que_god#Hunt 15 Rideword.#")
    $customLines.Add("70412#Aldebaran Hunt: Alarm#SG_FEEL#Que_god#Hunt 15 Alarm.#")
    $customLines.Add("70413#Aldebaran Hunt: Clock#SG_FEEL#Que_god#Hunt 15 Clock.#")

    $customStr = $customLines -join "`r`n"
    $finalQ2d = $cleanQ2d + "`r`n" + $customStr + "`r`n"
    [System.IO.File]::WriteAllText($q2dPath, $finalQ2d, $utf8NoBom)
    Write-Host "Cleaned questid2display.txt with exact 1-copy custom entries!"
}
