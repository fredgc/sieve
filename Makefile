ASSETS := docs web/favicon.ico web/favicon.png web/version.json

build_all: $(ASSETS)
	flutter build web
	echo XXX flutter build apk

# User documentation files built from doc/*.md to assets/*.html
USER_DOCS_MD := $(wildcard doc/*.md)
USER_DOCS_HTML := $(patsubst doc/%.md,assets/%.html,$(USER_DOCS_MD))

# Developer documentation files built from *.md to assets/dev/*.html
DEV_DOCS_MD := $(wildcard plan.md README.md GEMINI.md)
DEV_DOCS_HTML := $(patsubst %.md,assets/dev/%.html,$(DEV_DOCS_MD))

.PHONY: docs stage build_all test release ASSETS

docs: $(USER_DOCS_HTML) $(DEV_DOCS_HTML)

assets/%.html: doc/%.md
	@mkdir -p assets
	pandoc $< -s --mathml --css=css/doc_style.css -o $@

assets/dev/%.html: %.md
	@mkdir -p assets/dev
	pandoc $< -f markdown-yaml_metadata_block -s --mathml --metadata pagetitle="$*" --css=../css/doc_style.css -o $@

web/favicon.png: assets/icons/icon.png
	convert $< -background transparent -colorspace RGB -filter Lanczos -resize 32x32 -colorspace sRGB $@

web/favicon.ico: assets/icons/icon.png
	convert $< -define icon:auto-resize=64,48,32,16 -background transparent $@
	dart run flutter_launcher_icons

assets/icons/icon.png assets/icons/foreground.png assets/icons/background.png: icon.xcf
	icon-generate icon.xcf

web/version.json: pubspec.yaml
	@mkdir -p web
	@version=$$(grep '^version: ' pubspec.yaml | sed 's/version: //'); \
	echo "{\"version\": \"$$version\"}" > web/version.json

ASSETS: $(ASSETS)

test:
	flutter test

stage: $(ASSETS)
	# ./roll_build_number.sh
	flutter build web --dart-define=DEBUG_ENABLED=true
	echo "PURPLE: Beginning push to staging."
	firebase_stage.pl

stage-release: $(ASSETS)
	# ./roll_build_number.sh
	flutter build web
	echo "PURPLE: Beginning push to staging."
	firebase_stage.pl

release: $(ASSETS)
	./roll_build_number.sh --release
	make build_all
	firebase deploy
