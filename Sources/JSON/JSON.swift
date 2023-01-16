public class JSON {
    private var line = 1
    private var column = 1
    private let bytes: [UInt8]
    
    public init(bytes: [UInt8]) {
        self.bytes = bytes
        self.cur = bytes.startIndex
        self.end = bytes.endIndex
    }
    
    private var cur: Int
    private let end: Int
    private var current: UInt8 { bytes[cur] }
    private var next: UInt8 { bytes[cur + 1] }
    
    public var json: Value? {
        let json = deserialize()
        skip()
        guard cur == end else { return nil }
        return json
    }
}

extension JSON {
    func deserialize() -> Value? {
        skip()
        guard cur != end else { return nil }
        
        switch current {
        case 0x6e: return parseSymbol("null", .null)
        case 0x74: return parseSymbol("true", .bool(true))
        case 0x66: return parseSymbol("false", .bool(false))
        case 0x2d, 0x30...0x39: return parseDouble()
        case 0x22: return parseString()
        case 0x7b: return parseObject()
        case 0x5b: return parseArray()
        default: return nil
        }
    }
    
    private  func expect(_ target: StaticString) -> Bool {
        guard cur != end else { return false }
        
        if !identifier(target.utf8Start.pointee) {
            // when single character
            if target.utf8Start.pointee == current {
                advance()
                return true
            } else {
                return false
            }
        }
        
        let start = cur
        let l = line
        let c = column
        
        var p = target.utf8Start
        let endp = p.advanced(by: Int(target.utf8CodeUnitCount))
        while p != endp {
            if p.pointee != current {
                cur = start // unread
                line = l
                column = c
                return false
            }
            
            p += 1
            advance()
        }
        
        return true
    }
    
    private func identifier(_ c: UInt8) -> Bool {
        switch c {
        case .init(ascii: "a") ... .init(ascii: "z"): return true
        default: return false
        }
    }
    
    private func advance() {
        assert(cur != end, "out of range")
        cur += 1
        guard cur != end else { return }
        
        switch current {
        case .n:
            line += 1
            column = 1
        default:
            column += 1
        }
    }
    
    private func skip() {
        while cur != end, current.blank { advance() }
    }
}

extension JSON {
    private func parseSymbol(_ target: StaticString, _ value:  @autoclosure () -> Value) -> Value? {
        guard expect(target) else { return nil }
        return value()
    }
    
    private func parseDouble() -> Value? {
        let sign = expect("-") ? -1.0 : 1.0
        
        var integer: Int64 = 0
        switch current {
        case .init(ascii: "0"):
            advance()
        case .init(ascii: "1") ... .init(ascii: "9"):
            while let value = current.digitToInt , cur != end {
                integer = (integer * 10) + Int64(value)
                advance()
            }
        default: return nil
        }
        
        var fraction: Double = 0.0
        if expect(".") {
            var factor = 0.1
            var fractionLength = 0
            
            while let value = current.digitToInt , cur != end {
                fraction += (Double(value) * factor)
                factor /= 10
                fractionLength += 1
                
                advance()
            }
            
            guard fractionLength != 0 else { return nil }
        }
        
        var exponent: Int64 = 0
        if expect("e") || expect("E") {
            var expSign: Int64 = 1
            if expect("-") {
                expSign = -1
            } else if expect("+") {
                // do nothing
            }
            
            exponent = 0
            
            var exponentLength = 0
            while let value = current.digitToInt , cur != end {
                exponent = (exponent * 10) + Int64(value)
                exponentLength += 1
                advance()
            }
            
            guard exponentLength != 0 else { return nil }
            
            exponent *= expSign
        }
        
        return .double(sign * (Double(integer) + fraction) * Double(pow(10, exponent)))
    }
    
    private func parseString() -> Value? {
        assert(current == .init(ascii: "\""), "points a double quote")
        advance()
        
        var buffer = [CChar]()
        
        while cur != end && current != .init(ascii: "\"") {
            switch current {
            case .init(ascii: "\\"):
                advance()
                
                guard cur != end, let escapedChar = parseEscapedChar() else { return nil }
                
                String(escapedChar).utf8.forEach {
                    buffer.append(CChar(bitPattern: $0))
                }
            default: buffer.append(CChar(bitPattern: current))
            }
            
            advance()
        }
        
        guard expect("\"") else { return nil }
        
        buffer.append(0) // trailing nul
        
        return .string(String(cString: buffer))
    }
    
    private func parseEscapedChar() -> UnicodeScalar? {
        let character = UnicodeScalar(current)
        
        // 'u' indicates unicode
        guard character == "u" else {
            return unescape[character] ?? character
        }
        
        guard let surrogateValue = parseEscapedUnicodeSurrogate() else { return nil }
        
        // two consecutive \u#### sequences represent 32 bit unicode characters
        if next == .init(ascii: "\\") && bytes[cur.advanced(by: 2)] == .init(ascii: "u") {
            advance(); advance()
            guard let surrogatePairValue = parseEscapedUnicodeSurrogate() else { return nil }
            
            return UnicodeScalar(surrogateValue << 16 | surrogatePairValue)
        }
        
        return UnicodeScalar(surrogateValue)
    }
    
    private func parseEscapedUnicodeSurrogate() -> UInt32? {
        let requiredLength = 4
        
        var length = 0
        var value: UInt32 = 0
        while let d = next.hexToDigit, length < requiredLength {
            advance()
            length += 1
            
            value <<= 4
            value |= d
        }
        
        guard length == requiredLength else { return nil }
        return value
    }
    
    private func parseObject() -> Value? {
        assert(current == .init(ascii: "{"), "points \"{\"")
        advance()
        skip()
        
        var object = [String: Value]()
        
        while cur != end && !expect("}") {
            guard case let .string(key) = deserialize() else { return nil }
            
            skip()
            guard expect(":") else { return nil }
            skip()
            
            let value = deserialize()
            object[key] = value
            
            skip()
            
            guard !expect("}") else { break }
            
            guard expect(",") else { return nil }
        }
        
        return .object(object)
    }
    
    private func parseArray() -> Value? {
        assert(current == .init(ascii: "["), "points \"[\"")
        advance()
        skip()
        
        var a = Array<Value>()
        
        while cur != end && !expect("]") {
            if let json = deserialize() {
                skip()
                
                a.append(json)
                
                if expect(",") {
                    continue
                } else if expect("]") {
                    break
                } else { return nil }
            }
        }
        
        return .array(a)
    }
}
