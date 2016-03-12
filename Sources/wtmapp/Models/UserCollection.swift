import KituraRouter
import KituraNet
import KituraSys
import LoggerAPI

class UserCollection: UserDAOProtocol {
    var baseURL: String
    
    let writingQueue = Queue(type: .SERIAL, label: "Writing Queue")
    var idCounter: Int = 0
    private var userCollection = [String: UserModel]()
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    var count: Int {
        return userCollection.keys.count
    }
    
    func clear() {
        writingQueue.queueSync() {
            self.userCollection.removeAll()
        }
    }
    
    func getAll() -> [UserModel]  {
        return [UserModel](userCollection.values)
    }
    
    func add(name: String, address: String, score: Int, isAdmin: Bool) -> UserModel {
        var original: String
        original = String(self.idCounter)
        
        let user = UserModel(id: original,
            name: name,
            address: address,
            score: score,
            isAdmin: false,
            url: self.baseURL + "/" + original
        )
        
        writingQueue.queueSync() {
            self.idCounter+=1
            self.userCollection[original] = user
        }
        
        Log.info("Added \(name)")
        return user
    }
    
    func delete(id: String) {
        writingQueue.queueSync() {
            self.userCollection.removeValueForKey(id)
        }
    }
    
    ///
    /// Update an element by id
    ///
    /// - Parameter id: id for the element
    /// -
    func update(id: String, name: String?, address: String?, score: Int?, isAdmin: Bool?) -> UserModel? {
        
        // search for element
        
        let oldValue = userCollection[id]
        
        if let oldValue = oldValue {
            
            // use nil coalescing operator
            
            let newValue = UserModel( id: id,
                name: name ?? oldValue.name,
                address: address ?? oldValue.address,
                score: score ?? oldValue.score,
                isAdmin: isAdmin ?? oldValue.isAdmin,
                url: oldValue.url
            )
            
            userCollection.updateValue(newValue, forKey: id)
            
            return newValue
            
        } else {
            Log.warning("Could not find item in database with ID: \(id)")
        }
        
        return nil
    }
    
    static func serialize(users: [UserModel]) -> [JSONDictionary] {
        return users.map { $0.serialize() }
    }
}





