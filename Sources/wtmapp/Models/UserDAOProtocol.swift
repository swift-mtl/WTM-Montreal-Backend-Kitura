#if os(OSX)
    typealias JSONDictionary = [String: AnyObject]
#else
    typealias JSONDictionary = [String: Any]
#endif

/// DAO protocol

protocol UserDAOProtocol {
    var count: Int { get }
    func clear()
    func getAll() -> [UserModel]
    static func serialize(items: [UserModel]) -> [JSONDictionary]
    func add(name: String, address: String, score: Int, isAdmin: Bool) -> UserModel
    func update(id: String, name: String?, address: String?, score: Int?, isAdmin: Bool?) -> UserModel?
    func delete(id: String)
}