

import Foundation
class CreateModel: NSObject {
    var title: String = ""
    var listRatio: [RatioModel] = []
    
    override init() {
        
    }
    
    init(title: String, listRatio: [RatioModel]) {
        self.title = title
        self.listRatio = listRatio
    }
}
class RatioModel: NSObject {
    var ratio: String = ""
    var name: String = ""
    
    override init() {
        
    }
    init(ratio: String , name: String) {
        self.ratio = ratio
        self.name = name
    }
}
