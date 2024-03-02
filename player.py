import json

# Generate the initial dictionary structure
levels = {}
for i in range(100):
    level_key = f"level_{i}_complete"
    score_key = f"level_{i}_score"
    stars_key = f"level_{i}_stars"
    levels[level_key] = False
    levels[score_key] = 0
    levels[stars_key] = 0

# Write the dictionary to a JSON file
with open("data.json", "w") as f:
    json.dump(levels, f, indent=4)
