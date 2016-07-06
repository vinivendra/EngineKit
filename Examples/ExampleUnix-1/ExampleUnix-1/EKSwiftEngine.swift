public protocol EKLanguageCompatible {
}

public class EKSwiftEngine: EKLanguageEngine {
	typealias Constructor = () -> (Any)

	weak public var engine: EKEngine?

	var constructors = [String: Constructor]()
	var objects = [String: Any]()

	public required init(engine: EKEngine) {
		self.engine = engine
	}

	public func addClass<T: EKLanguageCompatible>(_ class: T.Type,
	              withName className: String,
	                       constructor: (() -> (T)) ) {
		constructors[className] = constructor
	}

	public func addObject<T: EKLanguageCompatible>(_ object: T,
	               withName name: String) throws {
		objects[name] = object
	}

	public func runProgram() {
	}
}
