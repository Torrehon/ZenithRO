$diff = git diff rathena/db/pre-re/quest_db.yml
Set-Content -Path "scratch/quest_db_diff.txt" -Value $diff -Encoding UTF8
Write-Host "Git diff length: $($diff.Length)"
