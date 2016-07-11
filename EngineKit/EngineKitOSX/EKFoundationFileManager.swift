import Foundation

var currentNSBundle = Bundle.main()

public class EKFoundationFileManager: EKFileManager {

	public func getContentsFromFile(_ filename: String) -> String? {
		guard
			let path = self.pathForFilename(filename)
			else {
				return nil
		}

		let contents = try? String(contentsOfFile: path,
		                           encoding: .utf8)

		return contents
	}

	func pathForFilename(_ filename: String) -> String? {
		let nsfilename = filename as NSString
		let mainName = nsfilename.deletingPathExtension

		let mainNameRange = NSRange(location: 0,
		                            length: (mainName as NSString).length)
		let fileExtension =
			nsfilename.replacingCharacters(in: mainNameRange,
			                               with: "")

		return currentNSBundle.pathForResource(mainName, ofType: fileExtension)
	}

}
