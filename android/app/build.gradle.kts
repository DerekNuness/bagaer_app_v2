import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val MAPBOX_ACCESS_TOKEN: String by project

android {
    namespace = "com.bagaer.trips"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.bagaer.trips"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["MAPBOX_ACCESS_TOKEN"] = MAPBOX_ACCESS_TOKEN
    }

    signingConfigs {
        val keystorePropertiesFile = rootProject.file("key.properties")
        if (keystorePropertiesFile.exists()) {
            val keystoreProperties = Properties().apply {
                load(FileInputStream(keystorePropertiesFile))
            }

            create("release") {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Configurações Adicionais para R8/ProGuard:
            isMinifyEnabled = true // Ativa o R8 para otimizar e ofuscar o código.
            isShrinkResources = true // Ativa a remoção de recursos não utilizados (Opcional, mas recomendado).
            proguardFiles(
                getDefaultProguardFile("proguard-android.txt"),
                "proguard-rules.pro" // Aponta para o arquivo 
            )
            // Fim das configurações R8/ProGuard

            // Assinando com a chave de release para publicação na Play Store.
            signingConfig = signingConfigs.getByName("release")
        }
    }

    packagingOptions {
        pickFirst("lib/arm64-v8a/libc++_shared.so")
        pickFirst("lib/x86_64/libc++_shared.so")
        pickFirst("lib/x86/libc++_shared.so")
        pickFirst("lib/armeabi-v7a/libc++_shared.so")
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("com.google.android.material:material:1.9.0")
}

flutter {
    source = "../.."
}

apply(plugin = "com.google.gms.google-services")
