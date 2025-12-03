import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/user'
import HomeView from '@/views/HomeView.vue'
import DealsView from '@/views/DealsView.vue'
import MapView from '@/views/MapView.vue'
import ProfileView from '@/views/ProfileView.vue'
import LoginView from '@/views/LoginView.vue'
import ClientOnboarding from '@/views/onboarding/ClientOnboarding.vue'
import RestaurantOnboarding from '@/views/onboarding/RestaurantOnboarding.vue'
import RestaurantDashboard from '@/views/dashboard/RestaurantDashboard.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView
    },
    {
      path: '/deals',
      name: 'deals',
      component: DealsView
    },
    {
      path: '/map',
      name: 'map',
      component: MapView
    },
    {
      path: '/profile',
      name: 'profile',
      component: ProfileView
    },
    {
      path: '/onboarding/client',
      name: 'client-onboarding',
      component: ClientOnboarding
    },
    {
      path: '/onboarding/restaurant',
      name: 'restaurant-onboarding',
      component: RestaurantOnboarding
    },
    {
      path: '/dashboard/restaurant',
      name: 'restaurant-dashboard',
      component: RestaurantDashboard,
      meta: { requiresAuth: true, requiresRole: 'restaurant' }
    }
  ]
})

// Garde de navigation pour protéger les routes
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  
  if (to.meta.requiresAuth && !userStore.user) {
    next('/login')
  } else if (to.meta.requiresRole && userStore.user?.role !== to.meta.requiresRole) {
    // Rediriger selon le rôle
    if (userStore.user?.role === 'client') {
      next('/deals')
    } else {
      next('/login')
    }
  } else {
    next()
  }
})

export default router

