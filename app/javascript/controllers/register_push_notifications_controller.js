import { Controller } from "@hotwired/stimulus";
//import { post } from "@rails/request.js";

export default class extends Controller {
  connect() {
    this.vapidPublicKey = document.querySelector(
      'meta[name="vapid-public-key"]'
    ).content;
    this.userId = document.querySelector('meta[name="user-id"]').content;

    if (!this.vapidPublicKey || !this.userId) {
      return;
    }

    if (window.PushManager) {
      this.checkPermission();
    } else {
      return;
    }
  }

  async registerPushNotifications() {
    const registration = await navigator.serviceWorker.ready;
    let subscription = await registration.pushManager.getSubscription();

    console.log("Subscription", subscription.toJSON());

    if (!subscription) {
      subscription = await registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: this.vapidPublicKey,
      });

      const {
        endpoint,
        keys: { p256dh, auth },
      } = subscription.toJSON();

      const body = JSON.stringify({
        push_subscription: {
          endpoint,
          p256dh: p256dh,
          auth: auth,
          user_id: this.userId,
        },
      });

      this.saveSubscription(body);
    }
  }

  async saveSubscription(body) {
    try {
      const response = await fetch("/push_subscriptions", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .content,
        },
        body,
      });

      if (response.ok) {
        console.log("Subscription saved");
      }
    } catch (error) {
      console.error("Error saving subscription", error);
    }
  }

  async checkPermission() {
    switch (Notification.permission) {
      case "granted":
        this.registerPushNotifications();
        break;
      case "denied":
        console.log("Permission to receive notifications has been denied");
        break;
      default:
        const permission = await Notification.requestPermission();
        if (permission === "granted") {
          this.registerPushNotifications();
        } else {
          console.log(
            `Permission to receive notifications has been ${permission}`
          );
        }
        break;
    }
  }
}
