public struct EKResourcePool<T>: Sequence {
	typealias Element = T

	fileprivate var resources = [EKResource<T>(value: nil, next: 0)]

	private var arrayCapacity = 1
	public var count = 0

	private var isFull: Bool {
		get {
			return firstAvailableIndex == 0
		}
	}

	private var firstAvailableIndex: Int {
		get {
			return resources[0].next
		}
		set {
			resources[0].next = newValue
		}
	}

	public subscript(index: Int) -> T? {
		get {
			return resources[index].value
		}
	}

	//
	public func makeIterator() -> AnyIterator<T> {
		var index = 1
		return AnyIterator {
			while index < self.arrayCapacity {
				defer { index = index + 1 }
				if let value = self.resources[index].value {
					return value
				}
			}
			return nil
		}
	}

	//
	public mutating func addResource(_ value: T) {
		_ = addResourceAndGetIndex(value)
	}

	public mutating func addResourceAndGetIndex(_ value: T) -> Int {
		let newResource = EKResource(value: value, next: 0)
		count = count + 1
		if isFull {
			resources.append(newResource)
			arrayCapacity = arrayCapacity + 1
			return count
		} else {
			let firstEmptySlot = resources[firstAvailableIndex]
			let nextEmptySlotIndex = firstEmptySlot.next
			resources[firstAvailableIndex] = newResource
			defer { firstAvailableIndex = nextEmptySlotIndex }
			return firstAvailableIndex
		}
	}

	public mutating func deleteResource(atIndex indexToDelete: Int) {
		resources[indexToDelete].value = nil
		resources[indexToDelete].next = firstAvailableIndex
		firstAvailableIndex = indexToDelete

		if count < arrayCapacity / 3 {
			let newCapacity = arrayCapacity / 2 + 1
			let emptyResource = EKResource<T>(value: nil, next: 0)
			var newArray = [EKResource<T>](repeating: emptyResource,
			                               count: newCapacity)
			var j = 1
			for resource in resources {
				if let value = resource.value {
					newArray[j].value = value
					j = j + 1
				}
			}
			for i in j..<(newCapacity - 1) {
				newArray[i].next = i + 1
			}
			newArray[newCapacity - 1].next = 0
		}
	}
}

public extension EKResourcePool where T: Equatable {
	public mutating func deleteResource(_ value: T) {
		var index: Int! = nil
		for (i, resource) in resources.enumerated() {
			if resource.value == value {
				index = i
				break
			}
		}
		deleteResource(atIndex: index)
	}
}

private struct EKResource<T> {
	var value: T?
	var next: Int
}
