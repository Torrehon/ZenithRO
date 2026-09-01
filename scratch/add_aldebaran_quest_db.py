import os

quest_db_path = r"d:\SERVER_RO\LevitationRO\rathena\db\pre-re\quest_db.yml"

aldebaran_quests_yaml = """  - Id: 70401
    Title: "Aldebaran Hunt: Thief Bug Female"
    Targets:
      - Mob: THIEF_BUG_
        Count: 25
  - Id: 70402
    Title: "Aldebaran Hunt: Dustiness"
    Targets:
      - Mob: DUSTINESS
        Count: 25
  - Id: 70403
    Title: "Aldebaran Hunt: Argos"
    Targets:
      - Mob: ARGOS
        Count: 25
  - Id: 70404
    Title: "Aldebaran Hunt: Flora"
    Targets:
      - Mob: FLORA
        Count: 25
  - Id: 70405
    Title: "Aldebaran Hunt: Stem Worm"
    Targets:
      - Mob: STEM_WORM
        Count: 20
  - Id: 70406
    Title: "Aldebaran Hunt: Argiope"
    Targets:
      - Mob: ARGIOPE
        Count: 20
  - Id: 70407
    Title: "Aldebaran Hunt: Earth Petite"
    Targets:
      - Mob: PETIT
        Count: 20
  - Id: 70408
    Title: "Aldebaran Hunt: Bathory"
    Targets:
      - Mob: BATHORY
        Count: 20
  - Id: 70409
    Title: "Aldebaran Hunt: Punk"
    Targets:
      - Mob: PUNK
        Count: 20
  - Id: 70410
    Title: "Aldebaran Hunt: Grand Peco"
    Targets:
      - Mob: GRAND_PECO
        Count: 15
  - Id: 70411
    Title: "Aldebaran Hunt: Rideword"
    Targets:
      - Mob: RIDEWORD
        Count: 15
  - Id: 70412
    Title: "Aldebaran Hunt: Alarm"
    Targets:
      - Mob: ALARM
        Count: 15
  - Id: 70413
    Title: "Aldebaran Hunt: Clock"
    Targets:
      - Mob: CLOCK
        Count: 15
"""

with open(quest_db_path, "rb") as f:
    content = f.read().decode("utf-8")

# Ensure content ends with pure LF
content = content.replace("\r\n", "\n")

# Check if 70401 already exists
if "Id: 70401" not in content:
    content = content.rstrip() + "\n" + aldebaran_quests_yaml

# Write back as pure UTF-8 without BOM, UNIX LF
with open(quest_db_path, "wb") as f:
    f.write(content.encode("utf-8"))

print("quest_db.yml updated cleanly with Aldebaran hunting quests!")
