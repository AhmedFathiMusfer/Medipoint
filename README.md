# 🏥  Medipoint - تطبيق حجز المواعيد الطبية

<div align="center">
  <img src="assets/icons/logo.png" alt="Diagno Bot Logo" width="200"/>
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.7.2-02569B?logo=flutter)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.7.2-0175C2?logo=dart)](https://dart.dev)
  [![License](https://img.shields.io/badge/License-Private-red.svg)]()
  
  **تطبيق متكامل لحجز المواعيد الطبية والتواصل مع الأطباء المتخصصين**
</div>

---

## 📋 جدول المحتويات

- [نظرة عامة](#-نظرة-عامة)
- [المميزات الرئيسية](#-المميزات-الرئيسية)
- [البنية المعمارية](#-البنية-المعمارية)
- [التقنيات المستخدمة](#-التقنيات-المستخدمة)
- [البدء السريع](#-البدء-السريع)
- [هيكل المشروع](#-هيكل-المشروع)
- [الميزات التفصيلية](#-الميزات-التفصيلية)
- [إدارة الحالة](#-إدارة-الحالة)
- [قاعدة البيانات](#-قاعدة-البيانات)
- [الأمان](#-الأمان)
- [المساهمة](#-المساهمة)
- [الترخيص](#-الترخيص)

---

## 🌟 نظرة عامة

**Diagno Bot** هو تطبيق طبي متكامل مبني باستخدام Flutter يوفر منصة شاملة للمرضى لحجز المواعيد مع الأطباء المتخصصين، إدارة السجلات الطبية، والتواصل مع مقدمي الرعاية الصحية.

### الهدف
توفير تجربة سلسة وآمنة للمرضى للوصول إلى الخدمات الطبية عبر الإنترنت مع واجهة مستخدم جميلة وسهلة الاستخدام.

---

## ✨ المميزات الرئيسية

### 👤 إدارة المستخدمين
- ✅ تسجيل الدخول والتسجيل بنظام آمن
- ✅ التحقق من البريد الإلكتروني
- ✅ إعادة تعيين كلمة المرور
- ✅ تعديل الملف الشخصي
- ✅ تغيير كلمة المرور

### 🩺 الأطباء والتخصصات
- ✅ استعراض الأطباء حسب التخصصات
- ✅ البحث المتقدم عن الأطباء
- ✅ عرض تفاصيل الطبيب الشاملة
- ✅ التقييمات والمراجعات
- ✅ التعليقات التفاعلية (جديد! 🎉)

### 📅 حجز المواعيد
- ✅ حجز مواعيد جديدة
- ✅ عرض المواعيد القادمة
- ✅ تتبع المواعيد المكتملة والملغاة
- ✅ إلغاء المواعيد
- ✅ الدفع الإلكتروني عبر Stripe

### 🤖 التشخيص الذكي (AI Chatbot)
- ✅ **Chat with AI**: محادثة تفاعلية مع ذكاء اصطناعي متطور.
- ✅ **التشخيص الأولي**: تقديم تحليل مبدئي للأعراض والحالة الصحية.
- ✅ **اقتراح الأطباء**: ترشيح أفضل الأطباء المتخصصين بناءً على نتائج التشخيص.
- ✅ **توجيه المريض**: مساعدة المريض في اختيار التخصص الطبي الأنسب لحالته.

### 💬 التعليقات والتقييمات
- ✅ إضافة تعليقات على التقييمات
- ✅ تعديل وحذف التعليقات
- ✅ عرض التعليقات بتصميم جميل
- ✅ تمييز تعليقات الأطباء والمرضى
- ✅ عرض الوقت النسبي للتعليقات

### 📁 إدارة الملفات والسجلات
- ✅ إنشاء مجلدات للسجلات الطبية
- ✅ رفع الملفات والصور
- ✅ تنزيل وعرض الملفات
- ✅ مشاركة الملفات
- ✅ إعادة تسمية وحذف الملفات

### 💳 الدفع الإلكتروني
- ✅ التكامل مع Stripe
- ✅ الدفع الآمن للمواعيد
- ✅ سجل المعاملات المالية

### 🌐 التعدد اللغوي
- ✅ دعم العربية والإنجليزية
- ✅ تبديل سلس بين اللغات
- ✅ ترجمات شاملة لكل العناصر

---

## 🏗️ البنية المعمارية

يتبع المشروع **Clean Architecture** مع **Feature-First Approach**:

```
lib/
├── core/                    # الوظائف الأساسية المشتركة
│   ├── auth/               # المصادقة والتفويض
│   ├── database/           # قاعدة البيانات المحلية (Drift)
│   ├── di/                 # Dependency Injection
│   ├── helpers/            # دوال مساعدة
│   ├── model/              # النماذج المشتركة
│   ├── networking/         # طبقة الشبكة
│   ├── routing/            # التنقل بين الصفحات
│   ├── theming/            # الألوان والثيمات
│   └── widgets/            # Widgets مشتركة
│
├── features/               # الميزات حسب الوحدات
│   ├── appointment/        # المواعيد الطبية
│   ├── auth/              # التسجيل والدخول
│   ├── doctor/            # الأطباء والتفاصيل
│   ├── recordFiles/       # إدارة الملفات
│   ├── specialty/         # التخصصات الطبية
│   └── profile/           # الملف الشخصي
│
├── doc_app.dart           # التطبيق الرئيسي
└── main.dart              # نقطة البداية
```

### نمط BLoC
كل ميزة تحتوي على:
- **View**: واجهة المستخدم
- **Cubit**: إدارة حالة الميزة
- **State**: حالات الميزة المختلفة

---

## 🛠️ التقنيات المستخدمة

### Framework & Language
- **Flutter** `3.7.2` - إطار العمل الأساسي
- **Dart** `3.7.2` - لغة البرمجة

### State Management
- **flutter_bloc** `^8.1.6` - إدارة الحالة
- **equatable** `^2.0.5` - مقارنة الكائنات

### Networking
- **dio** `^5.4.0` - HTTP client
- **pretty_dio_logger** `^1.3.1` - تسجيل الطلبات

### Local Database
- **drift** `^2.7.0` - قاعدة بيانات SQLite
- **sqlite3_flutter_libs** - مكتبات SQLite

### Firebase
- **firebase_core** `^3.3.0`
- **firebase_auth** `^5.3.0`
- **cloud_firestore** `^5.4.0`

### UI & Design
- **flutter_screenutil** `^5.9.0` - Responsive design
- **google_fonts** `^6.1.0` - خطوط Google
- **flutter_svg** `^2.0.7` - صور SVG
- **lottie** `^3.0.0` - رسوم متحركة
- **cached_network_image** `^3.4.1` - تخزين الصور مؤقتاً
- **shimmer** `^3.0.0` - تأثيرات التحميل
- **flutter_animate** `^4.5.0` - رسوم متحركة متقدمة

### Localization
- **easy_localization** `^3.0.5` - الترجمة والتعريب

### Payments
- **flutter_stripe** `^12.1.1` - بوابة الدفع

### Files & Media
- **image_picker** `^1.0.7` - اختيار الصور
- **file_picker** `^10.1.2` - اختيار الملفات
- **flutter_image_compress** `^2.0.3` - ضغط الصور
- **photo_view** `^0.15.0` - عرض الصور
- **share_plus** `^7.2.1` - مشاركة الملفات

### Utilities
- **get_it** `^7.6.4` - Service locator
- **shared_preferences** `^2.3.0` - التخزين المحلي
- **flutter_secure_storage** `^9.0.0` - تخزين آمن
- **permission_handler** `^11.1.0` - إدارة الأذونات
- **table_calendar** `^3.0.9` - التقويم
- **freezed** - Code generation للنماذج

---

## 🚀 البدء السريع

### المتطلبات الأساسية
- Flutter SDK `>=3.7.2`
- Dart SDK `>=3.7.2`
- Android Studio / VS Code
- Firebase Account
- Stripe Account

### التثبيت

1. **استنساخ المشروع**
```bash
git clone https://github.com/your-repo/diagno_bot.git
cd diagno_bot
```

2. **تثبيت المكتبات**
```bash
flutter pub get
```

3. **توليد الملفات**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **إعداد Firebase**
- أنشئ مشروع في Firebase Console
- أضف ملفات التكوين:
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`

5. **إعداد Stripe**
- احصل على مفاتيح API من Stripe Dashboard
- أضف المفاتيح في ملف `.env`:
```env
STRIPE_PUBLISHABLE_KEY=your_key_here
STRIPE_SECRET_KEY=your_key_here
```

6. **تشغيل التطبيق**
```bash
flutter run
```

---

## 📁 هيكل المشروع التفصيلي

### Core Modules

#### 🔐 Authentication (`core/auth/`)
- إدارة الجلسات
- Token management
- Auto-refresh tokens

#### 💾 Database (`core/database/`)
- **Tables:**
  - `users` - المستخدمين
  - `doctors` - الأطباء
  - `appointments` - المواعيد
  - `reviews` - التقييمات
  - `comments` - التعليقات
  - `folders` - المجلدات
  - `files` - الملفات

#### 🌐 Networking (`core/networking/`)
- API client configuration
- Error handling
- Request/Response interceptors
- Retry logic

#### 🎨 Theming (`core/theming/`)
- ColorManager - إدارة الألوان
- TextStyles - أنماط النصوص
- Theme configuration

### Feature Modules

#### 📅 Appointments (`features/appointment/`)
**State Management:**
- `AppointmentCubit` - إدارة المواعيد
- `AppointmentState` - حالات المواعيد (Pending, Paid, Done, Canceled)

**Features:**
- عرض المواعيد بثلاث تبويبات (القادمة، المكتملة، الملغاة)
- حجز موعد جديد مع التقويم
- الدفع المباشر
- إلغاء المواعيد

#### 🩺 Doctors (`features/doctor/`)
**Sub-features:**
- **Details:** تفاصيل الطبيب الكاملة
- **Reviews:** التقييمات والمراجعات
- **Comments:** نظام التعليقات المتطور

**Comment System Features:**
- إضافة تعليقات جديدة
- تعديل التعليقات
- حذف التعليقات
- تمييز بصري لنوع المعلق (طبيب/مريض)
- عرض الوقت النسبي

#### 🤖 AI Chatbot (`features/chat/`)
**المميزات الذكية:**
- **التشخيص الأولي (Initial Diagnosis):** تحليل الأعراض التي يدخلها المريض باستخدام نماذج ذكاء اصطناعي متطورة لتقديم رؤية مبدئية للحالة.
- **اقتراح الأطباء (Doctor Suggestions):** يقوم النظام تلقائياً بترشيح الأطباء الأكثر كفاءة والمناسبين لنوع المرض أو الحالة التي تم تشخيصها.
- **توجيه التخصصات:** مساعدة المريض في الوصول إلى التخصص الطبي الصحيح (مثلاً: توجيهه لطبيب قلب بناءً على أعراض معينة).
- **محادثة تفاعلية:** واجهة شات ذكية تدعم التواصل المباشر والسريع.

#### 📁 Record Files (`features/recordFiles/`)
**Structure:**
- **Folders:** إدارة المجلدات
  - إنشاء مجلدات جديدة
  - تعديل وحذف المجلدات
  - البحث في المجلدات
  
- **Files:** إدارة الملفات
  - رفع ملفات (صور/PDF)
  - تنزيل الملفات
  - عرض الملفات
  - مشاركة الملفات
  - إعادة تسمية وحذف

---

## 🔄 إدارة الحالة

### BLoC Pattern
استخدام **Cubit** من `flutter_bloc`:

```dart
class ExampleCubit extends Cubit<ExampleState> {
  ExampleCubit() : super(ExampleState.initial());

  Future<void> loadData() async {
    emit(ExampleState.loading());
    try {
      final data = await repository.getData();
      emit(ExampleState.success(data));
    } catch (e) {
      emit(ExampleState.error());
    }
  }
}
```

### Freezed States
استخدام `freezed` للحالات:

```dart
@freezed
class ExampleState with _$ExampleState {
  const factory ExampleState.initial() = _Initial;
  const factory ExampleState.loading() = _Loading;
  const factory ExampleState.success(List<Data> data) = _Success;
  const factory ExampleState.error() = _Error;
}
```

---

## 💾 قاعدة البيانات

### Drift (SQLite)
استخدام **Drift** لقاعدة البيانات المحلية:

**مزايا:**
- ✅ Type-safe queries
- ✅ Auto-generated DAO
- ✅ Reactive streams
- ✅ Migration support

**مثال:**
```dart
@DriftDatabase(tables: [Users, Doctors, Appointments])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  @override
  int get schemaVersion => 1;
}
```

### التزامن
- تخزين البيانات محلياً للوصول السريع
- التزامن التلقائي مع الخادم
- العمل بدون اتصال بالإنترنت

---

## 🌍 التعريب

### Easy Localization
دعم اللغات: **العربية** 🇸🇦 | **الإنجليزية** 🇺🇸

**الملفات:**
- `assets/translations/ar.json` - الترجمة العربية (205 مفتاح)
- `assets/translations/en.json` - الترجمة الإنجليزية (205 مفتاح)

**الاستخدام:**
```dart
Text('welcome'.tr())        // مرحباً / Welcome
Text('app_name'.tr())       // تطبيق الطبيب / Doc App
```

**تبديل اللغة:**
```dart
context.setLocale(Locale('ar'));  // العربية
context.setLocale(Locale('en'));  // الإنجليزية
```

---

## 🔒 الأمان

### التشفير والحماية
- ✅ **Flutter Secure Storage** - تخزين آمن للبيانات الحساسة
- ✅ **Token-based Authentication** - JWT tokens
- ✅ **HTTPS Only** - جميع الطلبات مشفرة
- ✅ **Input Validation** - التحقق من المدخلات
- ✅ **SQL Injection Protection** - حماية من SQL injection

### إدارة الأذونات
```dart
- Camera (للصور)
- Storage (للملفات)
- Internet (للاتصال بالخادم)
```

---

## 📱 الشاشات الرئيسية

### 🏠 الرئيسية
- عرض الأطباء المميزين
- التخصصات الطبية
- الوصول السريع للميزات

### 👨‍⚕️ الأطباء
- قائمة الأطباء مع الفلترة
- البحث المتقدم
- عرض التفاصيل الكاملة
- التقييمات والتعليقات

### 📅 المواعيد
- قائمة المواعيد (ثلاث تبويبات)
- حجز موعد جديد
- الدفع الإلكتروني
- إدارة المواعيد

### 📁 الملفات
- المجلدات والملفات
- رفع وتنزيل
- معاينة الملفات
- المشاركة

### 👤 الملف الشخصي
- معلومات المستخدم
- تعديل البيانات
- تغيير كلمة المرور
- الإعدادات

---

## 🎨 التصميم

### Design System
- **Primary Color:** أزرق طبي (#2196F3)
- **Accent Color:** أخضر (#4CAF50)
- **Error Color:** أحمر (#F44336)
- **Background:** أبيض وظلال رمادية

### UI Components
- Cards مع ظلال ناعمة
- Rounded corners (12-16px)
- Smooth animations
- Shimmer loading effects
- Pull-to-refresh
- Infinite scroll

### Responsive Design
استخدام `flutter_screenutil` للتكيف مع جميع أحجام الشاشات:
```dart
Text('Hello', style: TextStyle(fontSize: 14.sp))
SizedBox(height: 20.h, width: 100.w)
```

---

## 🧪 الاختبار

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

---

## 📦 البناء والنشر

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

---

## 🔄 التحديثات الأخيرة

### v1.0.0 (2026-01-19)
- ✅ إضافة نظام التعليقات المتطور
- ✅ تحسين واجهة المواعيد
- ✅ إضافة 27 نص ترجمة جديد
- ✅ تحسين إدارة الملفات
- ✅ تحديثات الأمان والأداء

---

## 📝 الملاحظات الهامة

### API Configuration
تأكد من تحديث `ApiConstants.dart` مع عنوان API الصحيح:
```dart
static const String baseUrl = "https://api.decodaai.com/api/";
```

### Environment Variables
أنشئ ملف `.env` في المجلد الجذري:
```env
API_BASE_URL=https://api.decodaai.com/api/
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
```

---

## 👥 الفريق

- **المطور الرئيسي:** Ahmed Fathi Musfer
- **التصميم:** UI/UX Team

---

## 📞 الدعم

لأي استفسارات أو مشاكل:
- 📧 Email: support@diagnobot.com
- 🌐 Website: https://diagnobot.com
- 💬 Discord: [Join our server]

---

## 📄 الترخيص

هذا المشروع **خاص** ومحمي بحقوق الطبع والنشر.

```
Copyright (c) 2026 Diagno Bot
All rights reserved.
```

---

## 🙏 شكر وتقدير

شكراً لاستخدام **Diagno Bot**! نحن ملتزمون بتوفير أفضل تجربة طبية رقمية.

<div align="center">
  <strong>Made with ❤️ using Flutter</strong>
  
  ⭐ إذا أعجبك المشروع، لا تنسى وضع نجمة!
</div>

---

## 📚 مصادر إضافية

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [BLoC Pattern Guide](https://bloclibrary.dev/)
- [Drift Documentation](https://drift.simonbinder.eu/)
- [Firebase Flutter](https://firebase.flutter.dev/)
- [Stripe Flutter](https://stripe.dev/stripe-flutter)

---

**آخر تحديث:** 2026-01-19  
**الإصدار:** 1.0.0+1
