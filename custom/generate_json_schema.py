import json
import os


def generate_schema(obj):
    if isinstance(obj, list):
        return {
            "type": "array",
            "items": generate_schema(obj[0] if obj else {})
        }
    elif isinstance(obj, dict):
        properties = {}
        required = []

        for key, value in obj.items():
            properties[key] = generate_schema(value)
            required.append(key)

        return {
            "type": "object",
            "properties": properties,
            "required": required
        }
    else:
        return {"type": type(obj)._name_}


def save_schema_to_file(response_json, filename="generated_schema.json"):
    if os.path.exists(filename):
        print(f"⚠️ File '{filename}' already exists. Skipping save.")
        return filename  # You can return None if you want to signal "not saved"

    schema_body = generate_schema(response_json)

    schema = {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        **schema_body
    }

    with open(filename, "w") as f:
        json.dump(schema, f, indent=2)

    print(f"✅ Schema saved to '{filename}'")
    return filename