class User: Codable {
    var id:Int?
    var username = ""
    var password = ""
    var name = ""
    var phone = -1
    var email = ""
    var sex = -1
    
    init(_ username: String, _ password: String) {
        self.username = username
        self.password = password
    }
    
    init(username: String, password: String, name: String, phone:Int, email:String , sex: Int) {
        self.username = username
        self.password = password
        self.name = name
        self.phone = phone
        self.email = email
        self.sex = sex
        
    }
}
