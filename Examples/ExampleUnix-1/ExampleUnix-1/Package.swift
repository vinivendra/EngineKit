import PackageDescription

let package = Package(
	name: "main",
	targets: [Target(name: "CBullet"),
	          Target(name: "main", dependencies:["CBullet"])
	          ],
	dependencies: [
		.Package(url: "../CGLFW3",
		         majorVersion: 1),
		.Package(url: "../SwiftGL",
		         majorVersion: 1)
	]
)
