const onPush = (event) => {
  console.log("[Serviceworker]", "Push event!", event.data.json());
  const { title, ...options } = event.data.json();

  const showNotification = self.registration.showNotification(title, {
    ...options,
  });

  event.waitUntil(showNotification);
};

self.addEventListener("push", onPush);
