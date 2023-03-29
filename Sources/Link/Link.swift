public struct Link {
    public init?(string: String) {
        
    }
    
    public init?<T: StringProtocol>(_ description: T) {
        
    }
}

extension Link: Equatable, Hashable { //Comparable
    
}

extension Link: CustomStringConvertible, LosslessStringConvertible {
    public var description: String {
        ""
    }
}

extension Link: Sendable { }

extension Link: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard let decoded = Self(string: string) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid URL")
        }
        self = decoded
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
