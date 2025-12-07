import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
import { useAuth } from '@/composables/useAuth'

const routes: RouteRecordRaw[] = [
  {
    path: '/signup',
    name: 'signup',
    component: () => import('../views/SignupView.vue'),
    meta: { hideHeader: true, hideBottomNav: true, transition: 'fade', public: true }
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('../views/LoginView.vue'),
    meta: { hideHeader: true, hideBottomNav: true, transition: 'fade', public: true }
  },
  {
    path: '/',
    name: 'home',
    component: () => import('../views/HomeView.vue'),
    meta: { transition: 'fade', requiresAuth: true }
  },
  {
    path: '/deals',
    name: 'deals',
    component: () => import('../views/DealsView.vue'),
    meta: { transition: 'fade', requiresAuth: true }
  },
  {
    path: '/map',
    name: 'map',
    component: () => import('../views/MapView.vue'),
    meta: { transition: 'fade', requiresAuth: true }
  },
  {
    path: '/ma-dalle',
    name: 'ma-dalle',
    component: () => import('../views/MaDalleView.vue'),
    meta: { transition: 'fade', requiresAuth: true }
  },
  {
    path: '/profile',
    name: 'profile',
    component: () => import('../views/ProfileView.vue'),
    meta: { transition: 'fade', requiresAuth: true }
  },
  {
    path: '/addresses',
    name: 'addresses',
    component: () => import('../views/AddressManagementView.vue'),
    meta: { transition: 'fade', requiresAuth: true }
  },
  {
    path: '/scan',
    name: 'scan',
    component: () => import('../views/QRScanView.vue'),
    meta: { transition: 'fade', requiresAuth: true }
  },
  {
    path: '/onboarding/etudiant',
    name: 'etudiant-onboarding',
    component: () => import('../views/onboarding/ClientOnboarding.vue'),
    meta: { hideBottomNav: true, requiresAuth: true }
  },
  {
    path: '/onboarding/restaurant',
    name: 'restaurant-onboarding',
    component: () => import('../views/onboarding/RestaurantOnboarding.vue'),
    meta: { hideBottomNav: true, requiresAuth: true }
  },
  {
    path: '/dashboard/restaurant',
    name: 'restaurant-dashboard',
    component: () => import('../views/dashboard/RestaurantDashboard.vue'),
    meta: { transition: 'fade', requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    // Toujours remettre le scroll en haut lors de la navigation
    return { top: 0, left: 0, behavior: 'smooth' }
  }
})

// Guard de navigation : rediriger vers /login si l'utilisateur n'est pas connecté
router.beforeEach(async (to, from, next) => {
  const { isAuthenticated, checkSession } = useAuth()
  
  // Charger la session si elle n'est pas encore chargée (première navigation)
  if (!isAuthenticated() && localStorage.getItem('la_dalle_user')) {
    await checkSession()
  }
  
  // Ajouter une meta propriété pour indiquer si on vient de l'accueil
  if (from.name === 'home' || from.path === '/') {
    to.meta.fromHome = true
  } else {
    to.meta.fromHome = false
  }
  
  // Si la route nécessite une authentification et que l'utilisateur n'est pas connecté
  if (to.meta.requiresAuth && !isAuthenticated()) {
    next('/login')
  }
  // Si l'utilisateur est connecté et essaie d'accéder à login/signup, rediriger vers home
  else if (to.meta.public && isAuthenticated()) {
    next('/')
  }
  else {
    next()
  }
})

export default router

