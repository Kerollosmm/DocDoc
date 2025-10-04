#!/bin/bash

#!/bin/bash

# Exit on error
set -e

echo "Building Development Release APK..."
flutter build apk --release --flavor development -t lib/main_development.dart

echo "Building Production Release APK..."
flutter build apk --release --flavor production -t lib/main_production.dart

echo "Builds complete!"