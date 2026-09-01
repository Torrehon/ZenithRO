import sys

# Let's inspect the entire quest_db.yml line by line for any syntax issue
path = "rathena/db/pre-re/quest_db.yml"

with open(path, "r", encoding="utf-8", errors="replace") as f:
    lines = f.readlines()

print(f"Total lines: {len(lines)}")

# Let's check for:
# 1. Invalid indentation (odd space counts like 1, 3, 5 spaces)
# 2. Tabs
# 3. Duplicate keys or weird syntax
# 4. Lines with trailing spaces or colon issues

for idx, line in enumerate(lines, 1):
    # Strip line ending
    raw = line.rstrip("\r\n")
    if not raw.strip():
        continue
    
    # Count leading spaces
    leading_spaces = len(raw) - len(raw.lstrip(" "))
    if "\t" in raw:
        print(f"Line {idx}: TAB detected -> {repr(raw)}")
    
    if leading_spaces % 2 != 0:
        print(f"Line {idx}: Odd indentation ({leading_spaces} spaces) -> {repr(raw)}")

print("Indentation check done.")
