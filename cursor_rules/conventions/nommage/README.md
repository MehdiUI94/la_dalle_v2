# Conventions de nommage

## Fichiers

- **Composants Vue** : PascalCase (`Header.vue`, `RestaurantMap.vue`)
- **Composables** : camelCase avec préfixe `use` (`useAuth.ts`, `useDeals.ts`)
- **Stores Pinia** : camelCase (`user.ts`, `deals.ts`)
- **Types/Interfaces** : PascalCase (`User.ts`, `RestaurantProfile.ts`)
- **Utilitaires** : camelCase (`share.ts`, `constants.ts`)

## Variables et fonctions

- **Variables** : camelCase (`userName`, `restaurantCount`)
- **Constantes** : UPPER_SNAKE_CASE (`MAX_DEALS`, `API_URL`)
- **Fonctions** : camelCase (`fetchRestaurants`, `handleLogin`)
- **Composants** : PascalCase (`UserProfile`, `DealCard`)

## Classes CSS

- Utiliser Tailwind CSS (classes utilitaires)
- Classes personnalisées : kebab-case (`.custom-scrollbar`, `.hero-logo`)

## Types TypeScript

- **Interfaces** : PascalCase avec suffixe optionnel (`User`, `UserProfile`)
- **Types** : PascalCase (`Role`, `DealCategory`)
- **Génériques** : Lettre majuscule (`T`, `K`, `V`)



