# Etapa 1: Build com dependências
FROM python:3.13-alpine AS builder

WORKDIR /app

# Instala ferramentas mínimas para compilar numpy/pandas
RUN apk add --no-cache build-base libffi-dev gfortran

COPY requirements.txt .

# Instala dependências no diretório isolado
RUN pip install --no-cache-dir --target=/install -r requirements.txt

# Remove símbolos de debug e arquivos desnecessários
RUN find /install -name '*.so' -exec strip --strip-unneeded {} + \
    && find /install -type d -name '__pycache__' -exec rm -r {} + \
    && find /install -type f -name '*.pyc' -delete

# Etapa 2: Imagem final
FROM python:3.13-alpine

RUN addgroup -S azuregroup && adduser -S azureuser -G azuregroup

WORKDIR /app

COPY etl_weather.py .

COPY --from=builder /install /usr/local/lib/python3.13/site-packages

RUN chown -R azureuser:azuregroup /app

USER azureuser

ENV AZURE_STORAGE_CONNECTION_STRING=""

CMD ["python", "etl_weather.py"]