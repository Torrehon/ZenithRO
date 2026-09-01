Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Select-String -Path "pc.hpp" -Pattern "enum e_addskill_type" -Context 0,10
