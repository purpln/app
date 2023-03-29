@usableFromInline
internal struct Length<Size: FixedWidthInteger> {
    /// The length of the scheme, including trailing `:`. Must be greater than 1.
    @usableFromInline
    internal var scheme: Size
    
    /// The length of the username, not including any username-password or username-hostname separator which may be present.
    @usableFromInline
    internal var username: Size
    
    /// The length of the password, including leading `:`. Must be either 0 or greater than 1.
    @usableFromInline
    internal var password: Size
    
    /// The length of the hostname, not including any leading or trailing separators.
    @usableFromInline
    internal var hostname: Size
    
    /// The length of the port, including leading `:`. Must be either 0 or greater than 1.
    @usableFromInline
    internal var port: Size
    
    /// The length of the path. If zero, no path is present.
    @usableFromInline
    internal var path: Size
    
    /// The length of the query, including leading `?`. If zero, no query is present.
    @usableFromInline
    internal var query: Size
    
    /// The length of the fragment, including leading `#`. If zero, no fragment is present.
    @usableFromInline
    internal var fragment: Size
    
    @inlinable
    internal init(scheme: Size, username: Size, password: Size, hostname: Size, port: Size, path: Size, query: Size, fragment: Size) {
        self.scheme = scheme
        self.username = username
        self.password = password
        self.hostname = hostname
        self.port = port
        self.path = path
        self.query = query
        self.fragment = fragment
    }
}

extension Length {
    @inlinable
    internal static var empty: Self { .init(scheme: 0, username: 0, password: 0, hostname: 0, port: 0, path: 0, query: 0, fragment: 0) }
}
