# Donezo シーケンス図

このドキュメントでは、Donezoアプリケーションの主要な処理フローをシーケンス図で説明します。

## 1. タスク作成フロー

以下は、ユーザーが新しいタスクを作成する際の処理フローです。

```mermaid
sequenceDiagram
    actor User as ユーザー
    participant Browser as ブラウザ
    participant TasksController as TasksController
    participant Task as Taskモデル
    participant DB as データベース
    participant View as ビュー(Turbo)

    User->>Browser: タスクタイトル入力
    User->>Browser: 作成ボタンクリック
    Browser->>TasksController: POST /tasks
    TasksController->>Task: build(task_params)
    TasksController->>Task: save
    Task->>DB: INSERT
    DB-->>Task: 成功
    Task-->>TasksController: 成功
    TasksController->>TasksController: @tasks取得
    TasksController->>View: Turbo Stream生成
    View-->>Browser: HTML更新(タスク一覧+フォーム)
    Browser-->>User: UI更新(ページ遷移なし)
```

## 2. タスク完了状態切替フロー

以下は、ユーザーがタスクの完了状態を切り替える際の処理フローです。

```mermaid
sequenceDiagram
    actor User as ユーザー
    participant Browser as ブラウザ
    participant Stimulus as Stimulus Controller
    participant TasksController as TasksController
    participant Task as Taskモデル
    participant DB as データベース
    participant View as ビュー(Turbo)

    User->>Browser: チェックボックスクリック
    Browser->>Stimulus: change->task#toggle
    Stimulus->>Browser: フォーム送信
    Browser->>TasksController: PATCH /tasks/:id
    TasksController->>Task: update(completed: true/false)
    Task->>DB: UPDATE
    DB-->>Task: 成功
    Task-->>TasksController: 成功
    TasksController->>View: Turbo Stream生成
    View-->>Browser: HTML更新(タスク部分のみ)
    Browser-->>User: UI更新(ページ遷移なし)
```

## 3. タスク実行開始フロー

以下は、ユーザーがタスクを実行開始する際の処理フローです。

```mermaid
sequenceDiagram
    actor User as ユーザー
    participant Browser as ブラウザ
    participant TaskStatesController as TaskStatesController
    participant Task as Taskモデル
    participant DB as データベース
    participant View as ビュー(Turbo)

    User->>Browser: 開始ボタンクリック
    Browser->>TaskStatesController: PATCH /tasks/:id/state
    TaskStatesController->>Task: start_task
    Task->>Task: 他の実行中タスクを停止
    Task->>DB: UPDATE (他タスク)
    Task->>DB: UPDATE (現タスク)
    DB-->>Task: 成功
    Task-->>TaskStatesController: 成功
    TaskStatesController->>View: Turbo Stream生成
    View-->>Browser: HTML更新(タスク+ヘッダー)
    Browser->>Browser: タイマー開始(JavaScript)
    Browser-->>User: UI更新(ページ遷移なし)
```

## 4. タスク削除フロー

以下は、ユーザーがタスクを削除する際の処理フローです。

```mermaid
sequenceDiagram
    actor User as ユーザー
    participant Browser as ブラウザ
    participant TasksController as TasksController
    participant Task as Taskモデル
    participant DB as データベース
    participant View as ビュー(Turbo)

    User->>Browser: 削除ボタンクリック
    Browser->>TasksController: DELETE /tasks/:id
    TasksController->>Task: destroy
    Task->>DB: DELETE
    DB-->>Task: 成功
    Task-->>TasksController: 成功
    TasksController->>View: Turbo Stream生成
    View-->>Browser: HTML更新(タスク要素を削除)
    Browser-->>User: UI更新(ページ遷移なし)
```

## 5. タスクフォーカスフロー

以下は、ユーザーがタスクフォーカスビューを表示する際の処理フローです。

```mermaid
sequenceDiagram
    actor User as ユーザー
    participant Browser as ブラウザ
    participant TaskFocusesController as TaskFocusesController
    participant Task as Taskモデル
    participant View as ビュー

    User->>Browser: フォーカスボタンクリック
    Browser->>TaskFocusesController: GET /tasks/:id/focus
    TaskFocusesController->>Task: find
    Task-->>TaskFocusesController: タスク取得
    TaskFocusesController->>TaskFocusesController: 次のタスク取得
    TaskFocusesController->>View: focus.html.erb レンダリング
    View-->>Browser: HTML応答
    Browser-->>User: フォーカスビュー表示
    Browser->>Browser: タイマー初期化(JavaScript)
```

これらのシーケンス図は、Donezoアプリケーションの主要な処理フローを示しています。Hotwire（TurboとStimulus）を活用することで、ページ遷移なしでのインタラクティブなユーザー体験を実現しています。
