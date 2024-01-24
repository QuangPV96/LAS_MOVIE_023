
import UIKit

class ColorCell: UICollectionViewCell {
    @IBOutlet weak var vParent: PUIView!
    @IBOutlet weak var vChild: PUIView!
    var row: Int = 0
    var colorClickBlock: ((Int) -> Void)!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func actionSelect(_ sender: Any) {
        if(self.colorClickBlock != nil) {
            self.colorClickBlock(row)
        }
    }
}
