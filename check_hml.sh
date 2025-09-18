#!/bin/bash
# This is a simple way to check if a list of URLs are up and running.

# URL list to check
urls=("https://www.youtube.com"
"https://www.google.com"
"https://github.com/"
"https://x.com/"
"https://azure.microsoft.com/en-us/" )

# Function to check the URL
check_url() {
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    response=$(curl --write-out "%{http_code}" --silent --output /dev/null "$1")
    if [ "$response" -ne 200 ]; then
        echo "[$timestamp] ❌ Serviço indisponível para a URL: $1 (Status: $response)"
    else
        echo "[$timestamp] ✅ Serviço disponível para a URL: $1"
    fi
}

# Loop between URLs and check one by one
for url in "${urls[@]}"; do
    check_url "$url"
done
