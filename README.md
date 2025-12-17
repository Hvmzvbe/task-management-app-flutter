# 📱 First App - Task Management Application

<div align="center">

![logo11](https://github.com/user-attachments/assets/5d7e280f-091a-4f1d-beba-ae11eeaeac23)

**Collaboration simplifiée pour vos équipes**  
Créez, assignez et suivez vos tâches efficacement

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Private-red)]()

</div>

---

## 🎬 Démonstration

<div align="center">
  <img src="assets/demo/welcome-animation.gif" alt="Welcome Animation" width="300"/>
</div>

---

## ✨ Fonctionnalités

### 🔐 Authentification
- ✅ Inscription avec validation complète des données
- ✅ Connexion sécurisée avec hashage des mots de passe (SHA-256)
- ✅ Gestion de session utilisateur
- ✅ Option "Se souvenir de moi"
- ✅ Stockage local avec Hive

### 📊 Gestion des Tâches
- 📝 Création et suivi des tâches
- 🎯 Système de priorités (Haute, Moyenne, Basse)
- 📅 Dates d'échéance
- ✅ Marquage des tâches terminées
- 📈 Statistiques en temps réel

### 👤 Profil Utilisateur
- 👤 Gestion du profil personnel
- 🔔 Paramètres de notifications
- 🔒 Options de sécurité
- 🌙 Mode sombre / clair

### 🎨 Interface Utilisateur
- 💫 Animations fluides et élégantes
- 🎨 Design moderne et intuitif
- 📱 Interface responsive
- 🌗 Support du thème clair et sombre
- 🎭 Transitions de page personnalisées

---

## 🛠️ Technologies Utilisées

| Technologie | Description |
|------------|-------------|
| **Flutter** | Framework UI multi-plateforme |
| **Dart** | Langage de programmation |
| **Hive** | Base de données NoSQL locale |
| **GetX** | State Management & Navigation |
| **Iconsax** | Bibliothèque d'icônes moderne |
| **Simple Animations** | Animations personnalisées |
| **Crypto** | Hashage sécurisé des mots de passe |

---

## 📦 Dépendances Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5                    # State management
  hive: ^2.2.3                   # Local database
  hive_flutter: ^1.1.0           # Hive Flutter integration
  get_storage: ^2.0.5            # Key-value storage
  iconsax: ^0.0.8                # Modern icons
  simple_animations: ^5.2.0      # Animations
  page_transition: ^2.0.9        # Page transitions
  crypto: ^3.0.3                 # Password hashing
  intl: ^0.18.0                  # Internationalization
  logger: ^2.0.0                 # Logging utility
```

---

## 🚀 Installation

### Prérequis
- Flutter SDK (≥3.9.2)
- Dart SDK (≥3.9.2)
- Android Studio / VS Code
- Git

### Étapes d'installation

1. **Cloner le repository**
```bash
git clone <your-repository-url>
cd first_app
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Générer les fichiers Hive**
```bash
flutter packages pub run build_runner build
```

4. **Lancer l'application**
```bash
flutter run
```

---

## 📁 Structure du Projet

```
lib/
├── animation/              # Animations personnalisées
│   └── FadeAnimation.dart
├── common/                 # Widgets réutilisables
│   ├── style/
│   └── widgets/
├── models/                 # Modèles de données
│   ├── user_model.dart
│   └── user_model.g.dart
├── screen/                 # Écrans de l'application
│   ├── Auth/
│   │   ├── login_page.dart
│   │   └── signup_page.dart
│   ├── Home/
│   │   └── HomeScreen.dart
│   ├── NavigationMenu.dart
│   ├── TasksScreen.dart
│   ├── NotificationsScreen.dart
│   └── ProfileScreen.dart
├── services/               # Services métier
│   └── auth_service.dart
├── utils/                  # Utilitaires
│   ├── constants/
│   ├── device/
│   ├── formatters/
│   ├── helpers/
│   ├── local_storage/
│   ├── logging/
│   ├── theme/
│   └── validators/
└── main.dart              # Point d'entrée
```

---

## 🎨 Thèmes et Design

### Palette de Couleurs

| Couleur | Light | Dark | Usage |
|---------|-------|------|-------|
| Primary | `#4b68ff` | `#4b68ff` | Actions principales |
| Secondary | `#FFE24B` | `#FFE24B` | Éléments secondaires |
| Accent | `#b0c7ff` | `#b0c7ff` | Accents |
| Background | `#FFFFFF` | `#000000` | Arrière-plan |
| Surface | `#F6F6F6` | `#272727` | Surfaces |

### Typographie
- **Police principale**: Poppins
- **Tailles**: Small (14px), Medium (16px), Large (18px)
- **Poids**: Light (300), Regular (400), Medium (500), SemiBold (600), Bold (800)

---

## 🔒 Sécurité

- ✅ Hashage des mots de passe avec SHA-256
- ✅ Validation des entrées utilisateur
- ✅ Stockage sécurisé avec Hive
- ✅ Gestion des sessions
- ✅ Protection contre les injections

---


## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

---

## 📄 License

Ce projet est privé et non destiné à la publication publique.

---

## 👨‍💻 Auteur

  
- GitHub: [@Hvmzvbe](https://github.com/Hvmzvbe)
- Email: hamzabeng64@gmail.com

---


<div align="center">
  <p>Fait avec ❤️ en Flutter</p>


<img src="assets/logos/logoWhite.png" width="100" alt="Logo"/>
  

</div>
