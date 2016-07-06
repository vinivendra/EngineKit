import Darwin

public class EKUnixFileManager: EKFileManager {
	public func getContentsFromFile(filename: String) -> String? {
		var fileContents = ""
		let fp = fopen(filename, "r")
		defer { fclose(fp) }

		if fp != nil {
			var buffer = [CChar](count: 1024, repeatedValue: CChar(0))
			while fgets(&buffer, Int32(1024), fp) != nil {
				fileContents = fileContents + String.fromCString(buffer)!
			}
			return fileContents
		} else {
			return nil
		}
	}
}
