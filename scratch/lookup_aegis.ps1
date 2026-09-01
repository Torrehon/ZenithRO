$mobDbPath = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\mob_db.yml"
$lines = Get-Content -Path $mobDbPath

$idToAegis = @{}
$currentId = $null

foreach ($line in $lines) {
    if ($line -match "^\s*-\s*Id:\s*(\d+)") {
        $currentId = [int]$matches[1]
    }
    elseif ($currentId -and $line -match "^\s*AegisName:\s*([^\s#]+)") {
        $idToAegis[$currentId] = $matches[1]
        $currentId = $null
    }
}

$targetIds = @(
    1002, 1063, 1051, 1052, 1175, 1031, 1020, 1066, 1057, 1067, 1045, 1069, 1264, 1065, 1108, 2415, 2434, 3452, 1090, 1088, 1093,
    1007, 1012, 1094, 1104, 1023, 1273, 1103, 1152, 1177, 1169, 1151, 1061, 1130, 1109, 1213, 1163, 1117, 1207, 1219, 1089, 25001,
    1049, 1107, 1113, 1055, 1019, 1178, 1164, 1127, 1119, 1041, 1032, 1140, 1154, 1149, 1029, 1098, 1297, 1091,
    1010, 1014, 1005, 1015, 1076, 1013, 1060, 1026, 1188, 1170, 1016, 1110, 1180, 1321, 1290, 1092
)

foreach ($id in $targetIds) {
    if ($idToAegis.ContainsKey($id)) {
        Write-Host "$id -> $($idToAegis[$id])"
    } else {
        Write-Host "$id -> NOT FOUND"
    }
}
