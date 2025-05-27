# tintinland-private-avalanche-l1s
本地部署avalanche雪崩网络个人L1s网络（tintinland课程）

## 项目结构

```
.
├── Dockerfile          # Avalanche 节点容器构建文件
├── docker-compose.yaml # Docker 编排配置文件
├── network-config.json # Avalanche 网络配置文件
├── deploy_myl1s.sh     # 部署myl1s脚本
├── start_network.sh    # 启动网络脚本
├── stop_network.sh     # 停止网络脚本
└── data/               # 持久化数据目录
└── myl1s-data/         # myl1s持久化数据目录
```

## 环境要求

- Docker
- Docker Compose
- MacOS Apple Silicon 或 Linux x86_64 架构

## 快速开始构建本地主网

1. 克隆仓库：
    ```bash
    git clone https://github.com/MuserQuantity/tintinland-private-avalanche-l1s.git
    cd tintinland-private-avalanche-l1s
    # 克隆 avalanche-cli 仓库
    git clone https://github.com/ava-labs/avalanche-cli.git
    ```
    如需使用代理，请在 .env 文件中配置 HTTP_PROXY 和 HTTPS_PROXY 环境变量。
    ```bash .env
    cp .env.example .env
    # 修改 .env 文件中的 HTTP_PROXY 和 HTTPS_PROXY 环境变量
    HTTP_PROXY=http://127.0.0.1:7890
    HTTPS_PROXY=http://127.0.0.1:7890
    ```
    如果不需要代理，请在 `.env` 文件中配置 HTTP_PROXY 和 HTTPS_PROXY 环境变量为空。
    ```bash .env
    HTTP_PROXY=
    HTTPS_PROXY=
    ```

2. 编译并启动服务：

    编译
    ```bash
    bash build.sh
    ```
    启动
    ```bash
    docker exec -it avalanche-cli-container bash
    bash start_network.sh
    ```
    检查
    ```bash
    # 检查节点是否响应
    curl -X POST \
    http://172.0.0.3:9650/ext/bc/C/rpc \
    -H "Content-Type: application/json" \
    -d '{
        "jsonrpc": "2.0",
        "method": "web3_clientVersion",
        "params": [],
        "id": 1
    }'
    ```

3. 停止服务：
    ```bash
    bash stop_network.sh
    ```

## 搭建本地L1s网络

1. 基于本地主网启动myl1s
    ```bash
    docker exec -it avalanche-cli-container bash
    bash deploy_myl1s.sh
    ```
    部署完成后，会自动启动myl1s，并生成节点ID，请注意保存。此时外部会访问不了子网，需要重启一下网络，带上网络配置参数。
    ```bash
    bash stop_network.sh
    bash start_network.sh
    ```
    检查myl1s是否启动成功。
    ```bash
    # 检查节点是否响应
    curl -X POST \
    http://172.0.0.3:9750/ext/bc/YOUR_NODE_ID/rpc \
    -H "Content-Type: application/json" \
    -d '{
        "jsonrpc": "2.0",
        "method": "web3_clientVersion",
        "params": [],
        "id": 1
    }'
    ```

## 端口说明

- 9650: 节点1的RPC端口
- 9651: 节点1的P2P端口
- 9652: 节点2的RPC端口
- 9653: 节点2的P2P端口
- 9750: myl1s的RPC端口

## 配置说明

### network-config.json

主要配置项：
- `metricsenabled`: 是否启用指标收集
- `api-admin-enabled`: 是否启用管理员 API
- `api-ipcs-enabled`: 是否启用 IPC API
- `index-enabled`: 是否启用索引
- `public-ip`: 节点公网 IP
- `staking-host`: 质押主机地址

### docker-compose.yaml

- 使用自定义网络 172.0.0.0/24
- 数据持久化存储在`./data`和`./myl1s-data`目录
- 支持代理配置（默认注释）

## 常用操作

1. 启动服务：
```bash
docker compose up -d
```

2. 停止服务：
```bash
# 注意：停止服务前，请先执行 bash stop_network.sh
docker compose down
```

3. 重启服务：
```bash
docker compose restart
```

4. 清除网络代理：
```bash
unset HTTP_PROXY
unset HTTPS_PROXY
unset http_proxy
unset https_proxy
```