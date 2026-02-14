import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner"]

  connect() {
    // Não mostrar se já está instalado como PWA
    if (window.matchMedia('(display-mode: standalone)').matches) return
    if (navigator.standalone) return

    // Não mostrar se o usuário dispensou nos últimos 7 dias
    const dismissed = localStorage.getItem('pwa-install-dismissed')
    if (dismissed && Date.now() - parseInt(dismissed) < 7 * 24 * 60 * 60 * 1000) return

    // Interceptar o prompt nativo do browser
    window.addEventListener('beforeinstallprompt', (e) => {
      e.preventDefault()
      this.deferredPrompt = e
      this.showBanner()
    })
  }

  showBanner() {
    this.bannerTarget.classList.remove('-translate-y-full', 'opacity-0')
    this.bannerTarget.classList.add('translate-y-0', 'opacity-100')
  }

  hideBanner() {
    this.bannerTarget.classList.remove('translate-y-0', 'opacity-100')
    this.bannerTarget.classList.add('-translate-y-full', 'opacity-0')
  }

  async install() {
    if (!this.deferredPrompt) return

    this.deferredPrompt.prompt()
    const { outcome } = await this.deferredPrompt.userChoice

    if (outcome === 'accepted') {
      this.hideBanner()
    }

    this.deferredPrompt = null
  }

  dismiss() {
    localStorage.setItem('pwa-install-dismissed', Date.now().toString())
    this.hideBanner()
  }

  close() {
    this.hideBanner()
  }
}
