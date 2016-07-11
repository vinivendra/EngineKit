let OSFactory = EKUnixFactory()

public class EKUnixFactory: EKOSFactory {
	public func createFileManager() -> EKUnixFileManager {
		return EKUnixFileManager()
	}
}
