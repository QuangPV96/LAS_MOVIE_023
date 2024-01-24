
import Foundation
import UIKit

extension UIColor {
    
    
    static func setUpGradient(v: UIView, listColor: [UIColor]) -> UIColor {
        guard let color = UIColor.gradientColor(withSize: v.bounds.size, colors: listColor) else { return UIColor.clear }
        return color
    }
    static func gradientColor(withSize size: CGSize, colors: [UIColor]) -> UIColor? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = colors.map { $0.cgColor }
        
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            if let gradientImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return UIColor(patternImage: gradientImage)
            }
        }
        UIGraphicsEndImageContext()
        
        return nil
    }
    convenience init(hex: Int, alpha: Double = 1.0) {
        self.init(red: CGFloat((hex>>16)&0xFF)/255.0, green:CGFloat((hex>>8)&0xFF)/255.0, blue: CGFloat((hex)&0xFF)/255.0, alpha:  CGFloat(255 * alpha) / 255)
    }
}
