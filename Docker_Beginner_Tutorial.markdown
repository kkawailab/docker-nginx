# Docker 初心者向けチュートリアル

このチュートリアルでは、Dockerの基本を学び、簡単なコンテナを作成して実行する手順を説明します。初心者でも理解しやすいように、ステップごとに進めます。

## 1. Dockerとは？

Dockerは、アプリケーションを軽量なコンテナとしてパッケージ化し、どこでも同じ環境で実行できるようにするプラットフォームです。コンテナは、コード、依存関係、設定を1つにまとめたものです。

**主なメリット**:
- 環境の一貫性: 開発、テスト、本番環境で同じ動作を保証。
- 軽量: 仮想マシンより少ないリソースで動作。
- ポータビリティ: どのOSやクラウドでも動く。

## 2. Dockerのインストール

以下の手順でDockerをインストールします。Windows、Mac、Linuxに対応しています。

### Windows/Macの場合
1. [Docker Desktop](https://www.docker.com/products/docker-desktop/) の公式サイトにアクセス。
2. 「Download for Windows」または「Download for Mac」をクリック。
3. インストーラをダウンロードし、指示に従ってインストール。
4. インストール後、Docker Desktopを起動。

### Linuxの場合 (Ubuntuの例)
1. ターミナルを開き、以下のコマンドを実行:
   ```bash
   sudo apt-get update
   sudo apt-get install -y docker.io
   sudo systemctl start docker
   sudo systemctl enable docker
   ```
2. Dockerが正しくインストールされたか確認:
   ```bash
   docker --version
   ```

### インストール確認
以下のコマンドを実行し、Dockerが動作しているか確認:
```bash
docker run hello-world
```
成功すると、「Hello from Docker!」というメッセージが表示されます。

## 3. 基本的なDockerコマンド

Dockerを操作するための基本コマンドをいくつか紹介します。

- **イメージの取得**:
  ```bash
  docker pull <イメージ名>
  ```
  例: `docker pull nginx` でNginxウェブサーバーのイメージを取得。

- **コンテナの起動**:
  ```bash
  docker run <イメージ名>
  ```
  例: `docker run nginx` でNginxコンテナを起動。

- **実行中のコンテナの確認**:
  ```bash
  docker ps
  ```

- **すべてのコンテナの確認** (停止中のものも含む):
  ```bash
  docker ps -a
  ```

- **コンテナの停止**:
  ```bash
  docker stop <コンテナID>
  ```

## 4. 簡単なWebサーバーの作成

Nginxを使って、簡単なWebサーバーをDockerで動かしてみましょう。

### 手順
1. Nginxイメージをダウンロード:
   ```bash
   docker pull nginx
   ```

2. Nginxコンテナを起動:
   ```bash
   docker run -d -p 8080:80 nginx
   ```
   - `-d`: バックグラウンドで実行。
   - `-p 8080:80`: ホストのポート8080をコンテナのポート80にマッピング。

3. ブラウザで `http://localhost:8080` にアクセス。Nginxのデフォルトページが表示されます。

4. コンテナを停止:
   ```bash
   docker ps  # コンテナIDを確認
   docker stop <コンテナID>
   ```

## 5. 独自のDockerイメージの作成

次に、簡単なHTMLページを提供するカスタムDockerイメージを作成します。

### 手順
1. 作業用のディレクトリを作成:
   ```bash
   mkdir my-web-app
   cd my-web-app
   ```

2. `index.html` ファイルを作成:
   ```html
   <!DOCTYPE html>
   <html>
   <head>
       <title>My Docker App</title>
   </head>
   <body>
       <h1>Hello, Docker!</h1>
       <p>This is my first Docker web app.</p>
   </body>
   </html>
   ```

3. `Dockerfile` を作成:
   ```Dockerfile
   FROM nginx:latest
   COPY index.html /usr/share/nginx/html/index.html
   ```

4. Dockerイメージをビルド:
   ```bash
   docker build -t my-web-app .
   ```

5. コンテナを起動:
   ```bash
   docker run -d -p 8080:80 my-web-app
   ```

6. ブラウザで `http://localhost:8080` にアクセス。カスタムページが表示されます。

## 6. 次のステップ

これでDockerの基本を学びました！次に進むための提案:
- **Docker Compose**: 複数のコンテナを管理する方法を学ぶ。
- **Docker Hub**: 公開イメージを探索し、共有する。
- **ボリュームとネットワーク**: データの永続化やコンテナ間の通信を学ぶ。

## まとめ

このチュートリアルでは、Dockerのインストール、基本コマンド、簡単なWebサーバーの作成、カスタムイメージのビルドを学びました。これを基に、Dockerを活用してさまざまなアプリケーションを試してみてください！