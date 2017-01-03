# Copy common EK core files to Sources folder
cp ../EngineKitCore/* Sources/

# Compile gyb files
for f in Sources/*.gyb
do
	output=${f%.gyb}
	./gyb --line-directive '' -o $output $f
done

# Lint
swiftlint

# Build
swift build -Xlinker -L/usr/local/lib
