import { Controller } from "@hotwired/stimulus"

// タスクの状態を管理するコントローラー
export default class extends Controller {
  static targets = ["checkbox", "form", "timer"]
  static values = {
    startedAt: String,
    elapsedTime: Number
  }

  connect() {
    // タイマーの初期化（タスク詳細画面用）
    if (this.hasTimerTarget) {
      this.initializeTimer()
    }
  }

  // チェックボックスの状態が変更されたときに呼び出される
  toggle() {
    this.formTarget.requestSubmit()
  }

  // タイマーの初期化
  initializeTimer() {
    this.totalSeconds = this.elapsedTimeValue || 0

    if (this.startedAtValue) {
      const startedAt = new Date(this.startedAtValue)
      const now = new Date()
      const secondsSinceStart = Math.floor((now - startedAt) / 1000)
      this.totalSeconds += secondsSinceStart
      this.startTimer()
    }

    this.updateTimerDisplay()
  }

  // タイマーの開始
  startTimer() {
    this.timerInterval = setInterval(() => {
      this.totalSeconds += 1
      this.updateTimerDisplay()
    }, 1000)
  }

  // タイマーの停止
  stopTimer() {
    if (this.timerInterval) {
      clearInterval(this.timerInterval)
    }
  }

  // タイマー表示の更新
  updateTimerDisplay() {
    if (!this.hasTimerTarget) return

    const hours = Math.floor(this.totalSeconds / 3600)
    const minutes = Math.floor((this.totalSeconds % 3600) / 60)
    const seconds = this.totalSeconds % 60

    let displayText
    if (hours > 0) {
      displayText = `${hours}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
    } else {
      displayText = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
    }

    this.timerTarget.textContent = displayText
  }
}
