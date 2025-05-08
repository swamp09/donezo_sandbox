# Donezo APIエンドポイント一覧

このドキュメントでは、Donezoアプリケーションが提供するAPIエンドポイントについて説明します。Donezoは主にRailsのRESTfulなルーティングに従っています。

## 認証関連エンドポイント

Donezoはユーザー認証にDeviseを使用しています。以下は主要な認証関連エンドポイントです。

| HTTPメソッド | パス | コントローラ#アクション | 説明 |
|------------|-----|-------------------|------|
| GET | /users/sign_in | devise/sessions#new | ログインフォームを表示 |
| POST | /users/sign_in | devise/sessions#create | ログイン処理を実行 |
| DELETE | /users/sign_out | devise/sessions#destroy | ログアウト処理を実行 |
| GET | /users/sign_up | devise/registrations#new | ユーザー登録フォームを表示 |
| POST | /users | devise/registrations#create | ユーザー登録処理を実行 |
| GET | /users/password/new | devise/passwords#new | パスワードリセットフォームを表示 |
| POST | /users/password | devise/passwords#create | パスワードリセットメールを送信 |
| GET | /users/password/edit | devise/passwords#edit | パスワード変更フォームを表示 |
| PATCH | /users/password | devise/passwords#update | パスワード変更処理を実行 |

## タスク管理エンドポイント

タスクの作成、表示、更新、削除を行うためのエンドポイントです。

| HTTPメソッド | パス | コントローラ#アクション | 説明 |
|------------|-----|-------------------|------|
| GET | /tasks | tasks#index | ユーザーのタスク一覧を表示 |
| POST | /tasks | tasks#create | 新規タスクを作成 |
| PATCH/PUT | /tasks/:id | tasks#update | 指定したタスクを更新（完了状態など） |
| DELETE | /tasks/:id | tasks#destroy | 指定したタスクを削除 |

## タスク状態管理エンドポイント

タスクの状態（実行中/停止/完了）を管理するためのエンドポイントです。

| HTTPメソッド | パス | コントローラ#アクション | 説明 |
|------------|-----|-------------------|------|
| PATCH | /tasks/:task_id/state | task_states#update | タスクの状態を更新（実行中/停止/完了） |

## タスクフォーカスエンドポイント

タスクのフォーカスビューを表示するためのエンドポイントです。

| HTTPメソッド | パス | コントローラ#アクション | 説明 |
|------------|-----|-------------------|------|
| GET | /tasks/:task_id/focus | task_focuses#show | 指定したタスクのフォーカスビューを表示 |

## ホームエンドポイント

アプリケーションのホームページを表示するためのエンドポイントです。

| HTTPメソッド | パス | コントローラ#アクション | 説明 |
|------------|-----|-------------------|------|
| GET | / | home#index | ホームページを表示（未ログイン時はウェルカムページ、ログイン時はタスク一覧にリダイレクト） |

## リクエスト/レスポンス例

### タスク作成

**リクエスト:**

```
POST /tasks
Content-Type: application/x-www-form-urlencoded

task[title]=買い物に行く
```

**レスポンス:**

```
HTTP/1.1 200 OK
Content-Type: text/vnd.turbo-stream.html

<turbo-stream action="replace" target="tasks">
  <template>
    <!-- タスク一覧のHTML -->
  </template>
</turbo-stream>
<turbo-stream action="replace" target="task_form">
  <template>
    <!-- タスク作成フォームのHTML -->
  </template>
</turbo-stream>
```

### タスク完了状態の更新

**リクエスト:**

```
PATCH /tasks/1
Content-Type: application/x-www-form-urlencoded

task[completed]=true
```

**レスポンス:**

```
HTTP/1.1 200 OK
Content-Type: text/vnd.turbo-stream.html

<turbo-stream action="replace" target="task_1">
  <template>
    <!-- 更新されたタスクのHTML -->
  </template>
</turbo-stream>
```

### タスク状態の更新（実行開始）

**リクエスト:**

```
PATCH /tasks/1/state
Content-Type: application/x-www-form-urlencoded

state=in_progress
```

**レスポンス:**

```
HTTP/1.1 200 OK
Content-Type: text/vnd.turbo-stream.html

<turbo-stream action="replace" target="task_1">
  <template>
    <!-- 更新されたタスクのHTML -->
  </template>
</turbo-stream>
<turbo-stream action="replace" target="tasks_header">
  <template>
    <!-- 更新されたヘッダーのHTML -->
  </template>
</turbo-stream>
```

### タスク削除

**リクエスト:**

```
DELETE /tasks/1
```

**レスポンス:**

```
HTTP/1.1 200 OK
Content-Type: text/vnd.turbo-stream.html

<turbo-stream action="remove" target="task_1">
</turbo-stream>
```

## 認証とセキュリティ

- すべてのタスク関連エンドポイントは、`before_action :authenticate_user!`によって保護されています。
- ユーザーは自分のタスクのみにアクセスできます（`current_user.tasks`によるスコープ）。
- CSRFトークンによる保護が有効になっています。

## レスポンスフォーマット

Donezoは主にHTMLレスポンスとTurbo Streamレスポンスを返します。

- 通常のページ遷移: HTML
- 非同期更新: Turbo Stream（`text/vnd.turbo-stream.html`）

Turbo Streamレスポンスは、DOMの部分的な更新を行うための特殊なフォーマットで、ページ遷移なしでのインタラクティブなユーザー体験を実現します。
