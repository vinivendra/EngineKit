enum EKError: ErrorType {
	case ScriptEvaluationError
	case EventRegistryError(message: String)
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

	public func loadAddon(addon: EKAddon) {
		addon.setup(onEngine: self)

		addons.append(addon)
	}

	public func register<Event: EKEvent>(listener: EKEventListener,
	                     forEvent event: Event.Type) throws {
		do {
			try eventCenter.register(listener, forEvent: event)
		} catch let error {
			throw error
		}
	}
}
