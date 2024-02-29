![Candy Match](/candy-match.png)

# candy-match
A vibrant and addictive match 3 puzzle game.
</br>
"Candy Match" is a vibrant and addictive match 3 puzzle game that immerses players in a sugary sweet world filled with colorful candies and exciting challenges. In this delightful game, the candies aren't just for matching; they're also used to feed hungry, adorable critters who eagerly await their favorite treats.
</br>
[Godot](https://godotengine.org/) is a cross-platform, free and open-source game engine released under the permissive MIT license.

## Getting started
1. Clone this repo
1. Install [NodeJS](https://nodejs.org/en/) LTS
1. Install [Godot](https://godotengine.org/)
    - This project was made with version `4.2` as seen in [/project.godot](/project.godot) > "Application" > "config/feature"
1. Import the root folder of the repo (which contains "project.godot") as a Project in Godot
1. Select the "2D" tab at the top, near the middle
1. In the FileSystem pane, double-click on "scenes/overworld.tscn" to open it
1. Click the "Scripts" tab at the top. You might have to File > Open the script if you don't see it.
1. (Optional) Open the root folder using [VS Code](https://code.visualstudio.com/)
    - Install [godot-tools](https://marketplace.visualstudio.com/items?itemName=geequlim.godot-tools)

### Setting Up GitHub Pages
Note: This only needs to be done once.
1. Go to the "Settings" tab of the repo
1. Select "Pages" from left-nav
1. Select `main` branch and `/docs` directory, then select "Save"
    - A GitHub Action will deploy your website
1. On the main page of the GitHub repo, click the gear icon next to "About"
1. Select "Use your GitHub Pages website", then select "Save changes"

## Building for Web Using Godot GUI

### Prerequisites
1. Download and install [NodeJS LTS](https://nodejs.org/en/)

### Setting Up Godot
The following in needed to work with GitHub Pages.
1. Select "Project" > "Export..."
    - If you see errors, click the link for "Manage Export Templates" and then click "Download and Install"
1. Select the preset "Web (Runnable)"
1. For "Head Include", enter `<script src="coi-serviceworker.js"></script>`
1. Download [coi.js](https://github.com/gzuidhof/coi-serviceworker/raw/master/coi-serviceworker.js) and add it to the `/docs` directory

### Exporting to Web
1. Select "Project" > "Export..."
1. Select the preset "Web (Runnable)"
1. Select "Export Project..."
1. Select the "docs" folder
    - The GitHub Pages config points to the `main` branch and `/docs` directory
1. Enter `index.html`
1. Select "Save"
1. Commit the code to trigger a GitHub Pages deployment (above), or run the code locally (below)

### Running the web server locally
1. Open the root folder using [VS Code](https://code.visualstudio.com/)
    - If you use GitHub Desktop, select the "Open in Visual Studio" button
1. Open the [integrated terminal](https://code.visualstudio.com/docs/editor/integrated-terminal)
1. Enter `npx local-web-server --https --cors.embedder-policy "require-corp" --cors.opener-policy "same-origin" --directory "./docs"`
    1. Enter `y` if prompted
1. In your browser navigate to [https://127.0.0.1:8000/](https://127.0.0.1:8000/)
1. In terminal press [Ctrl]+[C] to stop the web process
    1. Enter `y` if prompted

## Building for Android Using Godot GUI

### Prerequisites
1. Download and install [OpenJDK 17](https://adoptium.net/temurin/releases/?variant=openjdk17).
    - Run `java --version` to confirm
1. Download and install [Android Studio](https://developer.android.com/studio/).
    1. Start Android Studio
    1. Select "Customize"
    1. Select "All settings..."
    1. Select "Languages & Frameworks" > "Android SDK"
    1. Next to "Android SDK Location", select "Edit"
    1. For "SDK Components Setup", select "Next"
    1. For "Verify Settings", select "Next"
    1. Select "Finish"
    1. Select the "SDK Tools" tab
    1. Select the following:
        - Android SDK Build-Tools
        - NDK
        - Android SDK Command-line Tools
        - CMake
        - (Optionally) Android Emulator
        - Android SDK Platform-Tools
    1. Select "Apply"
    1. To confrim, select "OK"
        - Accept the License Agreement if prompted
    1. Select "Finish"
    1. Select "OK"
    1. Close Android Studio

### Create a debug keystore
If there isn't already a `debug.keystore` in the repo's root directory (or it expired), then you'll need to generate a new one.
1. Open the root folder using [VS Code](https://code.visualstudio.com/)
   * If you use [GitHub Desktop](https://desktop.github.com/), select the "Open in Visual Studio" button
1. Open the [integrated terminal](https://code.visualstudio.com/docs/editor/integrated-terminal)
1. Run `keytool -keyalg RSA -genkeypair -alias androiddebugkey -keypass android -keystore debug.keystore -storepass android -dname "CN=Android Debug,O=Android,C=US" -validity 9999 -deststoretype pkcs12`

### Setting Up Godot
1. Open the project in Godot
1. Select "Editor" > "Editor Settings"
1. Select "Export" > "Android"
1. Double-check "Android SDK Location"
    - It should match [ Android Studio] > "Customize" > "All Settings..." > "Languages & Frameworks" > "Android SDK" > "Android SDK Location"
1. Select the folder icon next to "Debug Keystore"
1. Navigate to the path of the debug keystore (above)
1. Select "Project" > "Export..."
    - If you see errors, click the link for "Manage Export Templates" and then click "Download and Install"
1. Select "Add..."
1. Select "Android"
    - Select "Fix Import" when prompted
1. For "Package" > "Unique Name", enter `com.{domain}.{repo}`
    - I would use `timothycope` for "domain"
    - I would use this repo's name for "repo", replacing spaces and hypens with dots (ex., `repo-name` -> `repo.name` )

### Exporting to Android
1. Select "Project" > "Export..."
1. Select the preset "Android (Runnable)"
1. Select "Export Project..."
1. For "File", enter `{repo}.apk`
1. Select "Save"
