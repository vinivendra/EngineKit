enum EKError: ErrorType {
	case ScriptEvaluationError(message: String)
	case ScriptConversionError(message: String)
	case EventRegistryError(message: String)
	case InvalidArgumentTypeError(message: String)
}

public protocol Initable {
	init()
}

public class EKEngine {

	public var languageEngine: EKLanguageEngine! = nil {
		willSet {
			if languageEngine != nil {
				assertionFailure("Language engine may not change!")
			}
		}
	}

	let eventCenter = EKEventCenter()

	var addons = [EKAddon]()


	public init() {}

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

	public func register<T>(forEventNamed eventName: String,
	                     target: T,
	                     method: (T) -> (EKEvent) -> ()) throws {
		do {
			try eventCenter.register(forEventNamed: eventName,
			                         target: target,
			                         method: method)
		} catch let error {
			throw error
		}
	}

	public func register<Event: EKEvent, T>(forEvent type: Event.Type,
	                     target: T,
	                     method: (T) -> (Event) -> ()) throws {
		do {
			try eventCenter.register(forEvent: type,
			                         target: target,
			                         method: method)
		} catch let error {
			throw error
		}
	}

	public func register(forEventNamed eventName: String,
	                                   callback: (EKEvent) -> ()) throws {
		do {
			try eventCenter.register(forEventNamed: eventName,
			                         callback: callback)
		} catch let error {
			throw error
		}
	}

	public func register<Event: EKEvent>(forEvent type: Event.Type,
	                     callback: (Event) -> ()) throws {
		do {
			try eventCenter.register(forEvent: type, callback: callback)
		} catch let error {
			throw error
		}
	}

	public func addClass<T: Scriptable>(class: T.Type,
	                     withName className: String?,
	                              constructor: (() -> (T)) ) {
		let className = className ?? "\(T.self)".toEKPrefixClassName()

		languageEngine.addClass(T.self,
		                         withName: className,
		                         constructor: constructor)
	}

	public func addObject<T: Scriptable>(object: T,
	                      withName name: String) throws {
		do {
			try languageEngine.addObject(object, withName: name)
		} catch let error {
			throw error
		}
	}
}

extension EKEngine {
	public func addClass<T: Scriptable where T: Initable>(class: T.Type) {
		addClass(T.self, withName: nil)
	}

	public func addClass<T: Scriptable where T: Initable>(class: T.Type,
	                     withName className: String?) {
		addClass(T.self, withName: className, constructor: T.init)
	}
}
