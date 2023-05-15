public enum Method: String, Equatable, Hashable {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case connect = "CONNECT"
    case patch = "PATCH"
    case trace = "TRACE"
    case options = "OPTIONS"
}

extension Method: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        switch value {
        case "get", "GET": self = .get
        case "head", "HEAD": self = .head
        case "post", "POST": self = .post
        case "put", "PUT": self = .put
        case "delete", "DELETE": self = .delete
        case "connect", "CONNECT": self = .connect
        case "patch", "PATCH": self = .patch
        case "trace", "TRACE": self = .trace
        case "options", "OPTIONS": self = .options
        default: self = .get
        }
        
    }
}

extension Method: CustomStringConvertible {
    public var description: String {
        rawValue.lowercased()
    }
}
