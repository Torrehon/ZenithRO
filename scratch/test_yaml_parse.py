import sys

with open("rathena/db/pre-re/quest_db.yml", "rb") as f:
    content = f.read()

# Check for tabs
for i, line in enumerate(content.splitlines(), 1):
    if b"\t" in line:
        print(f"Line {i} contains TAB character!")

print(f"Total lines: {len(content.splitlines())}")
