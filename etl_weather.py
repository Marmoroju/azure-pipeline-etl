import requests
import pandas as pd
from datetime import datetime
import os
from azure.storage.blob import BlobServiceClient

# Requisição da API de geolocalização através do nome da cidade
cidade = "Itaperuna"
geo_url = (
    f"https://geocoding-api.open-meteo.com/v1/search?"
    f"name={cidade}"
    f"&count=1"
)
geo_response = requests.get(geo_url, timeout=30).json()

if "results" not in geo_response or len(geo_response["results"]) == 0:
    raise ValueError(f"Cidade '{cidade}' não encontrada.")

# Parâmetros da API de geolocalização passados para a API de clima
latitude = geo_response["results"][0]["latitude"]
longitude = geo_response["results"][0]["longitude"]
dias = 1
url_open_mateo = (
    f"https://api.open-meteo.com/v1/forecast?"
    f"latitude={latitude}&longitude={longitude}"
    f"&hourly=temperature_2m"
    f"&forecast_days={dias}"
)

# Requisição
response = requests.get(url_open_mateo, timeout=30)
data = response.json()

# Extração e transformação
timestamps = data['hourly']['time']
temperatures = data['hourly']['temperature_2m']
df = pd.DataFrame({
    'timestamp': timestamps,
    'temperature': temperatures
})
df['timestamp'] = pd.to_datetime(df['timestamp'])

# Separa data e hora
df['data'] = df['timestamp'].dt.strftime('%d/%m/%Y')
df['hora'] = df['timestamp'].dt.strftime('%H:%M')
df['cidade'] = cidade
df.rename(columns={
    'temperature': 'temperatura'
}, inplace=True)
df = df[['cidade', 'data', 'hora', 'temperatura']]

# Nome do arquivo
filename = f"weather_{cidade.lower()}_{datetime.now().strftime('%d%m%Y_%H%M')}.csv"

# Armazenamento local (opcional, útil para debug)
output_dir = "data"
os.makedirs(output_dir, exist_ok=True)
local_path = os.path.join(output_dir, filename)
df.to_csv(local_path, index=False)
print(f"Arquivo salvo localmente em: {local_path}")

# Upload para Azure Blob Storage
try:
    conn_str = os.getenv("AZURE_STORAGE_CONNECTION_STRING")
    if not conn_str:
        raise ValueError("Variável de ambiente AZURE_STORAGE_CONNECTION_STRING não encontrada.")

    # Cria cliente do Blob
    blob_service = BlobServiceClient.from_connection_string(conn_str)

    # Nome do container onde os dados estão sendo baixados (já criado via Terraform)
    # Mesmo nome passado na variável $CONTAINER_ETL
    container_name = "etldata"

    # Cria cliente para o blob
    blob_client = blob_service.get_blob_client(container=container_name, blob=filename)

    # Upload do arquivo
    with open(local_path, "rb") as data:
        blob_client.upload_blob(data, overwrite=True)

    print(f"Arquivo enviado para Azure Blob Storage: {container_name}/{filename}")

except Exception as e:
    print(f"Erro ao enviar para o Azure Blob Storage: {e}")