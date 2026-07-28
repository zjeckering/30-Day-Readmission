import sqlite3
import pandas as pd
from pathlib import Path

DATA_DIR = Path("patient_data")
DB_PATH = "diabetic_data.sqlite"

conn = sqlite3.connect(DB_PATH)

# --- Load the main diabetic_data.csv normally ---
diabetic_data_path = DATA_DIR / "diabetic_data.csv"
print(f"Loading {diabetic_data_path.name} -> table 'diabetic_data'")
df = pd.read_csv(diabetic_data_path, low_memory=False)
df.to_sql("diabetic_data", conn, if_exists="replace", index=False)

# --- Split IDS_mapping.csv into its three embedded lookup tables ---
ids_path = DATA_DIR / "IDS_mapping.csv"
print(f"Splitting {ids_path.name} into lookup tables...")

with open(ids_path, "r", encoding="utf-8") as f:
    raw_lines = [line.strip() for line in f]

def is_separator(line):
    stripped = line.replace(",", "").strip()
    return stripped == ""

chunks = []
current_chunk = []
for line in raw_lines:
    if is_separator(line):
        if current_chunk:
            chunks.append(current_chunk)
            current_chunk = []
    else:
        current_chunk.append(line)
if current_chunk:
    chunks.append(current_chunk)

table_names = ["admission_type_lookup", "discharge_disposition_lookup", "admission_source_lookup"]

if len(chunks) != len(table_names):
    print(f"WARNING: expected {len(table_names)} chunks, found {len(chunks)}. Check IDS_mapping.csv formatting.")

for chunk, table_name in zip(chunks, table_names):
    header = chunk[0].split(",")
    rows = [line.split(",", 1) for line in chunk[1:]]
    lookup_df = pd.DataFrame(rows, columns=header)
    lookup_df[header[1]] = lookup_df[header[1]].str.strip()
    lookup_df.to_sql(table_name, conn, if_exists="replace", index=False)
    print(f"  -> table '{table_name}' ({len(lookup_df)} rows)")

conn.close()
print("Done. Database saved to", DB_PATH)