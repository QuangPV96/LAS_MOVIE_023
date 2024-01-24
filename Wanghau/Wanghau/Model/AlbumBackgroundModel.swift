
import Foundation
class AlbumBackgroundModel: NSObject {
    var albumTitle: String = ""
    var album: String = ""
    var size : Int = 0
    var imagePreview: String = ""
    
    init(albumTitle: String, album: String, size: Int, imagePreview: String) {
        self.albumTitle = albumTitle
        self.album = album
        self.size = size
        self.imagePreview = imagePreview
    }
    override init() {
        
    }
}
