class User: Codable {
    var id:Int?
    var userName = ""
    var password = ""
    var trueName = ""
    var phone = ""
    var email = ""
    var sex = -1
    
    init(_ username: String, _ password: String) {
        self.userName = username
        self.password = password
    }
    
    init(userName: String, password: String, trueName: String, phone:String, email:String , sex: Int) {
        self.userName = userName
        self.password = password
        self.trueName = trueName
        self.phone = phone
        self.email = email
        self.sex = sex
        
    }
}
