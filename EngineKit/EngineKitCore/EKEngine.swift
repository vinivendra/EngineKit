enum EKScriptError: ErrorType {
	case EvaluationError
}

public class EKEngine {

	let languageEngine: EKLanguageEngine
	let eventCenter = EKEventCenter()

	var addons = [EKAddon]()

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

	public func loadAddon(addon: EKAddon) throws {
		do {
			try addon.setup(onEngine: self)
		} catch let error {
			throw error
		}

		addons.append(addon)
	}

}

//
public protocol EKEvent: Hashable {

}

public class EKEventCenter {

}
