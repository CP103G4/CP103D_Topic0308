import UIKit

class Spot {
    var image: UIImage
    var name: String
    var address: String
    var time: String
    var latitude: Double
    var longitude: Double
    
    init(image: UIImage, name: String, address: String,time: String ,latitude: Double, longitude: Double) {
        self.image = image
        self.name = name
        self.address = address
        self.time = time
        self.latitude = latitude
        self.longitude = longitude
    }
}
