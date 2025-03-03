import { Controller } from "@hotwired/stimulus";
//import { post } from "@rails/request.js";

export default class extends Controller {
  connect() {
    this.vapidPublicKey = document.querySelector(
      'meta[name="vapid-public-key"]'
    ).content;
    this.userId = document.querySelector('meta[name="user-id"]').content;
  }

  async registerPushNotifications() {
    const registration = await navigator.serviceWorker.ready;
    const subscription = await registration.pushManager.getSubscription();

    if (!subscription) {
      subscription = await registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: this.vapidPublicKey,
      });
    }

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
    console.log(body);

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
      console.log("Push subscription created successfully");
      console.log(response);
    } else {
      console.log(response);
      console.error("Error creating push subscription");
    }
  }

  saveSubscription(subscription) {
    console.log(subscription);
  }
}
