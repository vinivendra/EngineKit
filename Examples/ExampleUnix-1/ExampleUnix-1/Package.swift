import PackageDescription

let package = Package(
	name: "main",
	dependencies: [
	]
)

package.dependencies.append(
	.Package(url: "../CGLFW3",
	         majorVersion: 1)
)

package.dependencies.append(
	.Package(url: "../SwiftGL",
	         majorVersion: 1)
)

package.dependencies.append(
    .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git",
             majorVersion: 3)
)
