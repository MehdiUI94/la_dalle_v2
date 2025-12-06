import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'home',
    component: () => import('../views/HomeView.vue'),
    meta: { transition: 'fade' }
  },
  {
    path: '/deals',
    name: 'deals',
    component: () => import('../views/DealsView.vue'),
    meta: { transition: 'fade' }
  },
  {
    path: '/map',
    name: 'map',
    component: () => import('../views/MapView.vue'),
    meta: { transition: 'fade' }
  },
  {
    path: '/profile',
    name: 'profile',
    component: () => import('../views/ProfileView.vue'),
    meta: { transition: 'fade' }
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('../views/LoginView.vue'),
    meta: { hideHeader: true, hideBottomNav: true, transition: 'fade' }
  },
  {
    path: '/signup',
    name: 'signup',
    component: () => import('../views/SignupView.vue'),
    meta: { hideHeader: true, hideBottomNav: true, transition: 'fade' }
  },
  {
    path: '/onboarding/client',
    name: 'client-onboarding',
    component: () => import('../views/onboarding/ClientOnboarding.vue'),
    meta: { hideBottomNav: true }
  },
  {
    path: '/onboarding/restaurant',
    name: 'restaurant-onboarding',
    component: () => import('../views/onboarding/RestaurantOnboarding.vue'),
    meta: { hideBottomNav: true }
  },
  {
    path: '/dashboard/restaurant',
    name: 'restaurant-dashboard',
    component: () => import('../views/dashboard/RestaurantDashboard.vue'),
    meta: { transition: 'fade' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router

