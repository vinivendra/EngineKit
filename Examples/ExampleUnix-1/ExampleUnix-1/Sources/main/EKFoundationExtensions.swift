import Foundation

//
infix operator =~: CastingPrecedence

extension String {
	static func =~ (string: String, regexString: String) -> RegexIterator {
		do {
			let regex = try NSRegularExpression(pattern: regexString,
			                                    options: [])

			let stringRange = NSRange(location: 0,
			                          length: string.characters.count)

			let matches = regex.matches(in: string,
			                            options: [],
			                            range: stringRange)

			return RegexIterator(string: string, matches: matches)
		} catch {
			return RegexIterator.empty
		}
	}
}

//
struct RegexIterator: Sequence, IteratorProtocol {
	let string: String
	var iterator: IndexingIterator<[NSTextCheckingResult]>

	static let empty = RegexIterator(string: "", matches: [])

	init(string: String, matches: [NSTextCheckingResult]) {
		self.string = string
		self.iterator = matches.makeIterator()
	}

	public func makeIterator() -> RegexIterator {
		return self
	}

	public mutating func next() -> RegexMatch? {
		guard let match = iterator.next() else { return nil }
		return RegexMatch(string: string, match: match)
	}
}

struct RegexMatch: Sequence, IteratorProtocol {
	let string: String
	let match: NSTextCheckingResult
	var index: Int = 0

	init(string: String, match: NSTextCheckingResult) {
		self.string = string
		self.match = match
	}

	public func makeIterator() -> RegexMatch {
		return self
	}

	public mutating func next() -> String? {
		defer { index += 1 }
		return self.getMatch(atIndex: index)
	}

	func getMatch(atIndex index: Int) -> String? {
		guard index < match.numberOfRanges else { return nil }

		let range = match.rangeAt(index)

		let ns = string as NSString
		let substring = ns.substring(with: range)
		let result = substring as String

		return result
	}
}
