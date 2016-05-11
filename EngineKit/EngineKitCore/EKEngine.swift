public class EKEngine {

	let languageEngine: EKLanguageEngine

	public init(languageEngine: EKLanguageEngine) {
		self.languageEngine = languageEngine
	}

	public func runScript(filename filename: String) {
		self.languageEngine.runScript(filename: filename)
	}

	public func loadAddon(addon: EKAddon) {
		addon.addFunctionalityToEngine(languageEngine)
	}

}
