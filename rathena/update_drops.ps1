$f = 'd:\SERVER_RO\LevitationRO\rathena\db\pre-re\mob_db.yml'
$lines = Get-Content $f
$newDrops = @(
'      - Id: 12106',
'        Rate: 10000',
'      - Id: 60000',
'        Rate: 1000',
'        StealProtected: true',
'      - Id: 644',
'        Rate: 1000',
'      - Id: 604',
'        Rate: 500'
)
$before = $lines[0..57799]
$after = $lines[57805..($lines.Length-1)]
$final = $before + $newDrops + $after
$final | Set-Content $f
Write-Host "Botin actualizado con exito!"
