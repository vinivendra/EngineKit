public class EKEngine {

	let languageEngine: EKLanguageEngine

	public init(languageEngine: EKLanguageEngine) {
		self.languageEngine = languageEngine
	}

	public func runScript(atFileNamed filename: String) {
		self.languageEngine.runScript(filename: filename)
	}

}
