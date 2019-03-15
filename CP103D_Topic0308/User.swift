class User: Codable {
    var id = -1
    var username = ""
    var password = ""
    var name = ""
    var phone = -1
    var email = ""
    
    init(_ username: String, _ password: String) {
        self.username = username
        self.password = password
    }
}
