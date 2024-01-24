
import UIKit

class AlbumCell: UICollectionViewCell {

    @IBOutlet weak var ivAlbum: UIImageView!
    var itemCLickBlock: ((Int) -> Void)!
    var row: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func actionSelect(_ sender: Any) {
        if(self.itemCLickBlock != nil) {
            self.itemCLickBlock(row)
        }
    }
}
