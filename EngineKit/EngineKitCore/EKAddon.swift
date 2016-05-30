public protocol EKAddon: class {
	func setup(onEngine engine: EKEngine)
}

//
public protocol EKLanguageAddon: EKAddon {
	func addFunctionality(toEngine engine: EKEngine)
}

extension EKLanguageAddon {
	public func setup(onEngine engine: EKEngine) {
		addFunctionality(toEngine: engine)
	}
}

//
public protocol EKEventAddon: EKAddon {
	weak var eventCenter: EKEventCenter? { get set }
	var firesEventsOfTypes: [EKEvent.Type] { get }
}

extension EKEventAddon {
	public func setup(onEngine engine: EKEngine) {
		self.eventCenter = engine.eventCenter
		self.eventCenter?.startSendingEvents(ofTypes: self.firesEventsOfTypes)
	}
}
