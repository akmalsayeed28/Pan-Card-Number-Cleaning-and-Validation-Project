This project focuses on cleaning and validating Indian Permanent Account Numbers (PAN) using PostgreSQL. The objective is to ensure that every PAN entry in the dataset follows the official format and is correctly categorized as Valid or Invalid.

🔹 Key Steps Performed:

Data Cleaning:

Removed duplicates and handled missing/incomplete values.
Standardized PAN numbers by trimming spaces and converting to uppercase.

Validation Rules Applied:

PAN must be 10 characters long (format: AAAAA1234A).
First 5 characters → alphabets (with no identical or sequential repetition).
Next 4 characters → digits (with no identical or sequential repetition).
Last character → alphabet.

Categorization:

Classified each record into Valid PAN or Invalid PAN.
Generated a summary report with counts of valid, invalid, and missing PANs.

📊 Outcome:

The project produced a cleaned dataset and a summary report, enabling quick identification of valid/invalid PANs for better data reliability and compliance.
