# Valkey

[![CI Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/valkey/ci.yml?branch=main&label=CI%20Pipeline)](https://github.com/snowdreamtech/valkey/actions/workflows/ci.yml)
[![CD Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/valkey/cd.yml?branch=main&label=CD%20Pipeline)](https://github.com/snowdreamtech/valkey/actions/workflows/cd.yml)
[![CodeQL](https://img.shields.io/github/actions/workflow/status/snowdreamtech/valkey/codeql.yml?branch=main&label=CodeQL&logo=github)](https://github.com/snowdreamtech/valkey/actions/workflows/codeql.yml)
[![Security Audit](https://img.shields.io/badge/Security-Zizmor%20%7C%20Trivy%20%7C%20Gitleaks-brightgreen)](https://github.com/snowdreamtech/valkey/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/MIT)
![Docker Image Version](https://img.shields.io/docker/v/snowdreamtech/valkey)
![Docker Image Size](https://img.shields.io/docker/image-size/snowdreamtech/valkey/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/snowdreamtech/valkey)
![Docker Stars](https://img.shields.io/docker/stars/snowdreamtech/valkey)

[English](README.md) | [简体中文](README_zh-CN.md)

基于 Alpine、Debian 和 Rocky Linux 构建的标准化 Valkey 容器镜像，具备灵活的 entrypoint 初始化系统、多架构支持及统一的环境变量配置模式。

## 概述

Valkey 容器镜像提供：

- **标准化 Dockerfile**，遵循 OCI 规范与最佳实践
- **灵活的 entrypoint 系统**，支持自定义初始化脚本
- **统一的环境变量配置**，跨所有发行版变体保持一致
- **多架构支持**，适配多样化的硬件平台
- **用户/组管理**，支持 PUID/PGID 权限处理
- **三种发行版变体**：Alpine（轻量级）、Debian（默认/高兼容性）、Rocky（企业级）

## 快速上手

```bash
# 拉取并运行默认 Debian 变体
docker pull snowdreamtech/valkey:debian
docker run -d --name=valkey -p 6379:6379 -e TZ=Asia/Shanghai snowdreamtech/valkey:debian

# 或使用 docker compose
docker compose up -d
```

## 发行版变体

### Debian（默认）

推荐用于大多数场景，提供广泛的兼容性和丰富的软件包生态。

```bash
docker run -d \
  --name=valkey \
  -p 6379:6379 \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/valkey:debian
```

**支持的架构**：amd64, arm32v7, arm64, ppc64le, riscv64, s390x

**基础镜像**：`snowdreamtech/debian:13.6.0`

### Alpine

经过轻量化优化的变体，具有极小的镜像体积和极快的启动速度。

```bash
docker run -d \
  --name=valkey \
  -p 6379:6379 \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/valkey:alpine
```

**支持的架构**：386, amd64, arm/v6, arm/v7, arm64, ppc64le, riscv64, s390x

**基础镜像**：`snowdreamtech/alpine:3.24.1`

### Rocky

基于 Rocky Linux 的企业级变体，适合需要 RHEL 兼容性的生产环境。

```bash
docker run -d \
  --name=valkey \
  -p 6379:6379 \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/valkey:rocky
```

**支持的架构**：amd64, arm64, ppc64le, s390x

**基础镜像**：`snowdreamtech/rocky:10.2.0`

## 构建说明

### 单架构构建

```bash
# 构建 Debian 变体
docker build -t snowdreamtech/valkey:debian ./docker/debian/

# 构建 Alpine 变体
docker build -t snowdreamtech/valkey:alpine ./docker/alpine/

# 构建 Rocky 变体
docker build -t snowdreamtech/valkey:rocky ./docker/rocky/
```

### 多架构构建

使用 `docker buildx` 构建多架构镜像：

```bash
# 创建并使用 buildx 构建器
docker buildx create --use --name build --node build --driver-opt network=host

# 为多架构构建 Debian 镜像
docker buildx build \
  --platform=linux/amd64,linux/arm/v7,linux/arm64,linux/riscv64,linux/ppc64le,linux/s390x \
  -t snowdreamtech/valkey:debian \
  ./docker/debian/ \
  --push

# 为多架构构建 Alpine 镜像
docker buildx build \
  --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
  -t snowdreamtech/valkey:alpine \
  ./docker/alpine/ \
  --push

# 为多架构构建 Rocky 镜像
docker buildx build \
  --platform=linux/amd64,linux/arm64,linux/ppc64le,linux/s390x \
  -t snowdreamtech/valkey:rocky \
  ./docker/rocky/ \
  --push
```

## 环境变量

所有变体均支持以下环境变量：

| 变量 | 默认值 | 描述 |
|----------|---------|-------------|
| `KEEPALIVE` | `1` | 保持容器运行（1=启用，0=禁用） |
| `CAP_NET_BIND_SERVICE` | `0` | 允许绑定特权端口（<1024） |
| `LANG` | `C.UTF-8` | UTF-8 字符集语言区域设置 |
| `UMASK` | `022` | 默认文件创建掩码 |
| `DEBUG` | `false` | 启用 entrypoint 脚本的调试输出 |
| `PGID` | `0` | 自定义用户创建的主组 ID |
| `PUID` | `0` | 自定义用户创建的用户 ID |
| `USER` | `root` | 自定义用户创建的用户名 |
| `WORKDIR` | `/root` | 工作目录路径 |
| `TZ` | - | 时区（例如 `Asia/Shanghai`、`America/New_York`）|
| `VALKEY_PASS` | - | Valkey 认证密码 |
| `VALKEY_PORT` | `6379` | 自定义 Valkey 服务端监听端口 |
| `VALKEY_CONFIG_PATH` | `/etc/valkey/valkey.conf` | Valkey 配置文件路径 |
| `DISALLOW_USER_LOGIN_REMOTELY` | `1` | 禁止远程用户登录（1=启用，0=禁用） |

**Debian 特定**：

| 变量 | 默认值 | 描述 |
|----------|---------|-------------|
| `DEBIAN_FRONTEND` | `noninteractive` | Debian 软件包安装模式 |

### 自定义用户创建

在构建时创建具有特定 UID/GID 的非 root 用户：

```bash
docker build \
  --build-arg PUID=1000 \
  --build-arg PGID=1000 \
  --build-arg USER=appuser \
  -t snowdreamtech/valkey:debian-custom \
  ./docker/debian/
```

或在运行时创建：

```bash
docker run -d \
  --name=valkey \
  -e PUID=1000 \
  -e PGID=1000 \
  -e USER=appuser \
  snowdreamtech/valkey:debian
```

**说明**：仅当 `PUID≠0`、`PGID≠0` 且 `USER≠root` 时才会触发用户创建。

## Docker Compose 示例

### 简单配置

```yaml
services:
  valkey:
    image: snowdreamtech/valkey:debian
    container_name: valkey
    ports:
      - "6379:6379"
    environment:
      - TZ=Asia/Shanghai
    restart: unless-stopped
```

### 高级配置

```yaml
services:
  valkey:
    image: snowdreamtech/valkey:debian
    container_name: valkey
    ports:
      - "6379:6379"
    environment:
      - TZ=Asia/Shanghai
      - DEBUG=true
      - KEEPALIVE=1
      - VALKEY_PASS=my_secret_password
    volumes:
      - /path/to/data:/data
    restart: unless-stopped
```

## 语义化版本标签

镜像遵循语义化版本规范，格式为：`{major}.{minor}.{patch}-{variant}`

示例：

- `snowdreamtech/valkey:8.1.1-debian`
- `snowdreamtech/valkey:9.0.4-alpine`
- `snowdreamtech/valkey:8.0.11-rocky`

标签模式说明：

- **完整版本固定**：`<version>-debian`（精确版本）
- **变体最新标签**：`latest-debian`（跟踪 Debian 分支最新发布）
- **全局最新标签**：`latest`（跟踪全局最新发布，默认 Debian）

## 架构支持

各发行版变体支持的 CPU 架构：

| 变体 | 架构支持 |
|---------|---------------|
| **Debian** | amd64, arm32v7, arm64, ppc64le, riscv64, s390x |
| **Alpine** | 386, amd64, arm/v6, arm/v7, arm64, ppc64le, riscv64, s390x |
| **Rocky** | amd64, arm64, ppc64le, s390x |

拉取镜像时，Docker 会自动根据当前系统平台选择匹配的架构。

## Entrypoint 系统

包含灵活的 entrypoint 系统，在启动应用程序之前执行自定义初始化脚本。

### 工作原理

1. 容器启动时运行 `docker-entrypoint.sh`
2. 按字典序依次执行 `/usr/local/bin/entrypoint.d/` 下的所有可执行脚本
3. 每个脚本都会接收容器的命令行参数
4. 任何脚本失败都会导致容器退出（快速失败策略）

### 添加自定义初始化

在衍生 Dockerfile 中添加自定义初始化脚本：

```dockerfile
FROM snowdreamtech/valkey:debian

# 添加自定义初始化脚本
COPY my-init.sh /usr/local/bin/entrypoint.d/20-my-init.sh
RUN chmod +x /usr/local/bin/entrypoint.d/20-my-init.sh

# 应用程序设置
COPY app /app
CMD ["/app/start.sh"]
```

### 调试模式

启用调试输出以排查 entrypoint 执行问题：

```bash
docker run -e DEBUG=true snowdreamtech/valkey:debian
```

## 联系方式 (备注：valkey)

* 邮箱: <sn0wdr1am@qq.com>
* QQ: 3217680847
* QQ群: 949022145
* WeChat/微信群: sn0wdr1am

## 许可协议

MIT
