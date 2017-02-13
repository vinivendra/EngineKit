# Copy common EK core files to Sources folder
cp ../EngineKitCore/* Sources/main/

# Compile gyb files
for f in Sources/main/*.gyb
do
	output=${f%.gyb}
	./gyb --line-directive '' -o $output $f
done

for f in ../EngineKitCore/*.gyb
do
	output=${f%.gyb}
	./gyb --line-directive '' -o $output $f
done

# Lint
swiftlint

# Build
swift build -Xcc -I/usr/local/include/bullet -Xlinker -L/usr/local/lib -Xlinker -lc++ -Xlinker -lBulletCollision -Xlinker -lBulletDynamics -Xlinker -lLinearMath
