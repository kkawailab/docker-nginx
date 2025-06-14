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