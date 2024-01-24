import Foundation
import UIKit
class PosterApp{

    static func widthScreen() -> CGFloat {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return screenWidth
    }
    static func heightScreen() -> CGFloat {
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        return screenHeight
    }
    static func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

}
