SpotOn: Reaction & Precision Tapping Game 📱
📌 Overview
SpotOn adalah game mobile arcade yang dibangun menggunakan Flutter dengan sistem scoring yang menantang. Game ini dirancang untuk menguji kecepatan reaksi dan ketepatan pemain dalam men-tap spot warna-warni yang muncul secara acak di layar.

Dengan progres level yang semakin menantang, visual yang menarik, dan sistem scoring yang kompetitif, SpotOn cocok untuk semua usia yang ingin mengasah refleks dan ketelitian mereka.

✨ Features
🎮 Gameplay Dinamis: Spot muncul dengan posisi, warna, dan ukuran acak
📊 Progres Level: 10 level dengan kesulitan meningkat (lebih banyak spot, waktu lebih cepat)
🏆 Scoring System: Skor bertambah berdasarkan level dengan bonus visual
❤️ Live System: 3 nyawa dengan visual feedback yang jelas
⏱️ Time Challenge: Timer 30 detik per level
🎨 Visual Effects: Gradient animasi, efek tap, dan feedback visual yang memuaskan
💾 Local Storage: Penyimpanan skor tinggi menggunakan shared_preferences
📈 Game Statistics: Tampilan statistik permainan yang lengkap
🎯 Precision Test: Menguji akurasi dan kecepatan reaksi pemain

🚀 Getting Started
✅ Prerequisites
Pastikan sudah terinstal:

Flutter SDK (versi 3.0.0 atau lebih tinggi)

Android Studio atau VS Code dengan ekstensi Flutter

Emulator Android atau perangkat fisik

🛠️ Installation:
1. Clone Repository
git clone https://github.com/arvapotoserial/spoton_game.git
cd spoton_game

2. Install Dependencies
flutter pub get
3. Run the App
flutter run
🗂️ Project Structure
lib/
│
├── main.dart                 
│
├── screens/                 
│   ├── home_screen.dart     
│   ├── game_screen.dart      
│   ├── tutorial_screen.dart  
│   ├── profile_screen.dart  
│   ├── headphones_screen.dart
│   └── login_screen.dart    
│
├── services/                 
│   ├── score_service.dart    
│   └── auth_service.dart    
│
├── widgets/                  
│   ├── game_background_widget.dart  
│   ├── game_header_widget.dart      
│   ├── scene_effect_widget.dart   
│   └── spot_widget.dart             
│
├── logic/                    
│   └── game_logic.dart      
│
└── models/                 
    ├── player.dart
    └── game_session.dart

🎮 Game Mechanics
Gameplay Loop
Start Game: Inisialisasi dengan score=0, lives=3, level=1

Spot Spawn: Spot muncul di posisi acak setiap 1-1.5 detik

Player Action:

Tap spot → +10×level score

Miss spot → -1 life

Level Progression:

Tiap level: 30 detik

Level up: spot lebih banyak, spawn lebih cepat

Game End:

Lives habis → Game Over

Selesai level 10 → Victory

Difficulty Progression
Level	Spot Count	Spawn Speed	Spot Duration
1	3	1500ms	1500ms
5	5	1100ms	1300ms
10	8	800ms	1100ms

🛠️ Technologies Used
Flutter & Dart - UI Framework

Google Fonts - Typography

Shared Preferences - Local Storage

Provider (optional) - State Management

Flutter Animate (optional) - Advanced animations


