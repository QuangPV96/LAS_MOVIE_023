

import Foundation
import UIKit
class BaseAppVC : UIViewController {
    var posterLoadingView: PosterLoadingView! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        posterLoadingView = PosterLoadingView(frame: CGRect(x: 0, y: 0, width: PosterApp.widthScreen(), height: PosterApp.heightScreen()))
        posterLoadingView.tag = 100
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showLoading() {
        self.view.addSubview(posterLoadingView)
        posterLoadingView.animationView.play()
    }
    
    func hideLoading() {
        posterLoadingView.animationView.stop()
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        } else{
           
        }
    }

}

