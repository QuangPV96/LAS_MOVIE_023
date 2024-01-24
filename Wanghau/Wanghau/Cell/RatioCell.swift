
import UIKit

class RatioCell: UICollectionViewCell {

    @IBOutlet weak var contrantHeight: NSLayoutConstraint!
    @IBOutlet weak var constrantWidth: NSLayoutConstraint!
    @IBOutlet weak var lblRatio: UILabel!
    @IBOutlet weak var vRatio: PUIView!
    
    var ratioClickBlock: ((Int) -> Void)?
    var row: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func actionSelectRatio(_ sender: Any) {
        if(self.ratioClickBlock != nil) {
            self.ratioClickBlock!(row)
        }
    }
}
