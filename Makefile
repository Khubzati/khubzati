# Melos commands
bootstrap:
	@echo "Bootstrapping the Melos workspace..."
	melos bootstrap

melos-run:
	@echo "Running the khubzati_app..."
	melos run run

.PHONY: activate-gen analyze build-dev clean easy-localization-gen run run-dev run-stage runner-build runner-watch remove-unused-import outdated

activate-gen:
	dart pub global activate flutter_gen

analyze:
	flutter analyze

build-dev:
	flutter build apk --release --flavor dev -t lib/main_dev.dart

build-stage:
	flutter build apk --release --flavor stage -t lib/main_stage.dart

build-prod:
	flutter build apk --release --flavor prod -t lib/main.dart

clean:
	flutter clean

easy-localization-gen:
	flutter pub run easy_localization:generate -S "./assets/translations" -O "./lib/gen/translations"
	flutter pub run easy_localization:generate -S "./assets/translations" -O "./lib/gen/translations" -o "locale_keys.g.dart" -f keys

run:
	flutter run --flavor prod --target lib/main.dart

run-dev:
	flutter run --flavor dev --target lib/main_dev.dart

run-stage:
	flutter run --flavor stage --target lib/main_stage.dart

runner-build:
	flutter pub run build_runner build --delete-conflicting-outputs

runner-watch:
	flutter pub run build_runner watch --delete-conflicting-outputs

remove-unused-import:
	dart fix --apply --code=unused_import

outdated:
	flutter pub outdated


# Using FVM ==> fvm flutter

