plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.galaxy_sentinel"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.galaxy_sentinel"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Add a simple flavor dimension to allow a Samsung-specific APK that
    // contains vendor-specific native hooks. The `samsung` flavor will
    // include the native metric implementation; the `generic` flavor ships a
    // minimal MainActivity without vendor sensors.
    flavorDimensions += "vendor"
    productFlavors {
        create("samsung") {
            dimension = "vendor"
        }
        create("generic") {
            dimension = "vendor"
        }
    }

    // Add WorkManager runtime for background sampling in the Samsung flavor.
    dependencies {
        implementation("androidx.work:work-runtime-ktx:2.8.1")
    }
}

flutter {
    source = "../.."
}
