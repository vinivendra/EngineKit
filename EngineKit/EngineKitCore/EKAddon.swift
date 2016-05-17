public protocol EKAddon: class {
	func setup(onEngine engine: EKEngine)
}

//
public protocol EKLanguageAddon: EKAddon {
	func addFunctionalityToEngine(languageEngine: EKLanguageEngine)
}

extension EKLanguageAddon {
	public func setup(onEngine engine: EKEngine) {
		addFunctionalityToEngine(engine.languageEngine)
	}
}

//
public protocol EKEventAddon: EKAddon {
	weak var eventCenter: EKEventCenter? { get set }
}

extension EKEventAddon {
	public func setup(onEngine engine: EKEngine) {
		self.eventCenter = engine.eventCenter
	}
}
