public struct QueryField {
    public var values: [String?]

    public init(_ values: [String?]) {
        self.values = values
    }
}

extension QueryField {
    public init(_ value: String?) {
        self.init([value])
    }
}

extension QueryField: RangeReplaceableCollection, MutableCollection {
    public init() {
        self.init([])
    }

    #if swift(>=3.0)
        public mutating func replaceSubrange<C : Collection where C.Iterator.Element == String?>(_ subRange: Range<Int>, with newElements: C) {
            self.values.replaceSubrange(subRange, with: newElements)
        }
    #else
        public mutating func replaceRange<C : CollectionType where C.Generator.Element == String?>(subRange: Range<Int>, with newElements: C) {
            self.values.replaceRange(subRange, with: newElements)
        }
    #endif

    #if swift(>=3.0)
        public func makeIterator() -> IndexingIterator<[String?]> {
            return values.makeIterator()
        }
    #else
        public func generate() -> IndexingGenerator<[String?]> {
            return values.generate()
        }
    #endif

    public var startIndex: Int {
        return values.startIndex
    }

    public var endIndex: Int {
        return values.endIndex
    }


	public func formIndex(after: inout Int) {
		after = after + 1
	}

	public func index(after: Int) -> Int {
		return after + 1
	}

    public subscript(index: Int) -> String? {
        get {
            return values[index]
        }

        set(value) {
            values[index] = value
        }
    }

    public subscript(bounds: Range<Int>) -> ArraySlice<String?> {
        get {
            return values[bounds]
        }

        set(slice) {
            values[bounds] = slice
        }
    }
}

extension QueryField: IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(String(value))
    }
}

extension QueryField: FloatLiteralConvertible {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(String(value))
    }
}

extension QueryField: StringLiteralConvertible {
    public init(stringLiteral string: String) {
        self.init(string)
    }

    public init(extendedGraphemeClusterLiteral string: String){
        self.init(string)
    }

    public init(unicodeScalarLiteral string: String){
        self.init(string)
    }
}

extension QueryField: ArrayLiteralConvertible {
    public init(arrayLiteral elements: String?...) {
        self.init(elements)
    }
}

extension QueryField: Equatable {}

public func == (lhs: QueryField, rhs: QueryField) -> Bool {
    return lhs.values  == rhs.values
}

func == <T: Equatable>(lhs: [T?], rhs: [T?]) -> Bool {
    if lhs.count != rhs.count { return false }
    for (l, r) in zip(lhs, rhs) {
        if l != r { return false }
    }
    return true
}
