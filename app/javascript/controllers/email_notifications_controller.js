import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    const isChecked = event.target.checked
    const form = event.target.closest('form')
    
    if (form) {
      const formData = new FormData()
      formData.append('configuration[email_notifications]', isChecked ? '1' : '0')
      
      fetch(form.action, {
        method: 'PATCH',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.status === 'success') {
          // Show success feedback
          console.log('Configuração de notificações atualizada!')
          // You can add a toast notification here if you want
        }
      })
      .catch(error => {
        console.error('Erro ao atualizar configurações:', error)
        // Revert the toggle if there's an error
        event.target.checked = !isChecked
      })
    }
  }
}
