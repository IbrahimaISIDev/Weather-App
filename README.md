# 🌤️ Météo Magique - Ultra Premium Edition

Météo Magique est une application Flutter de pointe qui transforme la consultation météorologique en une expérience immersive et "magique". Alliant un design **Glassmorphism** sophistiqué, des animations **Lottie** fluides et une intégration de données en temps réel, elle redéfinit les standards esthétiques des applications météo.

---

## ✨ Points Forts de l'Expérience

### 🎨 Design & Esthétique Premium
- **Glassmorphism** : Interface aérienne utilisant des effets de flou de fond (`BackdropFilter`) et des cartes dépolies.
- **Typographie Moderne** : Utilisation des polices *Outfit* (Titres) et *Inter* (Contenu) via **Google Fonts**.
- **Thèmes Adaptatifs** : Support complet du Mode Sombre et Mode Clair, synchronisé avec les paramètres système.

### 🎭 Animations Intelligentes
- **Icônes Lottie Dynamiques** : Les conditions météo sont illustrées par des animations vectorielles de haute qualité qui s'adaptent au temps réel.
- **Jauge de Progression Custom** : Une jauge de chargement circulaire avec effet de lueur (*Glow*) peinte sur mesure via `CustomPainter`.
- **Transitions Hero** : Navigation fluide et continue entre les écrans pour les éléments clés (températures, icônes).

### 📊 Visualisation & Données
- **Sparklines de Tendance** : Graphiques linéaires minimalistes (`fl_chart`) montrant l'évolution des températures.
- **Cartographie Intégrée** : Localisation précise des villes via l'API **Google Maps**.
- **Calculs Avancés** : Affichage du ressenti, de l'humidité, de la vitesse du vent et de la visibilité.

---

## 🚀 Guide de Démarrage Rapide

### Configuration Requise
- Flutter (>= 3.0.0)
- Une clé API [OpenWeatherMap](https://openweathermap.org/api)
- Une clé API [Google Maps](https://console.cloud.google.com/)

### Installation

1. **Cloner le projet**
   ```bash
   git clone git@github.com:IbrahimaISIDev/Weather-App.git
   cd Weather-App
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Configurer l'environnement**
   Créez un fichier `.env` à la racine du projet en vous basant sur `.env.example` :
   ```env
   OPENWEATHER_API_KEY=votre_cle_ici
   GOOGLE_MAPS_API_KEY=votre_cle_ici
   ```

4. **Lancer l'application**
   ```bash
   flutter run
   ```

---

## 🏗️ Architecture & Stack Technique

L'application suit une architecture modulaire et scalable :

- **State Management** : `Provider` pour une gestion réactive et découplée de l'état.
- **Networking** : `Retrofit` & `Dio` pour des appels API typés et performants.
- **Serialisation** : `JsonSerializable` pour un mapping objet-JSON robuste.
- **UI & Animations** : `flutter_animate`, `lottie`, `google_fonts`, `fl_chart`.
- **Navigation** : Routage nommé pour une transition simplifiée entre les écrans.

---

## 📂 Structure du Projet

```text
lib/
├── core/           # Thèmes, constantes et configurations réseau
├── models/         # Modèles de données (Weather, Forecast, etc.)
├── providers/      # Logique métier et gestion d'état
├── screens/        # Écrans de l'application (Welcome, Home, Detail)
├── services/       # Clients API et services d'abstraction
└── widgets/        # Composants UI réutilisables (GlassCard, Gauge, Icons)
```

---

## 👥 Équipe de Développement

- **Pape Mbaye GAYE**
- **Ibrahima Sory DIALLO** 
- **Ibrahima SARR** 

---

## 📜 Licence
Distribué sous la licence MIT. Voir `LICENSE` pour plus d'informations.

---
*Réalisé avec ❤️ par l'équipe Météo Magique.*
