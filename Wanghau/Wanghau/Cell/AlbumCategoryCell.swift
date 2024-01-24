

import UIKit

class AlbumCategoryCell: UICollectionViewCell {

    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var ivAlbum: UIImageView!
    var row: Int = 0
    var albumCategoryClickBlock: ((Int) -> Void)!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func actionSelect(_ sender: Any) {
        if(self.albumCategoryClickBlock != nil) {
            self.albumCategoryClickBlock(row)
        }
    }
}
