$dbPath = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\skill_db.yml"

Select-String -Path $dbPath -Pattern "Id:\s*1041" -Context 0,15
