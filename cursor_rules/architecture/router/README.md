# Router Vue Router

## Configuration

- Fichier principal : `src/router/index.ts`
- Routes définies avec `createRouter` et `createWebHistory`
- Meta pour contrôler l'affichage du header/footer

## Patterns

- Routes nommées pour la navigation
- Guards pour protéger les routes
- Lazy loading des composants avec `import()`
- Transitions entre les pages

## Meta routes

- `hideHeader` : Masquer le header
- `hideBottomNav` : Masquer la navigation bottom
- `transition` : Nom de la transition

## Exemple

```typescript
{
  path: '/profile',
  name: 'profile',
  component: () => import('../views/ProfileView.vue'),
  meta: { transition: 'fade' }
}
```



