$files = @(
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_C.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub"
)

foreach ($f in $files) {
    Write-Host "=== Checking $f ==="
    $diff = git diff $f
    Write-Host "Git diff lines: $(($diff | Measure-Object -Line).Lines)"
}
