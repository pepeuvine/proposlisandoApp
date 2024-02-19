# Manter as classes do pacote da sua aplicação
-keep class com.proposlisando_app.** { *; }

# Manter as classes do Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Manter as classes do Firebase, se estiver utilizando
-keep class com.google.firebase.** { *; }

# Manter as classes de entrada/saída e eventos do Flutter
-keep class com.proposlisando_app.MainActivity { *; }
-keepclassmembers class com.proposlisando_app.MainActivity { 
    public void onCreate(android.os.Bundle); 
}
