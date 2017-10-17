import Foundation

class PhotoManager {
    
    //MARK:- Properties
    static let directoryPath = "/Users/mmaalej/Dev/OnBoarding_Backend/Profile-Photos/"
    
    //MARK:- Save image as text
    static func save(image: String, associateID: String) -> String? {
        let path = directoryPath+associateID+".txt"
        do {
            try image.write(toFile: path, atomically: false, encoding: .utf8)
        } catch {
            return error.localizedDescription
        }
        return path
    }
    
    //MARK:- Read image as text
    static func readImage(associateID: String) -> String? {
        let path = directoryPath+associateID+".txt"
        var imageString: String?
        do {
            try imageString = String.init(contentsOfFile: path)
       
        } catch {
            print(error.localizedDescription)
        }
        return imageString

    }
}
