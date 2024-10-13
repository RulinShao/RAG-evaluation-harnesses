import os
from google.oauth2.service_account import Credentials
from googleapiclient.discovery import build


SCOPES = ['https://www.googleapis.com/auth/spreadsheets']
SERVICE_ACCOUNT_FILE = '/home/rulin/arched-envelope-421022-fffd0786e4f6.json'
if not os.path.exists(SERVICE_ACCOUNT_FILE):
    SERVICE_ACCOUNT_FILE = os.environ["GOOGLE_CREDENTIAL_FILE"]
credentials = Credentials.from_service_account_file(
    SERVICE_ACCOUNT_FILE, scopes=SCOPES)

SPREADSHEET_ID = '1waQooyXC1M8EOIA9a55N4WxMRc3EzZ48hLclOstPTNA'
TAB = 'Search'


def log_lm_eval_results(results):
    if len(results['results']) > 1:
         # TODO support grouped tasks
        return
    
    service = build('sheets', 'v4', credentials=credentials)

    RANGE_NAME = TAB  # Specify the sheet name
    # Data to append
    task = list(results['results'].keys())[0]
    values = [
        [
            task,
            results['model_name'],
            results['n-shot'][task],
            results['n-doc'][task],
            results['total_evaluation_time_seconds'],
        ] \
        + list(results['results'][task].values())
    ]
    body = {
        'values': values
    }
    # Append the data to the sheet
    request = service.spreadsheets().values().append(
        spreadsheetId=SPREADSHEET_ID,
        range=RANGE_NAME,
        valueInputOption='USER_ENTERED',
        insertDataOption='INSERT_ROWS',
        body=body
    )
    response = request.execute()
    print(response)