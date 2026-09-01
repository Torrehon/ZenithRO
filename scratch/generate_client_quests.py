import sys

prt_mobs = [
    (70001, "Poring", 25),
    (70002, "Lunatic", 25),
    (70003, "Thief Bug", 25),
    (70004, "Rocker", 25),
    (70005, "Tarou", 25),
    (70006, "Poporing", 25),
    (70007, "Mandragora", 25),
    (70008, "Vadon", 20),
    (70009, "Yoyo", 20),
    (70010, "Cornutus", 20),
    (70011, "Marc", 15),
    (70012, "Swordfish", 15),
    (70013, "Merman", 15),
    (70014, "Strouf", 15),
    (70015, "Deviace", 15),
    (70016, "Lost Knight", 15),
    (70017, "Fallen Crusader", 15),
    (70018, "Zombie Guard", 15),
    (70019, "Mastering", 1),
    (70020, "Vocal", 1),
    (70021, "Eclipse", 1),
]

gef_mobs = [
    (70101, "Fabre", 25),
    (70102, "Roda Frog", 25),
    (70103, "Ambernite", 25),
    (70104, "Coco", 20),
    (70105, "Orc Warrior", 20),
    (70106, "Orc Lady", 20),
    (70107, "Caramel", 20),
    (70108, "Orc Skeleton", 20),
    (70109, "Zenorc", 20),
    (70110, "Skeleton Worker", 20),
    (70111, "Myst", 20),
    (70112, "Nightmare", 15),
    (70113, "Jakk", 15),
    (70114, "Deviruchi", 15),
    (70115, "High Orc", 15),
    (70116, "Raydric", 15),
    (70117, "Evil Druid", 15),
    (70118, "Sting", 15),
    (70119, "Abysmal Knight", 10),
    (70120, "Toad", 1),
    (70121, "Pouring", 1),
]

moc_mobs = [
    (70201, "Picky", 25),
    (70202, "Baby Desert Wolf", 25),
    (70203, "Drops", 25),
    (70204, "Muka", 25),
    (70205, "Peco Peco", 20),
    (70206, "Zerom", 20),
    (70207, "Requiem", 20),
    (70208, "Hode", 20),
    (70209, "Frilldora", 20),
    (70210, "Mummy", 20),
    (70211, "Verit", 20),
    (70212, "Marduk", 15),
    (70213, "Pasana", 15),
    (70214, "Minorous", 15),
    (70215, "Isis", 15),
    (70216, "Anubis", 10),
    (70217, "Ancient Mummy", 10),
    (70218, "Dragon Fly", 1),
]

pay_mobs = [
    (70301, "Willow", 25),
    (70302, "Spore", 25),
    (70303, "Familiar", 25),
    (70304, "Zombie", 25),
    (70305, "Skeleton", 25),
    (70306, "Wolf", 20),
    (70307, "Bigfoot", 20),
    (70308, "Munak", 20),
    (70309, "Bongun", 20),
    (70310, "Sohee", 20),
    (70311, "Archer Skeleton", 20),
    (70312, "Dokebi", 20),
    (70313, "Nine Tail", 15),
    (70314, "Dragon Tail", 15),
    (70315, "Skeleton General", 10),
    (70316, "Vagabond Wolf", 1),
]

cities = [
    ("Prontera", prt_mobs),
    ("Geffen", gef_mobs),
    ("Morroc", moc_mobs),
    ("Payon", pay_mobs),
]

# Generate OngoingQuests_C.lub lines
lub_lines = []
for city_name, mobs in cities:
    lub_lines.append(f"\t-- {city_name} Hunting Quests")
    for qid, mob_name, count in mobs:
        lub_lines.append(f"\t[{qid}] = {{")
        lub_lines.append(f'\t\tTitle = "{city_name} Hunt: {mob_name}",')
        lub_lines.append(f'\t\tDescription = {{')
        lub_lines.append(f'\t\t\t"Hunt down {count} {mob_name}s to complete the contract",')
        lub_lines.append(f'\t\t\t"and claim your {city_name} Coins."')
        lub_lines.append(f'\t\t}},')
        lub_lines.append(f'\t\tSummary = "Hunt {count} {mob_name}.",')
        lub_lines.append(f'\t\tHunt1 = "{mob_name}",')
        lub_lines.append(f'\t\tNpcName = "Hunting Board",')
        lub_lines.append(f'\t}},')

with open("scratch/lub_output.txt", "w", encoding="utf-8") as f:
    f.write("\n".join(lub_lines) + "\n")

# Generate questid2display.txt lines
txt_lines = []
for city_name, mobs in cities:
    txt_lines.append(f"// {city_name} Hunting Quests")
    for qid, mob_name, count in mobs:
        txt_lines.append(f"{qid}#{city_name} Hunt: {mob_name}#SG_FEEL#QUE_NOIMAGE#")
        txt_lines.append(f"Hunt down {count} {mob_name}s to complete the contract.#")
        txt_lines.append("#")
        txt_lines.append("")

with open("scratch/txt_output.txt", "w", encoding="utf-8") as f:
    f.write("\n".join(txt_lines) + "\n")

print("Generated successfully!")
