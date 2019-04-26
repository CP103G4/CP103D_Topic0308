import Foundation
import UIKit

//本機連線位置
let common_url = "http://127.0.0.1:8080/User_MySQL_Web/"
let wscommon_url = "ws://127.0.0.1:8080/User_MySQL_Web/"

//網域連線位置
//let common_url = "http://192.168.43.83:8080/User_MySQL_Web/"
//let wscommon_url = "ws://192.168.43.83:8080/User_MySQL_Web/"

//向Server發請求
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

//使用者存userDefault
func saveUser(_ user: User) -> Bool {
    if let jsonData = try? JSONEncoder().encode(user) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(jsonData, forKey: "user")
        return userDefaults.synchronize()
    } else {
        return false
    }
}

//清除userDefault的使用者資料
func clearUser() {
    let userDefaults = UserDefaults.standard
    userDefaults.set(nil, forKey: "user")
}

//讀取userDefault的使用者資料
func loadUser() -> User? {
    let userDefaults = UserDefaults.standard
    if let jsonData = userDefaults.data(forKey: "user") {
        if let user = try? JSONDecoder().decode(User.self, from: jsonData) {
            return user
        }
    }
    return nil
}



