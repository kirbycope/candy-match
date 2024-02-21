![Candy Match](/candy-match.png)

# candy-match
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
1. Select "Project" > "Export..."
    - If you see errors, click the link for "Manage Export Templates" and then click "Download and Install"
1. Select the preset "Web (Runnable)"
1. (One Time Setup) Download [coi.js](https://github.com/gzuidhof/coi-serviceworker/raw/master/coi-serviceworker.js) and add it to the `/docs` directory
1. (One Time Setup) Enter "Head Include" `<script src="coi-serviceworker.js"></script>`
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
