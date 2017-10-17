import Foundation

class PhotoManager {
    
    //MARK:- Save image as text
    static func save(image: String, associateID: String) -> String? {
        let path = "/Users/mmaalej/Dev/OnBoarding_Backend/Profile-Photos/"+associateID+".txt"
        do {
            try image.write(toFile: path, atomically: false, encoding: .utf8)
        } catch {
            return error.localizedDescription
        }
        return path
    }
}
