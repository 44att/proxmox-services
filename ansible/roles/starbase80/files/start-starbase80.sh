#!/bin/bash
source /root/nvm.env

# Escape slashes
LOGO=$(echo "${LOGO}" | sed 's/\//\\\//g')

# PWA files
if [ "$PWA" = "true" ]; then cp ./pwa/service-worker.js public/service-worker.js; fi
if [ "$PWA" = "true" ]; then cp ./pwa/manifest.json public/manifest.json; fi
if [ "$PWA" = "true" ]; then sed -i 's|"name": "Starbase 81"|"name": "'"${TITLE}"'"|g' public/manifest.json; fi
if [ "$PWA" = "true" ]; then sed -i 's|"theme_color": "#003478"|"theme_color": "'"${PWA_THEME}"'"|g' public/manifest.json; fi

# HTML replacement
sed -i -e 's/My Website/'"${TITLE}"'/g' index.html
sed -i -e 's/\/logo\.png/'"${LOGO}"'/g' index.html
if [ "$PWA" = "true" ]; then sed -i "s|<!-- PWA_PLACEHOLDER -->|<link rel=\"manifest\" href=\"/manifest.json\"><meta name=\"theme-color\" content=\"${PWA_THEME}\">|g" index.html; fi
if [ "$PWA" = "true" ]; then sed -i "s|<!-- PWA_SCRIPT_PLACEHOLDER -->|<script>if ('serviceWorker' in navigator) {window.addEventListener('load', () => {navigator.serviceWorker.register('/service-worker.js').then(reg => console.log('Service Worker registered', reg)).catch(err => console.error('Service Worker registration failed', err));});}</script>|g" index.html; fi

# TypeScript replacement
sed -i -e 's/PAGETITLE = "My Website"/PAGETITLE = "'"${TITLE}"'"/g' src/variables.ts
sed -i -e 's/PAGEICON = "\/logo\.png"/PAGEICON = "'"${LOGO}"'"/g' src/variables.ts
sed -i -e 's/SHOWHEADER = true/SHOWHEADER = '"${HEADER}"'/g' src/variables.ts
sed -i -e 's/SHOWHEADERLINE = true/SHOWHEADERLINE = '"${HEADERLINE}"'/g' src/variables.ts
sed -i -e 's/SHOWHEADERTOP = false/SHOWHEADERTOP = '"${HEADERTOP}"'/g' src/variables.ts
sed -i -e 's/CATEGORIES = "normal"/CATEGORIES = "'"${CATEGORIES}"'"/g' src/variables.ts
if [ "$PWA" = "false" ]; then sed -i -e 's/NEWWINDOW = false/NEWWINDOW = '"${NEWWINDOW}"'/g' src/variables.ts; fi
sed -i -e 's/SHOWAUTHWIDGET = false/SHOWAUTHWIDGET = '"${SHOWAUTHWIDGET}"'/g' src/variables.ts
sed -i -e 's/AUTHENTIKURL = "auth.example.com"/AUTHENTIKURL = "'"${AUTHENTIKURL}"'"/g' src/variables.ts
if [ "$PWA" = "true" ]; then sed -i -e 's/PWA = false/PWA = true/g' src/variables.ts; fi

# CSS replacement
sed -i -e 's/background-color: rgba(248, 250, 252, 0\.9)/background-color: '"${BGCOLOR}"'/g' src/tailwind.css
sed -i -e 's|background-image: url()|background-image: '"${BGIMAGE}"'|g' src/tailwind.css
sed -i -e 's/background-color: rgba(3, 7, 18, 0\.9)/background-color: '"${BGCOLORDARK}"'/g' src/tailwind.css
sed -i -e 's/background-color: rgba(255, 255, 255, 0\.9)\; \/\* category light \*\//background-color: '"${CATEGORYBUBBLECOLORLIGHT}"\;'/g' src/tailwind.css
sed -i -e 's/background-color: rgba(0, 0, 0, 0\.9)\; \/\* category dark \*\//background-color: '"${CATEGORYBUBBLECOLORDARK}"\;'/g' src/tailwind.css

# Light/dark theme
if [ "$THEME" = "dark" ]; then sed -i -e 's/darkMode: "media"/darkMode: "selector"/g' tailwind.config.mjs; fi
if [ "$THEME" = "dark" ]; then sed -i -e 's/<html class="auto"/<html class="dark"/' index.html; fi
if [ "$THEME" = "dark" ]; then sed -i -e 's/THEME = "auto"/THEME = "dark"/g' src/variables.ts; fi
if [ "$THEME" = "light" ]; then sed -i -e 's/darkMode: "media"/darkMode: "selector"/g' tailwind.config.mjs; fi
if [ "$THEME" = "light" ]; then sed -i -e 's/<html class="auto"/<html class="light"/' index.html; fi
if [ "$THEME" = "light" ]; then sed -i -e 's/THEME = "auto"/THEME = "light"/g' src/variables.ts; fi

# Hover effect
if [ "$HOVER" = "underline" ]; then sed -i -e 's/@apply no-underline;/@apply underline;/g' src/tailwind.css; fi

# Build the application
echo "Building application..."
npm run build

# Clear build cache
echo "Clearing build cache..."
npm prune

# Run server
echo "Running http-server..."
npx http-server -p 8080
