plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Untuk Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin harus paling akhir
}

android {
    namespace = "com.example.project1"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "26.3.11579264"


    defaultConfig {
        applicationId = "com.example.project1"
        minSdk = 23 // Firebase minimal SDK 23
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
