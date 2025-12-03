# 🍕 LA DALLE

Application web pour découvrir les meilleurs deals "1 acheté = 1 offert" dans les restaurants de Paris.

## 🚀 Technologies

- **Vue 3** avec Composition API
- **Vite** pour le build et le dev server
- **TypeScript** pour le typage
- **Vue Router** pour la navigation
- **Pinia** pour la gestion d'état
- **Tailwind CSS** pour le styling
- **Leaflet** + **OpenStreetMap** pour les cartes (100% gratuit)
- **Supabase** pour le backend et la base de données

## 📋 Prérequis

- Node.js 18+ et npm
- Un compte Supabase

## 🛠️ Installation

1. **Cloner le repository**
   ```bash
   git clone https://github.com/votre-username/la_dalle_v2.git
   cd la_dalle_v2
   ```

2. **Installer les dépendances**
   ```bash
   npm install
   ```

3. **Configurer les variables d'environnement**
   
   Créez un fichier `.env` à la racine du projet :
   ```env
   VITE_SUPABASE_URL=https://votre-projet.supabase.co
   VITE_SUPABASE_ANON_KEY=votre-anon-key-ici
   ```

4. **Lancer le serveur de développement**
   ```bash
   npm run dev
   ```

5. **Ouvrir dans le navigateur**
   
   L'application sera disponible sur `http://localhost:5173`

## 📚 Scripts disponibles

- `npm run dev` - Lance le serveur de développement
- `npm run build` - Build de production
- `npm run preview` - Prévisualise le build de production

## 🗄️ Base de données

La base de données Supabase contient les tables suivantes :
- `profiles` - Profils utilisateurs (clients et restaurants)
- `clients` - Informations des clients
- `restaurants` - Informations des restaurants
- `deals` - Offres "1+1" créées par les restaurants
- `favorites` - Favoris des clients

Consultez `docs/supabase/` pour la documentation complète.

## 🗺️ Carte interactive

L'application utilise Leaflet avec OpenStreetMap pour afficher les restaurants sur une carte interactive. Les données sont mises à jour automatiquement chaque jour à 00h00.

## 🚀 Déploiement

Consultez `DEPLOY.md` pour un guide rapide de déploiement sur Vercel ou Netlify.

## 📝 Documentation

- `docs/supabase/` - Documentation Supabase
- `docs/deployment.md` - Guide de déploiement détaillé
- `docs/map-setup.md` - Configuration de la carte

## 👥 Utilisateurs de test

**Client :**
- Email: `client@test.com`
- Mot de passe: `test123456`

**Restaurant :**
- Email: `resto@test.com`
- Mot de passe: `test123456`

## 📄 Licence

Ce projet est privé.
