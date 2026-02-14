import { Controller } from "@hotwired/stimulus"

const ACTIVE_CLASSES = ['text-primary']
const ACTIVE_DESKTOP_CLASSES = ['text-primary', 'border-b-2', 'border-primary', 'pb-[30px]']
const INACTIVE_CLASSES = ['hover:text-secondary']
const ALL_LINK_CLASSES = [...new Set([...ACTIVE_CLASSES, ...ACTIVE_DESKTOP_CLASSES, ...INACTIVE_CLASSES])]

const MOBILE_BREAKPOINT = 768

export default class extends Controller {
  static targets = ['menu', 'iconOpen', 'iconClose', 'links']
  static values = { open: { type: Boolean, default: false } }

  connect() {
    this.updateLinks()
  }

  toggle() {
    this.openValue = !this.openValue
  }

  close() {
    this.openValue = false
  }

  // Callback automático do Stimulus quando openValue muda
  openValueChanged() {
    if (this.openValue) {
      this.menuTarget.classList.remove('max-md:hidden')
      this.iconOpenTarget.classList.add('hidden')
      this.iconCloseTarget.classList.remove('hidden')
    } else {
      this.menuTarget.classList.add('max-md:hidden')
      this.iconOpenTarget.classList.remove('hidden')
      this.iconCloseTarget.classList.add('hidden')
    }
  }

  updateLinks() {
    const currentPath = window.location.pathname
    const isDesktop = window.innerWidth >= MOBILE_BREAKPOINT

    this.linksTargets.forEach((link) => {
      const linkPath = new URL(link.href, window.location.origin).pathname

      link.classList.remove(...ALL_LINK_CLASSES)

      if (linkPath === currentPath) {
        if (isDesktop) {
          link.classList.add(...ACTIVE_DESKTOP_CLASSES)
        } else {
          link.classList.add(...ACTIVE_CLASSES)
        }
      } else {
        link.classList.add(...INACTIVE_CLASSES)
      }
    })
  }
}
