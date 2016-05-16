public protocol EKAddon: class {
	func setup(onEngine engine: EKEngine) throws
}

//
public protocol EKLanguageAddon: EKAddon {
	func addFunctionalityToEngine(languageEngine: EKLanguageEngine)
}

extension EKLanguageAddon {
	public func setup(onEngine engine: EKEngine) throws {
		addFunctionalityToEngine(engine.languageEngine)
	}
}

//
public protocol EKEventAddon: EKAddon {
	weak var eventCenter: EKEventCenter? { get set }
}

extension EKEventAddon {
	public func setup(onEngine engine: EKEngine) throws {
		self.eventCenter = engine.eventCenter
	}
}
