public struct URI {
    public struct UserInfo {
        public var username: String
        public var password: String

        public init(username: String, password: String) {
            self.username = username
            self.password = password
        }
    }

    public var scheme: String?
    public var userInfo: UserInfo?
    public var host: String?
    public var port: Int?
    public var path: String?
    public var query: Query
    public var fragment: String?

    public init(scheme: String? = nil, userInfo: UserInfo? = nil, host: String? = nil, port: Int? = nil, path: String? = nil, query: Query = [:], fragment: String? = nil) {
        self.scheme = scheme
        self.userInfo = userInfo
        self.host = host
        self.port = port
        self.path = path
        self.query = query
        self.fragment = fragment
    }
}
