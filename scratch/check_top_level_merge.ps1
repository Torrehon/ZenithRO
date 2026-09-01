$qf = "d:\SERVER_RO\LevitationRO\ZenithRO\data\luafiles514\lua files\datainfo\questinfo_f.lub"
Get-Content -Path $qf -Head 60 | ForEach-Object { Write-Host $_ }
