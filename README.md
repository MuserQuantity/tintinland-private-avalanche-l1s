# tintinland-private-avalanche-l1s
本地部署avalanche雪崩网络个人L1s网络（tintinland课程）

## 项目结构

```
.
├── Dockerfile          # Avalanche 节点容器构建文件
├── docker-compose.yaml # Docker 编排配置文件
├── network-config.json # Avalanche 网络配置文件
└── data/              # 持久化数据目录
```

## 系统要求

- Docker
- Docker Compose
- 至少 4GB RAM
- 至少 20GB 可用磁盘空间

## 快速开始构建本地主网

1. 克隆仓库：
```bash
git clone https://github.com/MuserQuantity/private-avalanche-l1s.git
cd private-avalanche-l1s
# 克隆 avalanche-cli 仓库
git clone https://github.com/ava-labs/avalanche-cli.git
```
如需使用代理，请在 .env 文件中配置 HTTP_PROXY 和 HTTPS_PROXY 环境变量。
```bash
cp .env.example .env
# 修改 .env 文件中的 HTTP_PROXY 和 HTTPS_PROXY 环境变量
HTTP_PROXY=http://127.0.0.1:7890
HTTPS_PROXY=http://127.0.0.1:7890
```
如果不需要代理，请在 .env 文件中配置 HTTP_PROXY 和 HTTPS_PROXY 环境变量为空。
```bash
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
3. 停止服务：
```bash
bash stop_network.sh
```

## 端口说明

- 9650: 节点1的API端口
- 9651: 节点1的P2P端口
- 9652: 节点2的API端口
- 9653: 节点2的P2P端口
- 9654: 节点1的RPC端口，通过socat代理到9650
- 9655: 节点2的RPC端口，通过socat代理到9652

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
- 数据持久化存储在 ./data 目录
- 支持代理配置（默认注释）

## 常用操作

1. 查看日志：
```bash
docker compose logs -f avalanche
```

2. 停止服务：
```bash
docker compose down
```

3. 重启服务：
```bash
docker compose restart
```