public struct Request {
    public var url: String
    public var method: Method
    public var headers: [String: String]
    
    public init(url: String, method: Method, headers: [String : String]) {
        self.url = url
        self.method = method
        self.headers = headers
    }
}
