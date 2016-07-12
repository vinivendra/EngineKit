public protocol StructuredDataInitializable {
	init(structuredData: StructuredData) throws
}

public protocol StructuredDataRepresentable {
	var structuredData: StructuredData { get }
}

public protocol StructuredDataConvertible: StructuredDataInitializable, StructuredDataRepresentable {}

public enum StructuredData {
	case null
	case bool(Bool)
	case double(Double)
	case int(Int)
	case string(String)
	case data(Data)
	case array([StructuredData])
	case dictionary([String: StructuredData])
}
