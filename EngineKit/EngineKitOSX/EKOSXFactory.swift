public class EKOSXFactory: EKOSFactory {

	public func createFileManager() -> EKFileManager {
		return EKFoundationFileManager()
	}

}
