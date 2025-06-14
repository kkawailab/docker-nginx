# Docker 初心者向け完全ガイド

このチュートリアルでは、Dockerの基礎から実践的な使い方まで、初心者でも理解できるように段階的に解説します。

## 目次

1. [Dockerとは？](#1-dockerとは)
2. [Dockerのインストール](#2-dockerのインストール)
3. [Docker の基本概念](#3-docker-の基本概念)
4. [基本的なDockerコマンド](#4-基本的なdockerコマンド)
5. [実践：Nginxウェブサーバーの構築](#5-実践nginxウェブサーバーの構築)
6. [Dockerfileの作成](#6-dockerfileの作成)
7. [Docker Composeの基礎](#7-docker-composeの基礎)
8. [ベストプラクティス](#8-ベストプラクティス)
9. [トラブルシューティング](#9-トラブルシューティング)
10. [次のステップ](#10-次のステップ)

## 1. Dockerとは？

### Dockerの概要

Dockerは、アプリケーションをコンテナと呼ばれる軽量な仮想環境で実行するプラットフォームです。コンテナには、アプリケーションの実行に必要なすべての要素（コード、ランタイム、システムツール、ライブラリ、設定）が含まれています。

### なぜDockerを使うのか？

**主なメリット**:
- **環境の一貫性**: 「私の環境では動くのに...」という問題を解決
- **軽量性**: 仮想マシンと比較して起動が速く、リソース消費が少ない
- **ポータビリティ**: 開発環境から本番環境まで同じコンテナを使用可能
- **スケーラビリティ**: コンテナの追加・削除が簡単
- **バージョン管理**: アプリケーションの異なるバージョンを簡単に管理

### Dockerと仮想マシンの違い

```
仮想マシン:
┌─────────────┬─────────────┬─────────────┐
│   App A     │   App B     │   App C     │
├─────────────┼─────────────┼─────────────┤
│  Guest OS   │  Guest OS   │  Guest OS   │
├─────────────┴─────────────┴─────────────┤
│            Hypervisor                    │
├─────────────────────────────────────────┤
│              Host OS                     │
├─────────────────────────────────────────┤
│             Hardware                     │
└─────────────────────────────────────────┘

Docker:
┌─────────────┬─────────────┬─────────────┐
│   App A     │   App B     │   App C     │
├─────────────┼─────────────┼─────────────┤
│ Container A │ Container B │ Container C │
├─────────────┴─────────────┴─────────────┤
│           Docker Engine                  │
├─────────────────────────────────────────┤
│              Host OS                     │
├─────────────────────────────────────────┤
│             Hardware                     │
└─────────────────────────────────────────┘
```

## 2. Dockerのインストール

### システム要件

**Windows**:
- Windows 10 64-bit: Pro, Enterprise, Education (Build 15063以降)
- Windows 11 64-bit: Home, Pro, Enterprise, Education

**macOS**:
- macOS 10.15以降

**Linux**:
- 64-bit版のディストリビューション
- カーネル3.10以降

### Windows/macOSへのインストール

1. [Docker Desktop](https://www.docker.com/products/docker-desktop/)の公式サイトにアクセス
2. お使いのOSに対応したインストーラーをダウンロード
3. ダウンロードしたインストーラーを実行
4. インストールウィザードの指示に従って進める
5. インストール完了後、システムを再起動
6. Docker Desktopを起動

### Linuxへのインストール（Ubuntu/Debian）

```bash
# 既存のDockerを削除（もしあれば）
sudo apt-get remove docker docker-engine docker.io containerd runc

# パッケージインデックスを更新
sudo apt-get update

# HTTPSリポジトリを使用するために必要なパッケージをインストール
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# DockerのGPGキーを追加
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Dockerリポジトリを追加
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Dockerエンジンをインストール
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# 現在のユーザーをdockerグループに追加（sudoなしで実行可能にする）
sudo usermod -aG docker $USER

# グループの変更を反映（再ログインが必要な場合もある）
newgrp docker
```

### インストールの確認

```bash
# Dockerのバージョンを確認
docker --version

# Dockerの詳細情報を表示
docker info

# テストイメージを実行
docker run hello-world
```

成功すると以下のようなメッセージが表示されます：
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

## 3. Docker の基本概念

### イメージ（Image）

- アプリケーションを実行するための読み取り専用のテンプレート
- OSのファイルシステム、アプリケーションコード、依存関係、設定などを含む
- レイヤー構造で効率的に管理される

### コンテナ（Container）

- イメージから作成される実行可能なインスタンス
- 独立した環境で動作し、他のコンテナやホストシステムから分離されている
- 起動、停止、削除が可能

### レジストリ（Registry）

- Dockerイメージを保存・配布する場所
- Docker Hub（公式レジストリ）が最も有名
- プライベートレジストリも構築可能

### Dockerfile

- Dockerイメージを作成するための設計書
- テキストファイルで、イメージ作成の手順を記述

## 4. 基本的なDockerコマンド

### イメージ関連のコマンド

```bash
# イメージを検索
docker search nginx

# イメージをダウンロード
docker pull nginx:latest

# ローカルのイメージ一覧を表示
docker images

# イメージの詳細情報を表示
docker inspect nginx

# 不要なイメージを削除
docker rmi nginx:latest

# 使用されていないイメージをすべて削除
docker image prune -a
```

### コンテナ関連のコマンド

```bash
# コンテナを作成して起動
docker run -d --name my-nginx -p 8080:80 nginx

# 実行中のコンテナ一覧を表示
docker ps

# すべてのコンテナを表示（停止中も含む）
docker ps -a

# コンテナを停止
docker stop my-nginx

# コンテナを起動
docker start my-nginx

# コンテナを再起動
docker restart my-nginx

# コンテナを削除
docker rm my-nginx

# 実行中のコンテナに接続
docker exec -it my-nginx bash

# コンテナのログを確認
docker logs my-nginx

# コンテナのリアルタイムログを確認
docker logs -f my-nginx

# コンテナの統計情報を表示
docker stats
```

### その他の便利なコマンド

```bash
# Dockerシステムの情報を表示
docker system info

# ディスク使用量を確認
docker system df

# 不要なリソースをクリーンアップ
docker system prune -a

# コンテナ内でコマンドを実行
docker exec my-nginx ls -la /usr/share/nginx/html

# コンテナとホスト間でファイルをコピー
docker cp index.html my-nginx:/usr/share/nginx/html/
docker cp my-nginx:/etc/nginx/nginx.conf ./nginx.conf
```

## 5. 実践：Nginxウェブサーバーの構築

### シンプルなNginxサーバーの起動

```bash
# Nginxイメージをダウンロード
docker pull nginx:alpine

# コンテナを起動（デタッチモード）
docker run -d \
  --name web-server \
  -p 8080:80 \
  nginx:alpine
```

オプションの説明：
- `-d`: バックグラウンドで実行（デタッチモード）
- `--name`: コンテナに名前を付ける
- `-p 8080:80`: ホストの8080番ポートをコンテナの80番ポートにマッピング

### カスタムコンテンツの配信

1. 作業ディレクトリを作成：
```bash
mkdir nginx-custom
cd nginx-custom
```

2. HTMLファイルを作成：
```bash
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Docker Nginx サンプル</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f0f0f0;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .info {
            background-color: #e7f3ff;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐳 Docker Nginxへようこそ！</h1>
        <p>このページはDockerコンテナ内のNginxから配信されています。</p>
        <div class="info">
            <h2>Dockerの利点</h2>
            <ul>
                <li>環境の一貫性を保証</li>
                <li>素早いデプロイメント</li>
                <li>リソースの効率的な使用</li>
                <li>スケーラビリティの向上</li>
            </ul>
        </div>
    </div>
</body>
</html>
EOF
```

3. ボリュームマウントでコンテナを起動：
```bash
docker run -d \
  --name custom-nginx \
  -p 8081:80 \
  -v $(pwd):/usr/share/nginx/html:ro \
  nginx:alpine
```

- `-v`: ボリュームマウント（ホストのディレクトリをコンテナにマウント）
- `:ro`: 読み取り専用でマウント

### Nginx設定のカスタマイズ

1. カスタム設定ファイルを作成：
```bash
cat > nginx.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    
    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
    }
    
    # キャッシュ設定
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # gzip圧縮
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
    
    # セキュリティヘッダー
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
EOF
```

2. カスタム設定でコンテナを起動：
```bash
docker run -d \
  --name secure-nginx \
  -p 8082:80 \
  -v $(pwd)/nginx.conf:/etc/nginx/conf.d/default.conf:ro \
  -v $(pwd):/usr/share/nginx/html:ro \
  nginx:alpine
```

## 6. Dockerfileの作成

### 基本的なDockerfile

```dockerfile
# ベースイメージを指定
FROM nginx:alpine

# メタデータを追加
LABEL maintainer="your-email@example.com"
LABEL version="1.0"
LABEL description="カスタムNginxイメージ"

# 作業ディレクトリを設定
WORKDIR /usr/share/nginx/html

# ファイルをコピー
COPY index.html .
COPY nginx.conf /etc/nginx/conf.d/default.conf

# ポートを公開
EXPOSE 80

# ヘルスチェックを追加
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# コンテナ起動時のコマンド
CMD ["nginx", "-g", "daemon off;"]
```

### マルチステージビルドの例

```dockerfile
# ステージ1: ビルド環境
FROM node:16-alpine AS builder

WORKDIR /app

# 依存関係をインストール
COPY package*.json ./
RUN npm ci --only=production

# アプリケーションをビルド
COPY . .
RUN npm run build

# ステージ2: 実行環境
FROM nginx:alpine

# ビルド成果物をコピー
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx設定をコピー
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### Dockerイメージのビルドと実行

```bash
# イメージをビルド
docker build -t my-custom-nginx:1.0 .

# タグを追加
docker tag my-custom-nginx:1.0 my-custom-nginx:latest

# イメージを確認
docker images | grep my-custom-nginx

# コンテナを実行
docker run -d -p 8083:80 --name my-app my-custom-nginx:1.0
```

## 7. Docker Composeの基礎

### Docker Composeとは

Docker Composeは、複数のコンテナで構成されるアプリケーションを定義・実行するツールです。YAMLファイルでサービス、ネットワーク、ボリュームを定義します。

### 基本的なdocker-compose.yml

```yaml
version: '3.8'

services:
  # Webサーバー
  web:
    build: .
    container_name: nginx-web
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
    networks:
      - webnet
    restart: unless-stopped

  # データベース
  db:
    image: mysql:8.0
    container_name: mysql-db
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: myapp
      MYSQL_USER: appuser
      MYSQL_PASSWORD: apppassword
    volumes:
      - db-data:/var/lib/mysql
    networks:
      - webnet
    restart: unless-stopped

  # PHPアプリケーション
  app:
    image: php:8.1-fpm
    container_name: php-app
    volumes:
      - ./app:/var/www/html
    networks:
      - webnet
    depends_on:
      - db

networks:
  webnet:
    driver: bridge

volumes:
  db-data:
    driver: local
```

### Docker Composeコマンド

```bash
# サービスを起動
docker-compose up -d

# ログを確認
docker-compose logs -f

# サービスの状態を確認
docker-compose ps

# サービスを停止
docker-compose stop

# サービスを停止して削除
docker-compose down

# ボリュームも含めて削除
docker-compose down -v

# 特定のサービスのみ起動
docker-compose up -d web

# サービスを再ビルド
docker-compose build

# スケールアウト
docker-compose up -d --scale web=3
```

## 8. ベストプラクティス

### Dockerfileのベストプラクティス

1. **軽量なベースイメージを使用**
```dockerfile
# Good
FROM alpine:3.14

# Better
FROM nginx:alpine
```

2. **レイヤーを最小限に**
```dockerfile
# Bad
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y git

# Good
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*
```

3. **キャッシュを活用**
```dockerfile
# 依存関係を先にコピー（変更が少ない）
COPY package*.json ./
RUN npm install

# アプリケーションコードを後でコピー（変更が多い）
COPY . .
```

4. **非rootユーザーで実行**
```dockerfile
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

USER appuser
```

### セキュリティのベストプラクティス

1. **最新のイメージを使用**
```bash
docker pull nginx:latest
```

2. **機密情報を含めない**
```dockerfile
# Bad
ENV API_KEY=secret123

# Good - 実行時に環境変数で渡す
docker run -e API_KEY=secret123 myapp
```

3. **最小権限の原則**
```yaml
# docker-compose.yml
services:
  app:
    image: myapp
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE
```

### パフォーマンスのベストプラクティス

1. **マルチステージビルドを使用**
2. **不要なファイルを.dockerignoreで除外**
```
# .dockerignore
node_modules
.git
.env
*.log
```

3. **ヘルスチェックを実装**
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/health || exit 1
```

## 9. トラブルシューティング

### よくある問題と解決方法

#### 1. ポートが既に使用されている
```bash
# エラーメッセージ
docker: Error response from daemon: bind: address already in use.

# 解決方法
# 使用中のポートを確認
sudo lsof -i :8080

# 別のポートを使用
docker run -p 8081:80 nginx
```

#### 2. 権限エラー
```bash
# エラーメッセージ
Got permission denied while trying to connect to the Docker daemon socket

# 解決方法
# ユーザーをdockerグループに追加
sudo usermod -aG docker $USER

# 再ログインまたは
newgrp docker
```

#### 3. コンテナが起動しない
```bash
# ログを確認
docker logs <container-name>

# より詳細なログ
docker logs --details <container-name>

# インタラクティブモードで起動してデバッグ
docker run -it --rm nginx:alpine sh
```

#### 4. ディスク容量不足
```bash
# Docker使用量を確認
docker system df

# 不要なリソースをクリーンアップ
docker system prune -a --volumes

# 特定のリソースのみクリーンアップ
docker container prune
docker image prune
docker volume prune
```

### デバッグテクニック

1. **コンテナ内でデバッグ**
```bash
# 実行中のコンテナに接続
docker exec -it <container-name> /bin/sh

# 新しいコンテナでデバッグ
docker run -it --rm nginx:alpine /bin/sh
```

2. **ネットワークの確認**
```bash
# ネットワーク一覧
docker network ls

# ネットワークの詳細
docker network inspect bridge

# コンテナのネットワーク設定
docker inspect <container-name> | grep -i network
```

3. **ボリュームの確認**
```bash
# ボリューム一覧
docker volume ls

# ボリュームの詳細
docker volume inspect <volume-name>

# コンテナのマウント情報
docker inspect <container-name> | grep -i mount -A 10
```

## 10. 次のステップ

### 学習を続けるために

1. **Docker Swarm**: Dockerのネイティブオーケストレーション
2. **Kubernetes**: コンテナオーケストレーションの業界標準
3. **CI/CD統合**: GitLab CI、GitHub Actions、Jenkins
4. **モニタリング**: Prometheus、Grafana、ELKスタック
5. **レジストリ管理**: Docker Hub、Amazon ECR、Google Container Registry

### 推奨リソース

- [Docker公式ドキュメント](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Play with Docker](https://labs.play-with-docker.com/)
- [Awesome Docker](https://github.com/veggiemonk/awesome-docker)

### 実践プロジェクトのアイデア

1. **マイクロサービスアーキテクチャ**: 複数のサービスをDocker Composeで構築
2. **CI/CDパイプライン**: アプリケーションの自動ビルド・デプロイ
3. **開発環境の構築**: チーム全体で統一された開発環境
4. **レガシーアプリケーションのコンテナ化**: 既存アプリケーションをDockerに移行

## まとめ

このチュートリアルでは、Dockerの基礎から実践的な使い方まで幅広く解説しました。Dockerは現代のソフトウェア開発において不可欠なツールです。継続的に学習し、実践することで、より効率的で安定したアプリケーション開発が可能になります。

記載されているコマンドや設定は、実際の環境で試しながら理解を深めてください。エラーが発生した場合は、エラーメッセージをよく読み、公式ドキュメントやコミュニティリソースを活用して解決していきましょう。

Happy Dockering! 🐳