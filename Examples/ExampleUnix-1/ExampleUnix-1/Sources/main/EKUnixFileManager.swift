#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

public class EKUnixFileManager: EKFileManager {
	public func getContentsFromFile(_ filename: String) -> String? {
		var fileContents = ""
		let fp = fopen(filename, "r")

		if fp != nil {
			var buffer = [CChar](repeating: CChar(0), count: 1024)
			while fgets(&buffer, Int32(1024), fp) != nil {
				fileContents = fileContents + String(validatingUTF8: buffer)!
			}
			fclose(fp)
			return fileContents
		} else {
			print("Error opening file \(filename)")
			return nil
		}
	}
}
