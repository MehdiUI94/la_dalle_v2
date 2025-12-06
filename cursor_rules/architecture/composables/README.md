# Composables

## Pattern général

```typescript
import { ref, computed } from 'vue'

export function useFeature() {
  const state = ref<Type>(initialValue)
  const computedValue = computed(() => /* ... */)
  
  const action = async () => {
    // Logique
  }
  
  return {
    state,
    computedValue,
    action
  }
}
```

## Bonnes pratiques

- Un seul responsabilité par composable
- Nommer avec préfixe `use`
- Exposer uniquement ce qui est nécessaire
- Gérer les erreurs proprement
- Utiliser TypeScript strict

## Exemples dans le projet

- `useAuth.ts` : Authentification
- `useDeals.ts` : Gestion des deals (si créé)
- `useGeolocation.ts` : Géolocalisation (si créé)

