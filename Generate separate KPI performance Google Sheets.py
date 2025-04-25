# === IMPORT LIBRARIES ===
import pandas as pd
import numpy as np
from google.oauth2.service_account import Credentials
from googleapiclient.discovery import build
import gspread
from gspread_dataframe import set_with_dataframe

# === CONFIGURATION VARIABLES ===
EXCEL_FILE = "[Name of Excel file]"
Identifier_Column = "[Name of Identifier to Split Dataset On]"
METRIC_COLUMN = "[Column ]"
VALUE_COLUMN = "metric_score"
MONTH_COLUMN = "month_year"

# Google API scopes and credentials
SCOPES = ["https://www.googleapis.com/auth/spreadsheets", "https://www.googleapis.com/auth/drive"]
SERVICE_ACCOUNT_FILE = '[PATH TO JSON FILE]'
FOLDER_ID = '[Google Folder ID]'

# Target thresholds for each metric (change number of metrics as needed)
TARGETS = {
    "metric_1": ['numeric/float target'],
    "Metric_2": ['numeric/float target'],
    "Metric_3": ['float target'],
    "metric_4": ['loat target'],
    "metric_5": ['numeric/float target'],
}

# === AUTHENTICATE WITH GOOGLE SERVICES ===
creds = Credentials.from_service_account_file(SERVICE_ACCOUNT_FILE, scopes=SCOPES)
client = gspread.authorize(creds)  # For high-level spreadsheet operations
drive_service = build("drive", "v3", credentials=creds)  # For file/folder management
sheets_service = build("sheets", "v4", credentials=creds)  # For low-level Sheets API access

# === LOAD DATA ===
df = pd.read_excel(EXCEL_FILE)

# Convert datetime month column to string format "YYYY-MM"
if pd.api.types.is_datetime64_any_dtype(df[MONTH_COLUMN]):
    df[MONTH_COLUMN] = df[MONTH_COLUMN].dt.strftime("%Y-%m")

# === PROCESS EACH Identifier's DATA INDIVIDUALLY ===
for identifier, group in df.groupby(Identifier_Column):
    print(f"Processing identifier: {identifier} with {len(group)} rows") # change identifier based on name of identifier column

    # Pivot table so each metric is a column, indexed by month
    pivot_df = group.pivot_table(
        index=MONTH_COLUMN,
        columns=METRIC_COLUMN,
        values=VALUE_COLUMN,
        aggfunc='first'
    ).reset_index()
    pivot_df.columns.name = None  # Remove hierarchy name from columns

    # Initialize final DataFrame for export to Google Sheets
    final_df = pd.DataFrame()
    final_df[MONTH_COLUMN] = pivot_df[MONTH_COLUMN]

    # Add metric scores, targets, and result indicators  per metric
    for metric in TARGETS.keys():
        target = TARGETS[metric]
        metric_col = f"metric_score_{metric}"
        target_col = f"target_{metric}"
        result_col = f"result_{metric}"

        if metric in pivot_df.columns:
            final_df[metric_col] = pivot_df[metric]
            final_df[target_col] = target
            final_df[result_col] = pivot_df[metric].apply(lambda x: '\u2705' if x >= target else "\u274C")
        else:
            print(f" u26A0\uFE0F Warning: Missing data for metric {metric} for identifier {identifier}")

    # === CREATE GOOGLE SHEET FOR THE Identifier ===
    sheet_title = f"Identifier - {Identifier}"[:100]  # Limit title to 100 characters - change Identifier as needed
    sh = client.create(sheet_title)
    worksheet = sh.get_worksheet(0)

    # Push data to the first worksheet
    set_with_dataframe(worksheet, final_df)

    # === BUILD SHEET FORMATTING & CHART REQUESTS ===
    requests = []
    row_count = final_df.shape[0]  # Number of rows in sheet (excluding header)

    for i, metric in enumerate(TARGETS.keys()):
        score_col = f"metric_score_{metric}"
        target_col = f"target_{metric}"

        # Skip if metric is not present
        if score_col not in final_df.columns or target_col not in final_df.columns:
            continue

        score_idx = final_df.columns.get_loc(score_col)
        target_idx = final_df.columns.get_loc(target_col)
        score_vals = final_df[score_col].dropna().tolist()
        if not score_vals:
            continue
        max_y = max(score_vals + [TARGETS[metric]]) * 1.1  # Y-axis max with padding

        # === FORMAT PERCENTAGE COLUMNS ===
        format_requests = []
        for col_name in final_df.columns:
            if any(keyword in col_name for keyword in ["measure_3", "measure_4", "measure_5"]):
                col_index = final_df.columns.get_loc(col_name)
                format_requests.append({
                    "repeatCell": {
                        "range": {
                            "sheetId": worksheet.id,
                            "startRowIndex": 1,  # Skip header
                            "endRowIndex": row_count + 1,
                            "startColumnIndex": col_index,
                            "endColumnIndex": col_index + 1
                        },
                        "cell": {
                            "userEnteredFormat": {
                                "numberFormat": {
                                    "type": "PERCENT",
                                    "pattern": "0.0%"
                                }
                            }
                        },
                        "fields": "userEnteredFormat.numberFormat"
                    }
                })
        # Place formatting before chart so it renders cleanly
        requests = format_requests + requests

        # === CREATE LINE CHART WITH ACTUAL AND TARGET SERIES ===
        chart_request = {
            "addChart": {
                "chart": {
                    "spec": {
                        "title": f"{metric} Over Time",
                        "basicChart": {
                            "chartType": "LINE",
                            "legendPosition": "RIGHT_LEGEND",
                            "axis": [
                                {
                                    "position": "BOTTOM_AXIS",
                                    "title": "Month"
                                },
                                {
                                    "position": "LEFT_AXIS",
                                    "title": "Metric Score",
                                    "viewWindowOptions": {
                                        "viewWindowMin": 0,
                                        "viewWindowMax": max_y
                                    }
                                }
                            ],
                            "domains": [{
                                "domain": {
                                    "sourceRange": {
                                        "sources": [{
                                            "sheetId": worksheet.id,
                                            "startRowIndex": 1,
                                            "endRowIndex": row_count + 1,
                                            "startColumnIndex": 0,
                                            "endColumnIndex": 1,
                                        }]
                                    }
                                }
                            }],
                            "series": [
                                {
                                    "series": {
                                        "sourceRange": {
                                            "sources": [{
                                                "sheetId": worksheet.id,
                                                "startRowIndex": 1,
                                                "endRowIndex": row_count + 1,
                                                "startColumnIndex": score_idx,
                                                "endColumnIndex": score_idx + 1,
                                            }]
                                        }
                                    },
                                    "targetAxis": "LEFT_AXIS",
                                    "lineStyle": {
                                        "type": "SOLID"
                                    },
                                    "color": {
                                        "red": 0.0,
                                        "green": 0.0,
                                        "blue": 1.0  # Blue line = actual
                                    }
                                },
                                {
                                    "series": {
                                        "sourceRange": {
                                            "sources": [{
                                                "sheetId": worksheet.id,
                                                "startRowIndex": 1,
                                                "endRowIndex": row_count + 1,
                                                "startColumnIndex": target_idx,
                                                "endColumnIndex": target_idx + 1,
                                            }]
                                        }
                                    },
                                    "targetAxis": "LEFT_AXIS",
                                    "lineStyle": {
                                        "type": "DOTTED"
                                    },
                                    "color": {
                                        "red": 1.0,
                                        "green": 0.0,
                                        "blue": 0.0  # Red dotted line = target
                                    }
                                }
                            ],
                            "headerCount": 1
                        }
                    },
                    "position": {
                        "overlayPosition": {
                            "anchorCell": {
                                "sheetId": worksheet.id,
                                "rowIndex": row_count + 3 + (15 * i),
                                "columnIndex": 0
                            }
                        }
                    }
                }
            }
        }

        requests.append(chart_request)

    # === EXECUTE FORMATTING AND CHART CREATION REQUESTS ===
    if requests:
        sheets_service.spreadsheets().batchUpdate(
            spreadsheetId=sh.id,
            body={"requests": requests}
        ).execute()

    # === MOVE SHEET TO TARGET FOLDER IN GOOGLE DRIVE ===
    file = drive_service.files().get(fileId=sh.id, fields='id, parents').execute()
    previous_parents = ",".join(file.get('parents', []))
    drive_service.files().update(
        fileId=sh.id,
        addParents=FOLDER_ID,
        removeParents=previous_parents,
        fields='id, parents'
    ).execute()

    print(f"\u2705 Created and moved sheet with charts: {sheet_title}")
