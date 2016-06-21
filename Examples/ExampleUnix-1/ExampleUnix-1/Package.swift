import PackageDescription

let package = Package(
	name: "main",
	dependencies: [
		.Package(url: "https://github.com/SwiftGL/OpenGL.git", majorVersion: 1),
		.Package(url: "https://github.com/SwiftGL/Math.git", majorVersion: 1),
		.Package(url: "https://github.com/SwiftGL/Image.git", majorVersion: 1)
	]
)

package.dependencies.append(
	Package.Dependency.Package(url: "../CGLFW3", majorVersion: 1)
)
