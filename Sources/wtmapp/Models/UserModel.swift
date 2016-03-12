
struct UserModel {
    var id: String = ""
    var name: String = ""
    var address: String = ""
    var score: Int = 0
    var isAdmin: Bool = false
    var url: String = ""
    
    func serialize() -> JSONDictionary {
        var result = JSONDictionary()
        result["id"] = id
        result["name"] = name
        result["address"] = address
        result["score"] = score
        result["isAdmin"] = isAdmin
        result["url"] = url
        return result
    }
}
































