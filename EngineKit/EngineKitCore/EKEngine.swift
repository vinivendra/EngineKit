enum EKScriptError: ErrorType {
	case EvaluationError
}

public class EKEngine {

	let languageEngine: EKLanguageEngine

	public init(languageEngine: EKLanguageEngine) {
		self.languageEngine = languageEngine
	}

	public func runScript(filename filename: String) throws {
		do {
			try self.languageEngine.runScript(filename: filename)
		} catch let error {
			throw error
		}
	}

	public func loadAddon(addon: EKAddon) {
		addon.addFunctionalityToEngine(languageEngine)
	}

}
