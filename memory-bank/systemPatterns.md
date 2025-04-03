# システムパターン: Donezo

## アーキテクチャ概要

Donezoは標準的なRails MVCアーキテクチャに、Hotwire（TurboとStimulus）を組み合わせたモダンなWebアプリケーションです。

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   Models    │◄────►│ Controllers │◄────►│    Views    │
└─────────────┘      └─────────────┘      └─────────────┘
       ▲                                         ▲
       │                                         │
       │                                         │
       │                                         ▼
┌─────────────┐                          ┌─────────────┐
│  Database   │                          │   Hotwire   │
└─────────────┘                          └─────────────┘
```

## 主要コンポーネント

### モデル層
- **User**: ユーザー認証と個人情報を管理
- **Task**: タスク情報とユーザーとの関連を管理

### コントローラー層
- **ApplicationController**: 共通機能を提供
- **TasksController**: タスクのCRUD操作を処理
- **HomeController**: ホームページを処理
- **Devise Controllers**: ユーザー認証を処理

### ビュー層
- **Layouts**: 共通レイアウトを定義
- **Task Views**: タスク関連のビューを提供
- **Devise Views**: 認証関連のビューを提供

### JavaScript (Stimulus)
- **TaskController**: タスクの完了状態の切り替えなどのインタラクションを管理

## デザインパターン

### MVC (Model-View-Controller)
基本的なRailsのMVCパターンを採用し、関心の分離を実現しています。

### Turbo Frames
ページ全体をリロードせずに部分的な更新を行うために、Turbo Framesを使用しています。特にタスクの追加、更新、削除の操作で活用しています。

### Stimulus Controllers
DOM要素に対するインタラクティブな振る舞いを管理するために、Stimulus Controllersを使用しています。

### Resource-based Routing
RESTfulなリソースベースのルーティングを採用し、標準的なCRUDアクションを提供しています。

## データフロー

### タスク作成フロー
1. ユーザーがフォームに入力
2. TasksController#createアクションが呼び出される
3. Taskモデルが作成される
4. Turbo Streamレスポンスが返される
5. DOMが部分的に更新される

### タスク完了フロー
1. ユーザーがチェックボックスをクリック
2. Stimulus TaskControllerがフォームを送信
3. TasksController#updateアクションが呼び出される
4. Taskモデルが更新される
5. Turbo Streamレスポンスが返される
6. DOMが部分的に更新される

## 重要な実装パス

### ユーザー認証
- Deviseを使用した標準的な認証フロー
- カスタムビューでUIを統一

### タスク管理
- ユーザーごとのタスク分離
- Turbo Framesを使用したシームレスなCRUD操作
- Stimulus Controllersを使用したインタラクティブな操作

## パフォーマンス最適化
- N+1クエリの回避
- 部分的なDOM更新によるネットワークトラフィックの削減
- 適切なインデックス設計

## セキュリティ対策
- 強力なユーザー認証（Devise）
- CSRF保護
- 適切な認可チェック
- パラメータのサニタイズ
