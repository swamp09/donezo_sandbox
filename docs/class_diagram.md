# donezoアプリケーションのクラス図

```mermaid
classDiagram
    %% モデルクラス
    class ActiveRecordBase {
        Rails Core
    }

    class ApplicationRecord {
        Abstract
        +primary_abstract_class
    }

    class User {
        +email: string
        +password: string
        +has_many tasks
        +devise authentication
    }

    class Task {
        +title: string
        +completed: boolean
        +in_progress: boolean
        +started_at: datetime
        +elapsed_time: integer
        +user_id: integer
        +belongs_to user
        +scope in_progress()
        +scope not_in_progress()
        +scope completed()
        +scope not_completed()
        +start_task()
        +stop_task()
        +complete_task()
        +reset_task()
        +formatted_elapsed_time()
    }

    %% コントローラークラス
    class ActionControllerBase {
        Rails Core
    }

    class ApplicationController {
        +include ApplicationHelper
        +allow_browser()
        #configure_permitted_parameters()
    }

    class TasksController {
        -before_action authenticate_user!
        -before_action set_task
        +index()
        +create()
        +update()
        +destroy()
        -set_task()
        -task_params()
    }

    class TaskStatesController {
        -before_action authenticate_user!
        -before_action set_task
        +update()
        -set_task()
    }

    class TaskFocusesController {
        -before_action authenticate_user!
        -before_action set_task
        +show()
        -set_task()
    }

    class HomeController {
        +index()
    }

    class DeviseRegistrationsController {
        Devise Core
    }

    class UsersRegistrationsController {
        +after_sign_up_path_for()
        +after_inactive_sign_up_path_for()
    }

    %% JavaScriptコントローラークラス
    class StimulusController {
        Stimulus Core
    }

    class TaskController {
        +targets: checkbox, form, timer
        +values: startedAt, elapsedTime
        +connect()
        +toggle()
        +initializeTimer()
        +startTimer()
        +stopTimer()
        +updateTimerDisplay()
    }

    class TimerController {
        +targets: display
        +values: startedAt, elapsedTime
        +connect()
        +disconnect()
        +startTimer()
        +stopTimer()
        +updateDisplay()
    }

    %% 継承関係
    ActiveRecordBase <|-- ApplicationRecord
    ApplicationRecord <|-- User
    ApplicationRecord <|-- Task

    ActionControllerBase <|-- ApplicationController
    ApplicationController <|-- TasksController
    ApplicationController <|-- TaskStatesController
    ApplicationController <|-- TaskFocusesController
    ApplicationController <|-- HomeController

    DeviseRegistrationsController <|-- UsersRegistrationsController

    StimulusController <|-- TaskController
    StimulusController <|-- TimerController

    %% 関連関係
    User "1" -- "many" Task : has_many
    Task "many" -- "1" User : belongs_to

    TasksController -- Task : manages
    TaskStatesController -- Task : manages state
    TaskFocusesController -- Task : focuses on
    UsersRegistrationsController -- User : registers
```

## クラス図の説明

### モデル層
- `ApplicationRecord`: ActiveRecordの基底クラス
- `User`: ユーザーモデル、Deviseによる認証機能を持ち、複数のタスクを所有
- `Task`: タスクモデル、ユーザーに所属し、状態管理と時間計測機能を持つ

### コントローラー層
- `ApplicationController`: コントローラーの基底クラス
- `TasksController`: タスクのCRUD操作を担当
- `TaskStatesController`: タスクの状態（実行中、停止、完了）を管理
- `TaskFocusesController`: 特定のタスクにフォーカスする機能を提供
- `HomeController`: ホームページを表示
- `Users::RegistrationsController`: ユーザー登録をカスタマイズ

### JavaScript層
- `TaskController`: タスクの状態管理とタイマー機能を実装するStimulusコントローラー
- `TimerController`: タイマー機能を実装するStimulusコントローラー
