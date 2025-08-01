import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal", "button"];

  connect() {
    this.vapidPublicKey = document.querySelector(
      'meta[name="vapid-public-key"]'
    ).content;
    this.userId = document.querySelector('meta[name="user-id"]').content;

    if (!this.vapidPublicKey || !this.userId) {
      return;
    }

    this.updateButtonState();
  }

  async updateButtonState() {
    if (!window.PushManager) {
      this.buttonTarget.disabled = true;
      this.buttonTarget.innerHTML = "🔕 <span>Não Suportado</span>";
      return;
    }

    const permission = Notification.permission;

    if (permission === "granted") {
      const registration = await navigator.serviceWorker.ready;
      const subscription = await registration.pushManager.getSubscription();

      if (subscription) {
        this.buttonTarget.innerHTML = "🔔 <span>Notificações Ativas</span>";
        this.buttonTarget.classList.remove("btn-outline");
        this.buttonTarget.classList.add("btn-success");
      } else {
        this.buttonTarget.innerHTML = "🔔 <span>Ativar Notificações</span>";
        this.buttonTarget.classList.add("btn-outline");
        this.buttonTarget.classList.remove("btn-success");
      }
    } else {
      this.buttonTarget.innerHTML = "🔔 <span>Ativar Notificações</span>";
      this.buttonTarget.classList.add("btn-outline");
      this.buttonTarget.classList.remove("btn-success");
    }
  }

  async toggleNotifications() {
    if (!window.PushManager) {
      alert("Seu navegador não suporta notificações push.");
      return;
    }

    const permission = Notification.permission;

    if (permission === "granted") {
      // Se já tem permissão, registra/atualiza a subscription
      await this.registerPushNotifications();
    } else if (permission === "denied") {
      alert(
        "As notificações foram negadas. Por favor, habilite nas configurações do seu navegador."
      );
    } else {
      // Mostra o modal customizado primeiro
      this.showCustomModal();
    }
  }

  showCustomModal() {
    this.modalTarget.classList.remove("hidden");
    this.modalTarget.classList.add("flex");
  }

  hideCustomModal() {
    this.modalTarget.classList.add("hidden");
    this.modalTarget.classList.remove("flex");
  }

  async activateNotifications() {
    this.hideCustomModal();

    try {
      const permission = await Notification.requestPermission();

      if (permission === "granted") {
        await this.registerPushNotifications();
        this.updateButtonState();
      } else {
        console.log(
          `Permission to receive notifications has been ${permission}`
        );
        this.updateButtonState();
      }
    } catch (error) {
      console.error("Error requesting notification permission", error);
    }
  }

  async registerPushNotifications() {
    try {
      const registration = await navigator.serviceWorker.ready;
      let subscription = await registration.pushManager.getSubscription();

      // Se já existe uma subscription, vamos atualizá-la
      if (subscription) {
        await subscription.unsubscribe();
      }

      // Cria uma nova subscription
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

      await this.saveSubscription(body);
      this.updateButtonState();

      // Mostra uma notificação de teste
      new Notification("Notificações Ativadas!", {
        body: "Você receberá notificações sobre suas finanças.",
        icon: "/favicon.png",
      });
    } catch (error) {
      console.error("Error registering push notifications", error);
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
        console.log("Subscription saved successfully");
      } else {
        console.error("Failed to save subscription");
      }
    } catch (error) {
      console.error("Error saving subscription", error);
    }
  }
}
