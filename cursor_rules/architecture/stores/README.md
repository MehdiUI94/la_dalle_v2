# Stores Pinia

## Pattern général

```typescript
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useFeatureStore = defineStore('feature', () => {
  const state = ref<Type>(initialValue)
  
  const getter = computed(() => /* ... */)
  
  const action = async () => {
    // Logique
  }
  
  return {
    state,
    getter,
    action
  }
})
```

## Bonnes pratiques

- Utiliser Composition API (setup stores)
- Un store par domaine fonctionnel
- Éviter les stores trop volumineux
- Gérer les erreurs et le loading state

## Stores dans le projet

- `user.ts` : État utilisateur, profil, points
- `deals.ts` : Liste des deals, filtres (si créé)



