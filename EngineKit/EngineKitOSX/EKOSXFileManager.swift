public class EKOSXFileManager: EKFileManager {

	// MARK: Public Functions
	public func getContentsFromFile(filename: String) -> String? {
		guard
			let path = self.pathForFilename(filename)
			else {
				return nil
		}

		let contents = try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding)

		return contents
	}

	// MARK: Private Functions
	func pathForFilename(filename: String) -> String? {
		let nsfilename = filename as NSString
		let mainName = nsfilename.stringByDeletingPathExtension

		let mainNameRange = NSRange(location: 0, length: (mainName as NSString).length)
		let fileExtension = nsfilename.stringByReplacingCharactersInRange(mainNameRange, withString: "")

		return NSBundle.mainBundle().pathForResource(mainName, ofType: fileExtension)
	}

}
