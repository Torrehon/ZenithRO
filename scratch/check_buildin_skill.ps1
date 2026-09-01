Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Select-String -Path "script.cpp" -Pattern "BUILDIN_FUNC\(skill\)" -Context 0,25
