import Foundation
import UIKit

// 實機
// let common_url = "http://192.168.50.140:8080/User_MySQL_Web/"
// 模擬器
let common_url = "http://127.0.0.1:8080/User_MySQL_Web/"
//let common_url = "http://192.168.50.28:8080/User_MySQL_Web/"
let wscommon_url = "ws://127.0.0.1:8080/User_MySQL_Web/"



func executeTask(_ url_server: URL,_ requestParam: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {


    
    // requestParam值為Any就必須使用JSONSerialization.data()，而非JSONEncoder.encode()
    let jsonData = try! JSONSerialization.data(withJSONObject: requestParam)
    var request = URLRequest(url: url_server)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    request.httpBody = jsonData
    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}

func saveUser(_ user: User) -> Bool {
    if let jsonData = try? JSONEncoder().encode(user) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(jsonData, forKey: "user")
        return userDefaults.synchronize()
    } else {
        return false
    }
}

func clearUser() {
    let userDefaults = UserDefaults.standard
    userDefaults.set(nil, forKey: "user")
}

func loadUser() -> User? {
    let userDefaults = UserDefaults.standard
    if let jsonData = userDefaults.data(forKey: "user") {
        if let user = try? JSONDecoder().decode(User.self, from: jsonData) {
            return user
        }
    }
    return nil
}



