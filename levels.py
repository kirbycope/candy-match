import json
import random

def generate_data():
    data = []
    generated_items = set()  # Track generated items

    for i in range(100):  # Adjust the range as needed
        # Generate a unique key for each item
        while True:
            key = (
                random.randint(1, 5),  # character_id
                random.randint(1, 5),  # item_id
                random.randint(3, 12)  # quantity
            )
            if key not in generated_items:
                generated_items.add(key)
                break

        item = {
            "id": i,
            "about": "Level {}".format(i),
            "customer1": {
                "character_id": key[0],
                "item_id": key[1],
                "quantity": key[2]
            },
            "customer2": {
                "character_id": random.randint(1, 5),
                "item_id": random.randint(1, 5),
                "quantity": random.randint(3, 12)
            },
            "customer3": {
                "character_id": random.randint(1, 5),
                "item_id": random.randint(1, 5),
                "quantity": random.randint(3, 12)
            },
            "bombs_allowed": True,
            "sugars_allowed": True,
            "switches_allowed": True,
            "milks_allowed": True
        }
        data.append(item)

    return data

# Write data to JSON file
def write_json_file(data):
    with open('data.json', 'w') as f:
        json.dump(data, f, indent=4)

if __name__ == "__main__":
    generated_data = generate_data()
    write_json_file(generated_data)
