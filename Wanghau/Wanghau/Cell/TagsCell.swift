

import UIKit

class TagsCell: UICollectionViewCell {

    @IBOutlet weak var lblTag: UILabel!
    var row: Int = 0
    var tagClickBlock: ((Int) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func actionTags(_ sender: Any) {
        if(tagClickBlock != nil) {
            tagClickBlock!(row)
        }
    }
    
}
