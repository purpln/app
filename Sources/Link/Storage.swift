/// [scheme + ":"] + [sigil]? + [username]? + [":" + password]? + ["@"]? + [hostname]? + [":" + port]? + ["/" + path]? + ["?" + query]? + ["#" + fragment]?
/// `sigil` must be either "//" to mark the beginning of an authority, or "/." to mark the beginning of the path.

@usableFromInline
internal struct Storage {
    @usableFromInline
    internal var string: String
    
    @usableFromInline
    internal var length: Length<UInt>
    
    /// If `sigil == .authority`, the next component is an authority, consisting of username/password/hostname/port components.
    /// If `sigil == .path` or `sigil == nil`, the next component is a path/query/fragment and no username/password/hostname/port is present.
    @usableFromInline
    internal var sigil: Sigil?
    
    /// An opaque path is just a string, rather than a list of components (e.g. `mailto:someone@example.com` or `javascript:alert("example")`.
    @usableFromInline
    internal var opaque: Bool
    
    @inlinable
    internal init(string: String, length: Length<UInt>, sigil: Sigil?, opaque: Bool) {
        self.string = string
        self.length = length
        self.sigil = sigil
        self.opaque = opaque
    }
}

@usableFromInline
internal enum Sigil {
    case authority
    case path
}
