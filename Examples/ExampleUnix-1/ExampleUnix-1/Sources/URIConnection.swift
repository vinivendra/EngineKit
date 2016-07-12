public protocol URIConnection: Connection {
    init(to uri: URI) throws
    var uri: URI { get }
}
