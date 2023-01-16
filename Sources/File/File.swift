#if os(macOS) || os(iOS)
import Darwin.C
#elseif os(Linux)
import Glibc
#endif


public class File {
    var pointer: UnsafeMutablePointer<FILE>
    
    public init?(path: String, mode: Mode) {
        pointer = fopen(path, mode.rawValue)
    }
    
    deinit {
        fclose(pointer)
    }
    
    public func read() -> [UInt8] {
        fseek(pointer, 0, SEEK_END)
        let count = ftell(pointer)
        fseek(pointer, 0, SEEK_SET)
        var array = [UInt8](repeating: 0, count: count)
        let read = fread(&array, 1, count, pointer)
        if read != count { print("read error") }
        return array
    }
    
    public func write(bytes: [UInt8]) {
        let count = bytes.count
        let written = fwrite(bytes, 1, count, pointer)
        if written != count { print("write error") }
    }
}

public extension File {
    enum Mode: String {
        case readOnly      = "rb"
        case writeOnly     = "wb"
        case readAndWrite  = "r+b"
        case appendOnly    = "ab"
        case appendAndRead = "a+b"
    }
}
