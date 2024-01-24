import UIKit

class SettingVC: BaseAppVC {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func actionMoreApp(_ sender: Any) {
        let urlString = ""
        if(urlString != "") {
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
