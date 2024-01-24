import UIKit
class PosterSlider: UISlider {
    
    @IBInspectable var trackHeight: CGFloat = 4
    
    @IBInspectable var makerThumbRadius: CGFloat = 16
    private lazy var makerThumbView: UIView = {
        let makerThumb = UIView()
        makerThumb.backgroundColor = UIColor(hex: 0x45C2D6)
        makerThumb.layer.borderWidth = 0.4
        makerThumb.layer.borderColor = UIColor(hex: 0x45C2D6).cgColor
        return makerThumb
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let thumb = makerThumbImage(radius: makerThumbRadius)
        setThumbImage(thumb, for: .normal)
        setThumbImage(thumb, for: .highlighted)
    }
    
    private func makerThumbImage(radius: CGFloat) -> UIImage {
        makerThumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        makerThumbView.layer.cornerRadius = radius / 2

        let renderer = UIGraphicsImageRenderer(bounds: makerThumbView.bounds)
        return renderer.image { rendererContext in
            makerThumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    
}

