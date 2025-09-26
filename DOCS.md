# Game Hub - Batafsil Hujjatlar

Game Hub loyihasining to'liq texnik hujjatlari va arxitektura ma'lumotlari.

## 📁 Loyiha Tuzilishi

### Clean Architecture Yondashuvi

Loyiha Clean Architecture printsiplari asosida qurilgan:

```
lib/
├── core/                          # Umumiy kodlar va utillar
│   ├── constants/                 # Ilovaning konstantalari
│   ├── errors/                    # Xatoliklar va failures
│   ├── network/                   # Tarmoq konfiguratsiyasi (Dio)
│   ├── theme/                     # Ilovaning mavzusi va uslublari
│   ├── widgets/                   # Umumiy widgetlar
│   └── data/                      # Umumiy data modellari
├── features/                      # Xususiyat modullari
│   ├── authentication/            # Autentifikatsiya
│   ├── home/                      # Asosiy sahifa
│   ├── games/                     # O'yinlar bo'limi
│   ├── profile/                   # Foydalanuvchi profili
│   ├── tournaments/               # Turnirlar
│   ├── challenges/                # Bellashuvlar
│   └── rating/                    # Reyting tizimi
└── injection_container.dart       # Dependency injection
```

### Har bir Feature moduli tuzilishi:

```
feature/
├── data/                          # Ma'lumot qatlami
│   ├── datasources/              # Ma'lumot manbalari (API, Local)
│   ├── models/                   # Ma'lumot modellari
│   └── repositories/             # Repository implementatsiyasi
├── domain/                       # Biznes logika qatlami
│   ├── entities/                 # Biznes ob'ektlari
│   ├── repositories/             # Repository interfeyslari
│   └── usecases/                 # Foydalanish holatlari
└── presentation/                 # UI qatlami
    ├── bloc/                     # BLoC state management
    ├── pages/                    # Sahifalar
    └── widgets/                  # UI komponentlari
```

## 🎨 UI/UX Dizayni

### Rang Palitrasi

Game Hub maxsus gaming mavzusida ishlab chiqilgan:

```dart
// Asosiy ranglar
primary: #6C63FF (Binafsha)
secondary: #00D9FF (Cyan)
accent: #FF6B35 (To'q sariq)

// Fon va sirt ranglari
background: #0A0A0A (Chuqur qora)
surface: #1A1A1A (To'q kulrang)
cardBackground: #1E1E1E (Karta foni)

// Neon effektlar
neonGreen: #39FF14
neonBlue: #1B03A3
neonPink: #FF10F0
neonOrange: #FF8C00
```

### Gradientlar

```dart
// Asosiy gradient
primaryGradient: [primary → primaryDark]

// O'yin gradient
gameGradient: [neonBlue → primary → neonPink]
```

## 🏗️ Texnik Arxitektura

### State Management - BLoC Pattern

Barcha state boshqaruvi BLoC pattern orqali amalga oshiriladi:

```dart
// Event → BLoC → State
AuthEvent → AuthBloc → AuthState
```

### Dependency Injection - GetIt + Injectable

```dart
@injectable
class AuthRepository implements IAuthRepository {
  // Implementation
}

// Ro'yxatdan o'tkazish
final getIt = GetIt.instance;
await getIt.init();
```

### Network Layer - Dio

HTTP so'rovlar uchun Dio kutubxonasi ishlatiladi:

```dart
@injectable
class DioClient {
  late Dio _dio;

  // Dio konfiguratsiyasi
}
```

## 📱 Xususiyatlar

### 1. Autentifikatsiya (Authentication)
- **Entities**: `User`
- **Use Cases**: `Login`, `Register`, `Logout`
- **State**: `AuthBloc` (AuthInitial, AuthLoading, AuthSuccess, AuthFailure)
- **UI**: Custom text fields, gradient buttons

### 2. Asosiy Sahifa (Home Dashboard)
- Real-time statistikalar
- Tezkor harakatlar (Quick Actions)
- So'nggi faoliyat tarixchi
- Navigation drawer

### 3. O'yinlar (Games)
- O'yinlar katalogi
- Kategoriya filtrlari
- Qidiruv funksiyasi
- O'yin reytingi

### 4. Turnirlar (Tournaments)
- **Entity**: `Tournament`
- **Format**: SingleElimination, DoubleElimination, RoundRobin, Swiss
- **Status**: Upcoming, Ongoing, Completed, Cancelled
- Ro'yxatdan o'tish tizimi
- Prize pool

### 5. Bellashuvlar (Challenges)
- **Entity**: `Challenge`
- O'yinchilar o'rtasidagi raqobat
- Challenge yaratish va qabul qilish
- Real-time kuzatuv

### 6. Reyting Tizimi (Rating)
- **Entity**: `Rating`
- ELO-based rating algoritmi
- Leaderboard
- Reyting tarixi
- O'yin bo'yicha alohida reytinglar

### 7. Profil (Profile)
- Foydalanuvchi ma'lumotlari
- Statistikalar
- Yutuqlar (Achievements)
- O'yin tarixi

## 🔧 Development Commands

### Dependency Management
```bash
# Dependencies o'rnatish
flutter pub get

# Dependencies yangilash
flutter pub upgrade
```

### Code Generation
```bash
# JSON serialization va Dependency Injection
flutter packages pub run build_runner build

# Konfliktlarni hal qilish
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch mode
flutter packages pub run build_runner watch
```

### Testing
```bash
# Barcha testlarni ishga tushirish
flutter test

# Coverage bilan
flutter test --coverage

# Integration testlar
flutter drive --target=test_driver/app.dart
```

### Code Quality
```bash
# Static analiz
flutter analyze

# Formatting
flutter format .

# Lint tekshiruvi
flutter pub run dart_code_metrics:metrics analyze lib
```

### Build Commands
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Desktop
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## 📦 Dependencies

### Production Dependencies
```yaml
# Core Flutter
flutter: sdk
cupertino_icons: ^1.0.8

# State Management
flutter_bloc: ^8.1.6
bloc: ^8.1.4
equatable: ^2.0.5

# Dependency Injection
get_it: ^8.0.2
injectable: ^2.4.4

# Network
dio: ^5.7.0

# Local Storage
shared_preferences: ^2.3.3

# JSON Serialization
json_annotation: ^4.9.0

# Functional Programming
dartz: ^0.10.1
```

### Development Dependencies
```yaml
# Testing
flutter_test: sdk
flutter_lints: ^5.0.0

# Code Generation
build_runner: ^2.4.13
json_serializable: ^6.8.0
injectable_generator: ^2.6.2
```

## 🚀 Platform Support

Game Hub quyidagi platformalarni qo'llab-quvvatlaydi:

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12+)
- ✅ **Web** (Modern browsers)
- ✅ **macOS** (macOS 10.14+)
- ✅ **Windows** (Windows 10+)
- ✅ **Linux** (Ubuntu 20.04+)

## 🔒 Xavfsizlik

### Authentication
- JWT token based authentication
- Secure token storage
- Token refresh mechanism

### Data Protection
- API keys in environment variables
- No sensitive data in logs
- Encrypted local storage

### Network Security
- HTTPS only
- Certificate pinning
- Request/Response encryption

## 📊 Performance Optimizations

### UI Optimizations
- Widget caching
- Image lazy loading
- Pagination for large lists
- State management optimization

### Network Optimizations
- Request deduplication
- Response caching
- Connection pooling
- Timeout configurations

## 🔮 Kelajak Rejalari

### Version 2.0
- [ ] Real-time chat system
- [ ] Video streaming integration
- [ ] Advanced tournament brackets
- [ ] Social features

### Version 2.1
- [ ] AI-powered matchmaking
- [ ] Advanced analytics
- [ ] Custom tournament rules
- [ ] Mobile notifications

## 🐛 Ma'lum Muammolar

### Known Issues
1. iOS simulator da gradient animatsiyasi sekin ishlaydi
2. Web versiyada ba'zi iconlar to'g'ri yuklanmaydi
3. Android da navigation animation ba'zida lag qiladi

### Workarounds
1. iOS simulatorni release mode da test qiling
2. Web uchun fallback iconlar qo'shilgan
3. Android animation duration kamaytirilgan

## 📞 Yordam va Qo'llab-quvvatlash

### Bug Reports
GitHub Issues orqali xato haqida xabar bering

### Feature Requests
Yangi xususiyatlar uchun GitHub Discussions ishlatng

### Documentation
Qo'shimcha hujjatlar `/docs` papkasida joylashgan

---

**Oxirgi yangilanish**: 2024-09-26
**Versiya**: 1.0.0
**Muallif**: Game Hub Development Team