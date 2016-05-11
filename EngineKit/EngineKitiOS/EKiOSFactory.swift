public class EKiOSFactory: EKOSFactory {

	public func createFileManager() -> EKFileManager {
		return EKFoundationFileManager()
	}

}
