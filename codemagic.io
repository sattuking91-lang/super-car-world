workflows:
  android-workflow:
    name: Android Workflow
    instance_type: mac_mini_m1
    max_build_duration: 60
    environment:
      java: 17
    scripts:
      - name: Unzip project
        script: |
          unzip -o super-car-world.zip
          ls -R | head -n 200
          echo "--- gradle files ---"
          find . -name "*.gradle*" -o -name "*.kts" | head -n 100
          echo "--- app folder ---"
          ls -R app || true
      - name: Create missing files
        script: |
          rm -f settings.gradle.kts
          cat > settings.gradle <<'EOF'
          pluginManagement {
              repositories { google(); mavenCentral(); gradlePluginPortal() }
          }
          dependencyResolutionManagement {
              repositories { google(); mavenCentral() }
          }
          rootProject.name = "SuperCarWorld"
          include ':app'
          EOF
          echo "// top-level" > build.gradle
          ls -R | head -n 100
      - name: Build APK
        script: |
          gradle assembleDebug --stacktrace
    artifacts:
      - app/build/outputs/apk/debug/*.apk
