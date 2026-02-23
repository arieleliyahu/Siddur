# Siddur (Mincha) – Flutter + Supabase (remote) with local fallback

This starter shows Mincha text loaded from **Supabase Storage** if configured, otherwise falls back to **local assets** (assets/prayers/mincha.txt).

## 1) Prerequisites
- Flutter SDK installed
- Android Studio or VS Code with Flutter/Dart plugins

## 2) Create platforms
Unzip the project, open a terminal in the project directory and run:

```
flutter create .
flutter pub get
```

## 3) (Optional) Configure Supabase remote
- Create a Supabase project
- Create a **public** storage bucket named `prayers`
- Upload `mincha.txt` into `prayers/mincha.txt`
- Get your `SUPABASE_URL` and `SUPABASE_ANON` from the Supabase dashboard

Run the app with remote enabled:
```
flutter run   --dart-define=SUPABASE_URL=YOUR_URL   --dart-define=SUPABASE_ANON=YOUR_ANON_KEY
```

If you skip the defines, the app will load from local assets.

## 4) Build APK (Android)
```
flutter build apk --release   --dart-define=SUPABASE_URL=YOUR_URL   --dart-define=SUPABASE_ANON=YOUR_ANON_KEY
```
The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

## 5) Notes
- RTL is enabled; text is displayed Right-To-Left.
- You can adjust font size on the prayer screen (+ / - in the AppBar).
- A basic dark mode toggle FAB is provided.

## 6) Next steps
- Add search, bookmarks, multiple prayers, sections, TTS, and more.
