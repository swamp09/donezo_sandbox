# 技術コンテキスト: Donezo

## 技術スタック

### バックエンド
- **Ruby on Rails**: Webアプリケーションフレームワーク
- **SQLite**: リレーショナルデータベース
- **Devise**: ユーザー認証
- **Puma**: Webサーバー

### フロントエンド
- **Hotwire**: モダンなWebアプリケーション開発のためのアプローチ
  - **Turbo**: ページ遷移なしでHTMLを更新
  - **Stimulus**: JavaScript動作を追加
- **Tailwind CSS**: ユーティリティファーストのCSSフレームワーク
- **Font Awesome**: アイコンライブラリ
- **Importmap**: JavaScriptモジュールの管理

### 開発ツール
- **Minitest**: テスティングフレームワーク
- **Capybara**: システムテスト用ライブラリ
- **RuboCop**: コード品質チェック

## 開発環境セットアップ

### 必要条件
- Ruby 3.4.0以上
- SQLite 3以上

### 開発環境構築手順
1. リポジトリのクローン
2. 依存関係のインストール: `bundle install`
3. データベースのセットアップ: `bin/rails db:setup`
4. 開発サーバーの起動: `bin/dev`

## 技術的制約

### パフォーマンス要件
- ページロード時間: 2秒以内
- タスク操作のレスポンス時間: 500ms以内
- モバイルでの最適化: ネットワーク使用量の最小化

### ブラウザサポート
- モダンブラウザ（Chrome, Firefox, Safari, Edge）の最新2バージョン
- Internet Explorer: サポート対象外

### セキュリティ要件
- HTTPS通信の強制
- セキュアなパスワード保存（Deviseのデフォルト）
- CSRF保護
- XSS対策

## 依存関係管理

### Gemfile
Gemfileを見ろ

### アセット管理
- CSS: Tailwind CSSを使用
- JavaScript: ImportmapとStimulusを使用
- アイコン: Font Awesomeを使用

## デプロイメント

### 本番環境
未定

### デプロイプロセス
未定

## モニタリングとロギング
未定

## 開発プラクティス

### コーディング規約
- RuboCopの設定に従う
- すべての.rbファイルの先頭に`frozen_string_literal: true`マジックコメントを追加
- viewではdom_idメソッドを使用
- controllerではresource_dom_idメソッドを使用

### テスト戦略
- モデルテスト: ビジネスロジックとバリデーションをカバー
- コントローラーテスト: アクションの動作を検証
- システムテスト: エンドツーエンドの機能をカバー
- TDD（テスト駆動開発）アプローチを採用

### バージョン管理
- Git: ブランチベースの開発
