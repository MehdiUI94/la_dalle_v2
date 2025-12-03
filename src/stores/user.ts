import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { User, Badge, Level } from '@/types/user'

const LEVELS: Level[] = [
  { level: 1, name: 'Bronze', pointsRequired: 0, color: '#cd7f32' },
  { level: 2, name: 'Silver', pointsRequired: 200, color: '#c0c0c0' },
  { level: 3, name: 'Gold', pointsRequired: 500, color: '#ffd700' },
  { level: 4, name: 'Platinum', pointsRequired: 1000, color: '#e5e4e2' },
]

export const useUserStore = defineStore('user', () => {
  const user = ref<User | null>(null)

  const currentLevel = computed(() => {
    if (!user.value) return LEVELS[0]
    return LEVELS.find(l => l.level === user.value.level) || LEVELS[0]
  })

  const nextLevel = computed(() => {
    if (!user.value) return null
    const next = LEVELS.find(l => l.level === user.value.level + 1)
    return next || null
  })

  const progressToNextLevel = computed(() => {
    if (!user.value || !nextLevel.value) return 100
    const currentPoints = user.value.points
    const currentLevelPoints = currentLevel.value.pointsRequired
    const nextLevelPoints = nextLevel.value.pointsRequired
    const progress = ((currentPoints - currentLevelPoints) / (nextLevelPoints - currentLevelPoints)) * 100
    return Math.min(Math.max(progress, 0), 100)
  })

  function updatePoints(points: number) {
    if (!user.value) return
    user.value.points += points
    checkLevelUp()
  }

  function checkLevelUp() {
    if (!user.value) return
    const next = nextLevel.value
    if (next && user.value.points >= next.pointsRequired) {
      levelUp()
    }
  }

  function levelUp() {
    if (!user.value || !nextLevel.value) return
    user.value.level = nextLevel.value.level
  }

  function addBadge(badge: Badge) {
    if (!user.value) return
    const exists = user.value.badges.find(b => b.id === badge.id)
    if (!exists) {
      user.value.badges.push({ ...badge, unlockedAt: new Date() })
      updatePoints(50) // Récompense pour badge
    }
  }

  function getStats() {
    if (!user.value) return { dealsUsed: 0, friendsInvited: 0, shares: 0, points: 0 }
    return {
      dealsUsed: 12,
      friendsInvited: 5,
      shares: 23,
      points: user.value.points
    }
  }

  function setUser(newUser: User) {
    user.value = newUser
  }

  function setTestUser(testUser: User) {
    user.value = testUser
  }

  function clearUser() {
    user.value = null
  }

  return {
    user,
    currentLevel,
    nextLevel,
    progressToNextLevel,
    updatePoints,
    levelUp,
    addBadge,
    getStats,
    setUser,
    setTestUser,
    clearUser
  }
})

