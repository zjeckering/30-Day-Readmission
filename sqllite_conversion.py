import sqlite3
import pandas as pd
from pathlib import Path

# Point this at your unzipped demo folder
DEMO_DIR = Path("mimic-iv-demo")
DB_PATH = "mimic_iv_demo.sqlite"

conn = sqlite3.connect(DB_PATH)

# Loop through both hosp/ and icu/ subfolders
for module in ["hosp", "icu"]:
    folder = DEMO_DIR / module
    if not folder.exists():
        continue
    for csv_file in folder.glob("*.csv*"):  # handles .csv and .csv.gz
        table_name = csv_file.stem.replace(".csv", "")  # strip extension(s)
        print(f"Loading {module}/{csv_file.name} -> table '{table_name}'")
        df = pd.read_csv(csv_file, compression="infer", low_memory=False)
        df.to_sql(table_name, conn, if_exists="replace", index=False)

conn.close()
print("Done. Database saved to", DB_PATH)