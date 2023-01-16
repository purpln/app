public enum Value: CustomStringConvertible {
    case null, bool(Bool), double(Double), string(String), array([Value]), object([String:Value])
    
    public var value: Any? {
        switch self {
        case .null: return nil
        case .bool(let value): return value
        case .double(let value): return value
        case .string(let value): return value
        case .array(let value): return value.compactMap { $0.value }
        case .object(let value): return value.reduce(into: [:]) { $0[$1.key] = $1.value.value }
        }
    }
}

extension Value {
    public var description: String {
        switch self {
        case .null: return "nil"
        case .bool(let value): return ".bool(\(value.description))"
        case .double(let value): return ".double(\(value.description))"
        case .string(let value): return ".string(\(value.description))"
        case .array(let value): return ".array(\n\t\(value.map { $0.description }.joined(separator: ", "))\n)"
        case .object(let value): return ".object(\n\t\(value.reduce(into: [String]()) { $0.append($1.key + ": " + $1.value.description) }.joined(separator: ",\n\t"))\n)"
        }
    }
}
