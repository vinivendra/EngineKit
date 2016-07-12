import PackageDescription

let package = Package(
	name: "main",
	dependencies: [
	]
)

package.dependencies.append(
	Package.Dependency.Package(url: "../CGLFW3", majorVersion: 1)
)
