

import Foundation
import UIKit

typealias PDictionary = [String: Any]
public let SAVE_IMAGE_JSON = "SAVE_IMAGE_JSON.json"

class ImageDocModel : NSObject {
    var _id: String = ""
    var pathInDevice: String = ""
    var url: URL!
    var imageService: String = ""

    override init() {
        super.init()
    }
    
    init(url: URL) {
        super.init()
        self.url = url;
    }
    
    init(_ dictionary: PDictionary) {
        if let val = dictionary["_id"] as? String { _id = val }
        if let val = dictionary["imageService"] as? String { imageService = val }
        if let val = dictionary["pathInDevice"] as? String {
            pathInDevice = val
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(pathInDevice)
            url = fileURL
        }
    }

    func checkValueEqual(model: ImageDocModel) -> Bool {
        if (self._id == model._id) {
            return true
        } else {
            return false
        }
    }
    
    func toString() -> [String: Any] {
        return ["_id": _id,
                "pathInDevice": pathInDevice,
                "imageService": imageService
                ]
    }
    
    static func readFromFileJson() -> [ImageDocModel] {
        let string = readString(fileName: SAVE_IMAGE_JSON)
        if string == nil || string == "" {
            return [ImageDocModel]()
        }
        let data: [PDictionary] = dataToJSON(data: (string?.data(using: .utf8))!) as! [[String: Any]]
        var result = [ImageDocModel]()
        for item in data {
            let model = ImageDocModel(item)
            result.append(model)
        }
        return result
    }
    
    static func deleteFile(model: ImageDocModel){
        let items = readFromFileJson()
        var itemsNew = [ImageDocModel]()
        for item in items {
            if !item.checkValueEqual(model: model) {
                itemsNew.append(item)
            }
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: itemsNew.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(aString: jsonString, fileName: SAVE_IMAGE_JSON)
            }
        } catch {
            print("\(error)")
        }
    }
    
    static func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch let myJSONError {
        }
        return nil
    }
}
public func readString(fileName: String) -> String? {
    do {
        if let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            if !FileManager.default.fileExists(atPath: fileURL.absoluteString){
                FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: nil)
            }
            let savedText = try String(contentsOf: fileURL)
            return savedText
        }
        return nil
    } catch {
        return nil
    }
}

public func writeString(aString: String, fileName: String) {
    do {
        
        if let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            if !FileManager.default.fileExists(atPath: fileURL.absoluteString){
                FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: nil)
            }
            try aString.write(to: fileURL, atomically: false, encoding: .utf8)
        }
    } catch {
        
    }
}
public func saveImageToDoc(image: UIImage) {
    do {
       let nameSave = "Image_\(Date().timeIntervalSince1970).png"
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageURL = documentDirectory.appendingPathComponent(nameSave)
        try image.pngData()?.write(to: imageURL)
        let pathInDevice = nameSave
        var listSave = ImageDocModel.readFromFileJson()
        
        let imageDocModel = ImageDocModel()
        imageDocModel._id = "\(Date().timeIntervalSince1970 * 1000.0)"
        imageDocModel.pathInDevice = pathInDevice
        imageDocModel.imageService = imageURL.path
        listSave.append(imageDocModel)
        let jsonData = try JSONSerialization.data(withJSONObject: listSave.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
        if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
            writeString(aString: jsonString, fileName: SAVE_IMAGE_JSON)
        }
        MessageApp.shared.showMessage(messageType: .success, message: "Save image finish")
    }catch {
        MessageApp.shared.showMessage(messageType: .error, message: "Save image error")
    }
}
