import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { pinia } from './stores'
import './style.css'
import { useAuth } from './composables/useAuth'

const app = createApp(App)

app.use(pinia)
app.use(router)

// Initialiser la session utilisateur au démarrage de l'application
router.isReady().then(async () => {
  const { checkSession } = useAuth()
  await checkSession()
  app.mount('#app')
})



