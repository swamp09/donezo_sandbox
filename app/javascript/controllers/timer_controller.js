// frozen_string_literal: true

import { Controller } from "@hotwired/stimulus"

// タイマーを管理するコントローラー
export default class extends Controller {
  static targets = ["display"]
  static values = {
    startedAt: String,
    elapsedTime: Number
  }

  connect() {
    // 初期値の設定
    this.totalSeconds = this.elapsedTimeValue || 0

    // タスクが実行中の場合、タイマーを開始
    if (this.startedAtValue) {
      const startedAt = new Date(this.startedAtValue)
      const now = new Date()
      const secondsSinceStart = Math.floor((now - startedAt) / 1000)
      this.totalSeconds += secondsSinceStart
      this.startTimer()
    }

    // 初期表示を更新
    this.updateDisplay()
  }

  disconnect() {
    this.stopTimer()
  }

  startTimer() {
    this.timerInterval = setInterval(() => {
      this.totalSeconds += 1
      this.updateDisplay()
    }, 1000)
  }

  stopTimer() {
    if (this.timerInterval) {
      clearInterval(this.timerInterval)
    }
  }

  updateDisplay() {
    const hours = Math.floor(this.totalSeconds / 3600)
    const minutes = Math.floor((this.totalSeconds % 3600) / 60)
    const seconds = this.totalSeconds % 60

    let displayText
    if (hours > 0) {
      displayText = `${hours}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
    } else {
      displayText = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
    }

    this.displayTarget.textContent = displayText
  }
}
