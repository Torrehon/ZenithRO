$prt_mobs = @(
    @{ qid=70001; name="Poring"; count=25 },
    @{ qid=70002; name="Lunatic"; count=25 },
    @{ qid=70003; name="Thief Bug"; count=25 },
    @{ qid=70004; name="Rocker"; count=25 },
    @{ qid=70005; name="Tarou"; count=25 },
    @{ qid=70006; name="Poporing"; count=25 },
    @{ qid=70007; name="Mandragora"; count=25 },
    @{ qid=70008; name="Vadon"; count=20 },
    @{ qid=70009; name="Yoyo"; count=20 },
    @{ qid=70010; name="Cornutus"; count=20 },
    @{ qid=70011; name="Marc"; count=15 },
    @{ qid=70012; name="Swordfish"; count=15 },
    @{ qid=70013; name="Merman"; count=15 },
    @{ qid=70014; name="Strouf"; count=15 },
    @{ qid=70015; name="Deviace"; count=15 },
    @{ qid=70016; name="Lost Knight"; count=15 },
    @{ qid=70017; name="Fallen Crusader"; count=15 },
    @{ qid=70018; name="Zombie Guard"; count=15 },
    @{ qid=70019; name="Mastering"; count=1 },
    @{ qid=70020; name="Vocal"; count=1 },
    @{ qid=70021; name="Eclipse"; count=1 }
)

$gef_mobs = @(
    @{ qid=70101; name="Fabre"; count=25 },
    @{ qid=70102; name="Roda Frog"; count=25 },
    @{ qid=70103; name="Ambernite"; count=25 },
    @{ qid=70104; name="Coco"; count=20 },
    @{ qid=70105; name="Orc Warrior"; count=20 },
    @{ qid=70106; name="Orc Lady"; count=20 },
    @{ qid=70107; name="Caramel"; count=20 },
    @{ qid=70108; name="Orc Skeleton"; count=20 },
    @{ qid=70109; name="Zenorc"; count=20 },
    @{ qid=70110; name="Skeleton Worker"; count=20 },
    @{ qid=70111; name="Myst"; count=20 },
    @{ qid=70112; name="Nightmare"; count=15 },
    @{ qid=70113; name="Jakk"; count=15 },
    @{ qid=70114; name="Deviruchi"; count=15 },
    @{ qid=70115; name="High Orc"; count=15 },
    @{ qid=70116; name="Raydric"; count=15 },
    @{ qid=70117; name="Evil Druid"; count=15 },
    @{ qid=70118; name="Sting"; count=15 },
    @{ qid=70119; name="Abysmal Knight"; count=10 },
    @{ qid=70120; name="Toad"; count=1 },
    @{ qid=70121; name="Pouring"; count=1 }
)

$moc_mobs = @(
    @{ qid=70201; name="Picky"; count=25 },
    @{ qid=70202; name="Baby Desert Wolf"; count=25 },
    @{ qid=70203; name="Drops"; count=25 },
    @{ qid=70204; name="Muka"; count=25 },
    @{ qid=70205; name="Peco Peco"; count=20 },
    @{ qid=70206; name="Zerom"; count=20 },
    @{ qid=70207; name="Requiem"; count=20 },
    @{ qid=70208; name="Hode"; count=20 },
    @{ qid=70209; name="Frilldora"; count=20 },
    @{ qid=70210; name="Mummy"; count=20 },
    @{ qid=70211; name="Verit"; count=20 },
    @{ qid=70212; name="Marduk"; count=15 },
    @{ qid=70213; name="Pasana"; count=15 },
    @{ qid=70214; name="Minorous"; count=15 },
    @{ qid=70215; name="Isis"; count=15 },
    @{ qid=70216; name="Anubis"; count=10 },
    @{ qid=70217; name="Ancient Mummy"; count=10 },
    @{ qid=70218; name="Dragon Fly"; count=1 }
)

$pay_mobs = @(
    @{ qid=70301; name="Willow"; count=25 },
    @{ qid=70302; name="Spore"; count=25 },
    @{ qid=70303; name="Familiar"; count=25 },
    @{ qid=70304; name="Zombie"; count=25 },
    @{ qid=70305; name="Skeleton"; count=25 },
    @{ qid=70306; name="Wolf"; count=20 },
    @{ qid=70307; name="Bigfoot"; count=20 },
    @{ qid=70308; name="Munak"; count=20 },
    @{ qid=70309; name="Bongun"; count=20 },
    @{ qid=70310; name="Sohee"; count=20 },
    @{ qid=70311; name="Archer Skeleton"; count=20 },
    @{ qid=70312; name="Dokebi"; count=20 },
    @{ qid=70313; name="Nine Tail"; count=15 },
    @{ qid=70314; name="Dragon Tail"; count=15 },
    @{ qid=70315; name="Skeleton General"; count=10 },
    @{ qid=70316; name="Vagabond Wolf"; count=1 }
)

$cities = @(
    @{ name="Prontera"; mobs=$prt_mobs },
    @{ name="Geffen"; mobs=$gef_mobs },
    @{ name="Morroc"; mobs=$moc_mobs },
    @{ name="Payon"; mobs=$pay_mobs }
)

$lub_lines = [System.Collections.Generic.List[string]]::new()
$txt_lines = [System.Collections.Generic.List[string]]::new()

foreach ($city in $cities) {
    $cname = $city.name
    $lub_lines.Add("`t-- $cname Hunting Quests")
    $txt_lines.Add("// $cname Hunting Quests")

    foreach ($m in $city.mobs) {
        $qid = $m.qid
        $mname = $m.name
        $cnt = $m.count

        $lub_lines.Add("`t[$qid] = {")
        $lub_lines.Add("`t`tTitle = `"$cname Hunt: $mname`",")
        $lub_lines.Add("`t`tDescription = {")
        $lub_lines.Add("`t`t`t`"Hunt down $cnt ${mname}s to complete the contract`",")
        $lub_lines.Add("`t`t`t`"and claim your $cname Coins.`"")
        $lub_lines.Add("`t`t},")
        $lub_lines.Add("`t`tSummary = `"Hunt $cnt $mname.`",")
        $lub_lines.Add("`t`tHunt1 = `"$mname`",")
        $lub_lines.Add("`t`tNpcName = `"Hunting Board`",")
        $lub_lines.Add("`t},")

        $txt_lines.Add("${qid}#${cname} Hunt: ${mname}#SG_FEEL#QUE_NOIMAGE#")
        $txt_lines.Add("Hunt down $cnt ${mname}s to complete the contract.#")
        $txt_lines.Add("#")
        $txt_lines.Add("")
    }
}

Set-Content -Path "scratch/lub_output.txt" -Value $lub_lines -Encoding UTF8
Set-Content -Path "scratch/txt_output.txt" -Value $txt_lines -Encoding UTF8
Write-Host "PS Generated successfully!"
