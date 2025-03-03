const onPush = (event) => {
  const { title, ...options } = event.data.json();

  const showNotification = self.registration.showNotification(title, {
    ...options,
    data: {
      url: options.url,
    },
  });

  event.waitUntil(showNotification);
};

self.addEventListener("notificationclick", (event) => {
  let url = event.notification.data.url;
  event.waitUntil(
    clients
      .matchAll({
        type: "window",
      })
      .then((clientList) => {
        for (const client of clientList) {
          if (client.url === url && "focus" in client) return client.focus();
        }
        if (clients.openWindow) return clients.openWindow(url);
      })
  );
});

self.addEventListener("push", onPush);
