public protocol EKOSFactory {
	associatedtype FileManager: EKFileManager

	func createFileManager() -> FileManager
}
