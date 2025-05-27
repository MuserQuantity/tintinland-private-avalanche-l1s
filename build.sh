# 如果当前目录下没有avalanche-cli目录，则克隆
if [ ! -d "avalanche-cli" ]; then
    git clone https://github.com/ava-labs/avalanche-cli.git
fi

docker compose up -d --build