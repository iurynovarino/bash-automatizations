#!/bin/bash

# Lista de URLs para verificar
urls=("https://www.youtube.com"
"https://www.google.com"
"https://www.github.com"
"https://www.stackoverflow.com"
"https://www.reddit.com")

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
    curl -X POST "https://api.twilio.com/2010-04-01/Accounts/<ACCOUNT_SID>/Messages.json" \
    --data-urlencode "Body=$message" \
    --data-urlencode "From=whatsapp:+14155238886" \
    --data-urlencode "To=whatsapp:+<SEU_NUMERO_VERIFICADO>" \
    -u sga038c0ec47fc5f54a0196eabd70f0c59:<AUTH_TOKEN>
}

# Loop através das URLs e verificar cada uma
for url in "${urls[@]}"; do
    check_url "$url"
done
