const registerServiceWorker = async () => {
  if (navigator.serviceWorker) {
    try {
      await navigator.serviceWorker.register("/service-worker.js");
      console.log("Service worker registered!");
    } catch (error) {
      console.error("Error registering service worker: ", error);
    }
  }
};

registerServiceWorker();
