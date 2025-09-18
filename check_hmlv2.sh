#!/bin/bash

# Lista de URLs para verificar
urls=("https://www.youtube.com"
"https://www.google.com"
"https://github.com/"
"https://x.com/"
"https://azure.microsoft.com/en-us/" )

# Função para verificar a URL
check_url() {
    response=$(curl --write-out "%{http_code}" --silent --output /dev/null "$1")
    if [ "$response" -ne 200 ]; then
        echo "Serviço indisponível para a URL: $1"
        send_whatsapp_message "Serviço indisponível para a URL: $1"
    else
        echo "Serviço disponível para a URL: $1"
    fi
}

# Função para enviar mensagem pelo WhatsApp usando Twilio
send_whatsapp_message() {
    local message=$1

    # Check for required environment variables
    if [ -z "$TWILIO_ACCOUNT_SID" ] || [ -z "$TWILIO_AUTH_TOKEN" ] || [ -z "$TWILIO_FROM_NUMBER" ] || [ -z "$TWILIO_TO_NUMBER" ]; then
        echo "Error: Twilio environment variables are not set."
        echo "Please set TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_FROM_NUMBER, and TWILIO_TO_NUMBER."
        return 1
    fi

    curl -s -X POST "https://api.twilio.com/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages.json" \
    --data-urlencode "Body=$message" \
    --data-urlencode "From=${TWILIO_FROM_NUMBER}" \
    --data-urlencode "To=${TWILIO_TO_NUMBER}" \
    -u "${TWILIO_ACCOUNT_SID}:${TWILIO_AUTH_TOKEN}"
}

# Loop através das URLs e verificar cada uma
for url in "${urls[@]}"; do
    check_url "$url"
done
