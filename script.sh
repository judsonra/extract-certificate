#!/bin/bash

# Nome do arquivo PFX
PFX_FILE="$1"

# Verifica se o arquivo foi passado como argumento
if [ -z "$PFX_FILE" ]; then
    echo "Uso: $0 caminho/para/arquivo.pfx"
    exit 1
fi

# Nome base do arquivo (sem extensão)
BASENAME=$(basename "$PFX_FILE" .pfx)
DEST_DIR="./cert-${BASENAME}"

# Cria diretório de destino
mkdir -p "$DEST_DIR"

echo "Extraindo do arquivo: $PFX_FILE"
read -s -p "Digite a senha do arquivo .pfx: " PFX_PASS
echo

# 1. Extrai a chave privada com senha
openssl pkcs12 -in "$PFX_FILE" -nocerts -out "$DEST_DIR/key-com-protecao.key" -passin pass:"$PFX_PASS"

# 2. Remove a senha da chave privada
openssl rsa -in "$DEST_DIR/key-com-protecao.key" -out "$DEST_DIR/chave.key"

# 3. Extrai o certificado público
openssl pkcs12 -in "$PFX_FILE" -clcerts -nokeys -out "$DEST_DIR/certificado.crt" -passin pass:"$PFX_PASS"

# 4. Extrai a cadeia de certificação (CA Bundle)
openssl pkcs12 -in "$PFX_FILE" -cacerts -nokeys -out "$DEST_DIR/ca-bundle.crt" -passin pass:"$PFX_PASS"

# 5. Ajusta permissões básicas
chmod 600 "$DEST_DIR"/*.key
chmod 644 "$DEST_DIR"/*.crt

echo "Arquivos extraídos para: $DEST_DIR"
echo " - chave.key (sem senha)"
echo " - certificado.crt"
echo " - ca-bundle.crt"
