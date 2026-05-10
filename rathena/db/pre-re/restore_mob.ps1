$monster = @"
  - Id: 3501
    AegisName: MUTANT_THIEF_BUG
    Name: Mutant Male Bug
    Level: 30
    Hp: 7560
    BaseExp: 100
    JobExp: 100
    Attack: 50
    Attack2: 120
    Defense: 5
    MagicDefense: 5
    Str: 10
    Agi: 10
    Vit: 10
    Int: 55
    Dex: 10
    Luk: 10
    AttackRange: 1
    SkillRange: 10
    ChaseRange: 12
    Size: Large
    Race: Insect
    Element: Shadow
    ElementLevel: 1
    WalkSpeed: 100
    AttackDelay: 1500
    AttackMotion: 500
    ClientAttackMotion: 400
    DamageMotion: 300
    Ai: 13
    Drops:
      - Item: Accessory_Box
        Rate: 10000
      - Item: ora3000
        Rate: 1000
      - Item: Gift_Box
        Rate: 1000
      - Item: Dead_Branch
        Rate: 500
        StealProtected: true
"@
Add-Content -Path "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\mob_db.yml" -Value "`n$monster"
