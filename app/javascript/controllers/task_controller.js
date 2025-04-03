import { Controller } from "@hotwired/stimulus"

// タスクの完了状態を管理するコントローラー
export default class extends Controller {
  static targets = ["checkbox", "form"]

  // チェックボックスの状態が変更されたときに呼び出される
  toggle() {
    this.formTarget.requestSubmit()
  }
}
