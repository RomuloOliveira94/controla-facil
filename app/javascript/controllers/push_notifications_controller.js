import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle"]

  connect() {
    this.vapidPublicKey = document.querySelector('meta[name="vapid-public-key"]')?.content
    this.userId = document.querySelector('meta[name="user-id"]')?.content
    this.csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

    if (!this.vapidPublicKey || !this.userId) return

    this.syncToggleState()
  }

  async syncToggleState() {
    if (!window.PushManager) {
      this.toggleTarget.disabled = true
      return
    }

    const registration = await navigator.serviceWorker.ready
    const subscription = await registration.pushManager.getSubscription()
    this.toggleTarget.checked = !!subscription
  }

  async toggle(event) {
    const isChecked = event.target.checked

    if (isChecked) {
      await this.activate()
    } else {
      await this.deactivate()
    }
  }

  async activate() {
    if (!window.PushManager) {
      this.toggleTarget.checked = false
      return
    }

    try {
      const permission = await Notification.requestPermission()

      if (permission !== 'granted') {
        this.toggleTarget.checked = false
        return
      }

      const registration = await navigator.serviceWorker.ready
      let subscription = await registration.pushManager.getSubscription()

      if (subscription) {
        await subscription.unsubscribe()
      }

      subscription = await registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: this.vapidPublicKey
      })

      const { endpoint, keys: { p256dh, auth } } = subscription.toJSON()

      const body = JSON.stringify({
        push_subscription: {
          endpoint,
          p256dh,
          auth,
          user_id: this.userId
        }
      })

      const response = await fetch('/push_subscriptions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfToken
        },
        body
      })

      if (!response.ok) {
        this.toggleTarget.checked = false
      }
    } catch (error) {
      console.error('Erro ao ativar notificações push:', error)
      this.toggleTarget.checked = false
    }
  }

  async deactivate() {
    try {
      const registration = await navigator.serviceWorker.ready
      const subscription = await registration.pushManager.getSubscription()

      if (subscription) {
        await subscription.unsubscribe()
      }

      await fetch('/push_subscriptions', {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfToken
        }
      })

      this.toggleTarget.checked = false
    } catch (error) {
      console.error('Erro ao desativar notificações push:', error)
      this.toggleTarget.checked = true
    }
  }
}
