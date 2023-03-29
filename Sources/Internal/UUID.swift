public struct UUID {
    public var uuid: Bytes
    
    public init() {
        let bytes: [UInt8] = (0..<16).map { _ in UInt8.random(in: 0..<255) }
        uuid = bytes.tuple
        uuid.6 = (uuid.6 & 0xF) | 0x40
        uuid.8 = (uuid.8 & 0x3F) | 0x80
    }
    
    public init?(uuidString: String) {
        var bytes = [UInt8]()
        var iterator = uuidString.makeIterator()
        while let character = iterator.next() {
            guard character != "-", let next = iterator.next() else { continue }
            let hex = String([character, next])
            guard let byte = UInt8(hex, radix: 16) else { continue }
            bytes.append(byte)
        }
        guard bytes.count == 16 else { return nil }
        uuid = bytes.tuple
    }
    
    public var uuidString: String {
        var string = String()
        var i = 0
        let layout: [Bool] = [false, false, false, true, false, true, false, true, false, true, false, false, false, false, false, false]
        for byte in bytes {
            let binary = String(byte, radix: 16, uppercase: false)
            switch binary.count {
            case 1: string.append("0" + binary)
            default: string.append(binary)
            }
            if layout[i] {
                string.append("-")
            }
            i += 1
        }
        return string
    }
}

extension UUID {
    public typealias Bytes = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
    
    private var bytes: [UInt8] {
        Mirror(reflecting: uuid).children.map(\.value) as? [UInt8] ?? []
    }
}

extension UUID: Equatable {
    public static func == (lhs: UUID, rhs: UUID) -> Bool {
        lhs.uuid.0 == rhs.uuid.0 &&
        lhs.uuid.1 == rhs.uuid.1 &&
        lhs.uuid.2 == rhs.uuid.2 &&
        lhs.uuid.3 == rhs.uuid.3 &&
        lhs.uuid.4 == rhs.uuid.4 &&
        lhs.uuid.5 == rhs.uuid.5 &&
        lhs.uuid.6 == rhs.uuid.6 &&
        lhs.uuid.7 == rhs.uuid.7 &&
        lhs.uuid.8 == rhs.uuid.8 &&
        lhs.uuid.9 == rhs.uuid.9 &&
        lhs.uuid.10 == rhs.uuid.10 &&
        lhs.uuid.11 == rhs.uuid.11 &&
        lhs.uuid.12 == rhs.uuid.12 &&
        lhs.uuid.13 == rhs.uuid.13 &&
        lhs.uuid.14 == rhs.uuid.14 &&
        lhs.uuid.15 == rhs.uuid.15
    }
}

extension UUID: CustomStringConvertible {
    public var description: String { uuidString }
}

extension UUID: CustomDebugStringConvertible {
    public var debugDescription: String { uuidString }
}

extension UUID: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid.0)
        hasher.combine(uuid.1)
        hasher.combine(uuid.2)
        hasher.combine(uuid.3)
        hasher.combine(uuid.4)
        hasher.combine(uuid.5)
        hasher.combine(uuid.6)
        hasher.combine(uuid.7)
        hasher.combine(uuid.8)
        hasher.combine(uuid.9)
        hasher.combine(uuid.10)
        hasher.combine(uuid.11)
        hasher.combine(uuid.12)
        hasher.combine(uuid.13)
        hasher.combine(uuid.14)
        hasher.combine(uuid.15)
    }
}

extension UUID: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        
        guard let uuid = Self.init(uuidString: value) else {
            let context = DecodingError.Context.init(codingPath: container.codingPath, debugDescription: "")
            throw DecodingError.dataCorrupted(context)
        }
        self = uuid
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(uuidString)
    }
}

private extension Array where Element == UInt8 {
    var tuple: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) {
        (self[0], self[1], self[2], self[3], self[4], self[5], self[6], self[7], self[8], self[9], self[10], self[11], self[12], self[13], self[14], self[15])
    }
}
