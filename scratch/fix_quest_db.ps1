$mobMap = @{
    1002 = "PORING"
    1063 = "LUNATIC"
    1051 = "THIEF_BUG"
    1052 = "ROCKER"
    1175 = "TAROU"
    1031 = "POPORING"
    1020 = "MANDRAGORA"
    1066 = "VADON"
    1057 = "YOYO"
    1067 = "CORNUTUS"
    1045 = "MARC"
    1069 = "SWORD_FISH"
    1264 = "MERMAN"
    1065 = "STROUF"
    1108 = "DEVIACE"
    2415 = "L_SEYREN"
    2434 = "G_L_YGNIZEM"
    3452 = "ZOMBIE_GUARD"
    1090 = "Mastering"
    1088 = "VOCAL"
    1093 = "ECLIPSE"

    1007 = "FABRE"
    1012 = "RODA_FROG"
    1094 = "AMBERNITE"
    1104 = "COCO"
    1023 = "ORK_WARRIOR"
    1273 = "ORC_LADY"
    1103 = "CARAMEL"
    1152 = "ORC_SKELETON"
    1177 = "ZENORC"
    1169 = "SKEL_WORKER"
    1151 = "MYST"
    1061 = "NIGHTMARE"
    1130 = "JAKK"
    1109 = "DEVIRUCHI"
    1213 = "HIGH_ORC"
    1163 = "RAYDRIC"
    1117 = "EVIL_DRUID"
    1207 = "STING"
    1219 = "KNIGHT_OF_ABYSS"
    1089 = "TOAD"
    25001 = "C_POURING"

    1049 = "PICKY"
    1107 = "DESERT_WOLF_B"
    1113 = "DROPS"
    1055 = "MUKA"
    1019 = "PECOPECO"
    1178 = "ZEROM"
    1164 = "REQUIEM"
    1127 = "HODE"
    1119 = "FRILLDORA"
    1041 = "MUMMY"
    1032 = "VERIT"
    1140 = "MARDUK"
    1154 = "PASANA"
    1149 = "MINOROUS"
    1029 = "ISIS"
    1098 = "ANUBIS"
    1297 = "ANCIENT_MUMMY"
    1091 = "DRAGON_FLY"

    1010 = "WILOW"
    1014 = "SPORE"
    1005 = "FARMILIAR"
    1015 = "ZOMBIE"
    1076 = "SKELETON"
    1013 = "WOLF"
    1060 = "BIGFOOT"
    1026 = "MUNAK"
    1188 = "BON_GUN"
    1170 = "SOHEE"
    1016 = "ARCHER_SKELETON"
    1110 = "DOKEBI"
    1180 = "NINE_TAIL"
    1321 = "DRAGON_TAIL"
    1290 = "SKELETON_GENERAL"
    1092 = "VAGABOND_WOLF"
}

$prt_mobs = @(
    @{ qid=70001; name="Poring"; mobid=1002; count=25 },
    @{ qid=70002; name="Lunatic"; mobid=1063; count=25 },
    @{ qid=70003; name="Thief Bug"; mobid=1051; count=25 },
    @{ qid=70004; name="Rocker"; mobid=1052; count=25 },
    @{ qid=70005; name="Tarou"; mobid=1175; count=25 },
    @{ qid=70006; name="Poporing"; mobid=1031; count=25 },
    @{ qid=70007; name="Mandragora"; mobid=1020; count=25 },
    @{ qid=70008; name="Vadon"; mobid=1066; count=20 },
    @{ qid=70009; name="Yoyo"; mobid=1057; count=20 },
    @{ qid=70010; name="Cornutus"; mobid=1067; count=20 },
    @{ qid=70011; name="Marc"; mobid=1045; count=15 },
    @{ qid=70012; name="Swordfish"; mobid=1069; count=15 },
    @{ qid=70013; name="Merman"; mobid=1264; count=15 },
    @{ qid=70014; name="Strouf"; mobid=1065; count=15 },
    @{ qid=70015; name="Deviace"; mobid=1108; count=15 },
    @{ qid=70016; name="Lost Knight"; mobid=2415; count=15 },
    @{ qid=70017; name="Fallen Crusader"; mobid=2434; count=15 },
    @{ qid=70018; name="Zombie Guard"; mobid=3452; count=15 },
    @{ qid=70019; name="Mastering"; mobid=1090; count=1 },
    @{ qid=70020; name="Vocal"; mobid=1088; count=1 },
    @{ qid=70021; name="Eclipse"; mobid=1093; count=1 }
)

$gef_mobs = @(
    @{ qid=70101; name="Fabre"; mobid=1007; count=25 },
    @{ qid=70102; name="Roda Frog"; mobid=1012; count=25 },
    @{ qid=70103; name="Ambernite"; mobid=1094; count=25 },
    @{ qid=70104; name="Coco"; mobid=1104; count=20 },
    @{ qid=70105; name="Orc Warrior"; mobid=1023; count=20 },
    @{ qid=70106; name="Orc Lady"; mobid=1273; count=20 },
    @{ qid=70107; name="Caramel"; mobid=1103; count=20 },
    @{ qid=70108; name="Orc Skeleton"; mobid=1152; count=20 },
    @{ qid=70109; name="Zenorc"; mobid=1177; count=20 },
    @{ qid=70110; name="Skeleton Worker"; mobid=1169; count=20 },
    @{ qid=70111; name="Myst"; mobid=1151; count=20 },
    @{ qid=70112; name="Nightmare"; mobid=1061; count=15 },
    @{ qid=70113; name="Jakk"; mobid=1130; count=15 },
    @{ qid=70114; name="Deviruchi"; mobid=1109; count=15 },
    @{ qid=70115; name="High Orc"; mobid=1213; count=15 },
    @{ qid=70116; name="Raydric"; mobid=1163; count=15 },
    @{ qid=70117; name="Evil Druid"; mobid=1117; count=15 },
    @{ qid=70118; name="Sting"; mobid=1207; count=15 },
    @{ qid=70119; name="Abysmal Knight"; mobid=1219; count=10 },
    @{ qid=70120; name="Toad"; mobid=1089; count=1 },
    @{ qid=70121; name="Pouring"; mobid=25001; count=1 }
)

$moc_mobs = @(
    @{ qid=70201; name="Picky"; mobid=1049; count=25 },
    @{ qid=70202; name="Baby Desert Wolf"; mobid=1107; count=25 },
    @{ qid=70203; name="Drops"; mobid=1113; count=25 },
    @{ qid=70204; name="Muka"; mobid=1055; count=25 },
    @{ qid=70205; name="Peco Peco"; mobid=1019; count=20 },
    @{ qid=70206; name="Zerom"; mobid=1178; count=20 },
    @{ qid=70207; name="Requiem"; mobid=1164; count=20 },
    @{ qid=70208; name="Hode"; mobid=1127; count=20 },
    @{ qid=70209; name="Frilldora"; mobid=1119; count=20 },
    @{ qid=70210; name="Mummy"; mobid=1041; count=20 },
    @{ qid=70211; name="Verit"; mobid=1032; count=20 },
    @{ qid=70212; name="Marduk"; mobid=1140; count=15 },
    @{ qid=70213; name="Pasana"; mobid=1154; count=15 },
    @{ qid=70214; name="Minorous"; mobid=1149; count=15 },
    @{ qid=70215; name="Isis"; mobid=1029; count=15 },
    @{ qid=70216; name="Anubis"; mobid=1098; count=10 },
    @{ qid=70217; name="Ancient Mummy"; mobid=1297; count=10 },
    @{ qid=70218; name="Dragon Fly"; mobid=1091; count=1 }
)

$pay_mobs = @(
    @{ qid=70301; name="Willow"; mobid=1010; count=25 },
    @{ qid=70302; name="Spore"; mobid=1014; count=25 },
    @{ qid=70303; name="Familiar"; mobid=1005; count=25 },
    @{ qid=70304; name="Zombie"; mobid=1015; count=25 },
    @{ qid=70305; name="Skeleton"; mobid=1076; count=25 },
    @{ qid=70306; name="Wolf"; mobid=1013; count=20 },
    @{ qid=70307; name="Bigfoot"; mobid=1060; count=20 },
    @{ qid=70308; name="Munak"; mobid=1026; count=20 },
    @{ qid=70309; name="Bongun"; mobid=1188; count=20 },
    @{ qid=70310; name="Sohee"; mobid=1170; count=20 },
    @{ qid=70311; name="Archer Skeleton"; mobid=1016; count=20 },
    @{ qid=70312; name="Dokebi"; mobid=1110; count=20 },
    @{ qid=70313; name="Nine Tail"; mobid=1180; count=15 },
    @{ qid=70314; name="Dragon Tail"; mobid=1321; count=15 },
    @{ qid=70315; name="Skeleton General"; mobid=1290; count=10 },
    @{ qid=70316; name="Vagabond Wolf"; mobid=1092; count=1 }
)

$cities = @(
    @{ name="Prontera"; mobs=$prt_mobs },
    @{ name="Geffen"; mobs=$gef_mobs },
    @{ name="Morroc"; mobs=$moc_mobs },
    @{ name="Payon"; mobs=$pay_mobs }
)

$lines = [System.Collections.Generic.List[string]]::new()

foreach ($city in $cities) {
    $cname = $city.name
    foreach ($m in $city.mobs) {
        $qid = $m.qid
        $mname = $m.name
        $cnt = $m.count
        $aegis = $mobMap[$m.mobid]

        $lines.Add("  - Id: $qid")
        $lines.Add("    Title: `"$cname Hunt: $mname`"")
        $lines.Add("    Targets:")
        $lines.Add("      - Mob: $aegis")
        $lines.Add("        Count: $cnt")
    }
}

$questDbPath = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\quest_db.yml"
$questDbContent = Get-Content -Path $questDbPath -Raw -Encoding UTF8

$splitMarker = "  - Id: 70001"
if ($questDbContent.Contains($splitMarker)) {
    $baseContent = $questDbContent.Substring(0, $questDbContent.IndexOf($splitMarker))
    $newContent = $baseContent + ($lines -join "`n") + "`n"
    Set-Content -Path $questDbPath -Value $newContent -Encoding UTF8
    Write-Host "quest_db.yml updated with AegisNames successfully!"
} else {
    Write-Host "Split marker not found!"
}
