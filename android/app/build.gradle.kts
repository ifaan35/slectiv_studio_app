plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.slectiv_studio_app"
    compileSdk = 34 // Sesuaikan dengan versi terbaru yang kompatibel

    ndkVersion = "27.0.12077973" // Sesuaikan dengan plugin yang dibutuhkan

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.slectiv_studio_app"
        minSdk = 23
        targetSdk = 34 // Sesuaikan dengan compileSdk
        versionCode = 1
        versionName = "1.0"
    }

    signingConfigs {
        create("release") {
            storeFile = file("keystore.jks") // Sesuaikan dengan lokasi keystore
            storePassword = "your-store-password"
            keyAlias = "your-key-alias"
            keyPassword = "your-key-password"
        }
    }

    buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = false
        isShrinkResources = false
        proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
    }
    debug {
        signingConfig = signingConfigs.getByName("debug")
    }
}

}

flutter {
    source = "../.."
}
