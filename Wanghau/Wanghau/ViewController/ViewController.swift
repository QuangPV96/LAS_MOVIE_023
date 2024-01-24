
import UIKit

enum ViewType {
    case addText
    case sticker
    case addImage
    case effect
}
class ViewController: BaseAppVC {
    @IBOutlet weak var btnFonts: UIButton!
    @IBOutlet weak var btnControls: UIButton!
    @IBOutlet weak var wheelPickerFont: UIPickerView!
    @IBOutlet weak var vFont: UIView!
    @IBOutlet weak var vOpacitySlider: PosterSlider!
    @IBOutlet weak var vSticker: UIView!
    @IBOutlet weak var vAddText: UIView!
    @IBOutlet weak var clvColor: UICollectionView!
    @IBOutlet weak var ivPreview : UIImageView!
    @IBOutlet weak var clvSticker : UICollectionView!
    @IBOutlet weak var vEmpty: UIView!
    @IBOutlet weak var clvEffect: UICollectionView!
    @IBOutlet weak var vOpacityEffect: PosterSlider!
    @IBOutlet weak var vStackControls: UIStackView!
    @IBOutlet weak var vEffect: UIView!
    
    @IBOutlet weak var vTextSizeSlider: PosterSlider!
    @IBOutlet weak var vFunc: UIView!
    
    var imageEffect: UIImageView!
    var posEffect: Int = 0
    var opacityEffect: Float = 1
    var imagePreview: UIImage!
    var imageSticker : UIImage!
    var labelSticker: UILabel?
    var colors: [Int] = [0xFFFFFF,0x000000,0xeb4034, 0xebab34,0xcdeb34,0x68eb34,0x34eba2,0x345feb,0x6234eb,0x8f34eb]
    var fonts: [String] = ["Default","AbhayaLibre-Bold","AbhayaLibre-Regular","Aileron-Bold","Aileron-Regular","Amiko-Bold","Amiko-Regular","Antonio-Bold","Antonio-Regular","Barlow-Bold","Barlow-Regular","BebasNeue Bold","BebasNeue Regular","Butler_Bold","Butler_Regular","Cabin-Bold","Cabin-Regular","Cardo-Bold","Cardo-Regular","Cormorant-Bold","Cormorant-Regular","Dosis-ExtraBold","Dosis-Regular","Exo2-Bold","Exo2-Regular","Lato-Bold","Lato-Regular","Metropolis-Bold","Metropolis-Regular","Montserrat-Bold","Montserrat-Regular","Neris-Light","Neris-SemiBold","NunitoSans-Bold","NunitoSans-Regular","PlayfairDisplaySC-Bold","PlayfairDisplaySC-Regular","Poppins-Bold","Poppins-Regular"]
    var selectColor = 0
    var beforeScale: CGFloat = 0
    private var _addtickerView:StickerView?
    var addtickerView:StickerView? {
        get {
            return _addtickerView
        }
        set {
            if _addtickerView != newValue {
                if let addtickerView = _addtickerView {
                    addtickerView.showEditingHandlers = false
                }
                _addtickerView = newValue
            }
            if let addtickerView = _addtickerView {
                addtickerView.showEditingHandlers = true
                addtickerView.superview?.bringSubviewToFront(addtickerView)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivPreview.image = imagePreview
        imageEffect = UIImageView(frame: CGRect(x: 0, y: 0, width: ivPreview.frame.width, height: ivPreview.frame.height))
        imageEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        imageEffect.contentMode = .scaleAspectFill
        ivPreview.addSubview(imageEffect)
        clvSticker.delegate = self
        clvSticker.dataSource = self
        clvSticker.register(UINib(nibName: "StickerCell", bundle: nil), forCellWithReuseIdentifier: "StickerCell")
        
        clvColor.delegate = self
        clvColor.dataSource = self
        clvColor.register(UINib(nibName: "ColorCell", bundle: nil), forCellWithReuseIdentifier: "ColorCell")
        
        clvEffect.delegate = self
        clvEffect.dataSource = self
        clvEffect.register(UINib(nibName: "EffectCell", bundle: nil), forCellWithReuseIdentifier: "EffectCell")
        
        wheelPickerFont.delegate = self
        wheelPickerFont.dataSource = self
        
        self.vOpacityEffect.value = 0.5
        self.vOpacityEffect.minimumValue = 0
        self.vOpacityEffect.maximumValue = 1
        imageEffect.alpha = 0.5
        
        self.vTextSizeSlider.minimumValue = 1
        self.vTextSizeSlider.maximumValue = 60
    }
    func showViewWithType(viewType: ViewType) {
        if(viewType == ViewType.addText) {
            vEmpty.isHidden = true
            vAddText.isHidden = false
            vSticker.isHidden = true
            vEffect.isHidden = true
        }else if(viewType == ViewType.sticker) {
            vEmpty.isHidden = true
            vAddText.isHidden = true
            vEffect.isHidden = true
            vSticker.isHidden = false
        }
        vFunc.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    @IBAction func actionFIlter(_ sender: Any) {
        vEffect.isHidden = false
        vEmpty.isHidden = true
        vAddText.isHidden = true
        vSticker.isHidden = true
        vFunc.isHidden = false
    }
    @IBAction func actionImage(_ sender: Any) {
        vFunc.isHidden = false
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func actionSticker(_ sender: Any) {
        showViewWithType(viewType: ViewType.sticker)
    }
    @IBAction func btnSaveClick (sender:AnyObject) {
        self.showLoading()
        addtickerView?.showEditingHandlers = false
        if let image = mergeImages(imageView: ivPreview){
            self.hideLoading()
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            saveImageToDoc(image: image)
        }else{
            self.hideLoading()
            MessageApp.shared.showMessage(messageType: .success, message: "Save Error")
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
           
        } else {
            
        }
    }
    
    @IBAction func actionControls(_ sender: Any) {
        btnControls.setTitleColor(UIColor.white, for: .normal)
        btnFonts.setTitleColor(UIColor.lightGray, for: .normal)
        vStackControls.isHidden = false
        vFont.isHidden = true
    }
    
    @IBAction func actionFonts(_ sender: Any) {
        btnControls.setTitleColor(UIColor.white, for: .normal)
        btnFonts.setTitleColor(UIColor.lightGray, for: .normal)
        vFont.isHidden = false
        vStackControls.isHidden = true
    }
    
    
    @IBAction func actionAddtext(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                alertController.addTextField { (textField) in
                    textField.placeholder = "Enter here"
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let submitAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                    if let textField = alertController.textFields?.first {
                        self.showViewWithType(viewType: ViewType.addText)
                        if let enteredText = textField.text {
                            let uiLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
                            uiLabel.text = enteredText
                            uiLabel.textColor = UIColor(hex: 0xFFFFFF)
                            uiLabel.backgroundColor = .clear
                            uiLabel.textAlignment = .center
                            uiLabel.font = UIFont.systemFont(ofSize: 16)
                            uiLabel.contentMode = .scaleAspectFit
                            uiLabel.sizeToFit()
                            self.labelSticker = uiLabel

                            let stickerView3 = StickerView.init(contentView: uiLabel)
                            stickerView3.center = CGPoint.init(x: 150, y: 150)
                            stickerView3.delegate = self
                            stickerView3.setImage(UIImage.init(named: "Close")!, forHandler: StickerViewHandler.close)
                            stickerView3.setImage(UIImage.init(named: "Rotate")!, forHandler: StickerViewHandler.rotate)
                            stickerView3.setImage(UIImage.init(named: "Flip")!, forHandler: StickerViewHandler.flip)
                            stickerView3.showEditingHandlers = false
                            stickerView3.colorLabel = 0
                            stickerView3.tag = 101
                            self.ivPreview.addSubview(stickerView3)
                            self.vOpacitySlider.value = 1
                            self.vTextSizeSlider.value = 16
                            self.addtickerView = stickerView3
                            self.clvColor.reloadData()
                        }
                    }
                }

                alertController.addAction(cancelAction)
                alertController.addAction(submitAction)
                present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func sliderValueTextSize(_ sender: UISlider) {
        let value = CGFloat(sender.value)
        labelSticker?.font = labelSticker?.font.withSize(value)
    }
    @IBAction func slidetValueEffect(_ sender: UISlider) {
        let value = CGFloat(sender.value)
        imageEffect.alpha = value
    }
    @IBAction func sliderValue(_ sender: UISlider) {
        if let stickerView = self.addtickerView {
            stickerView.contentView.alpha = CGFloat(sender.value)
            stickerView.opacity = sender.value
        }
    }
 
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnShareClick (sender:AnyObject) {
        addtickerView?.showEditingHandlers = false
        if self.ivPreview.subviews.filter({$0.tag == 101}).count > 0 {
            if let image = mergeImages(imageView: ivPreview){
                share(shareText: "", shareImage: image)
            }else{
                print("Image not found !!")
            }
        }else{
        }
    }
    
    func mergeImages(imageView: UIImageView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0.0)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func share(shareText:String?,shareImage:UIImage?){
        var objectsToShare = [AnyObject]()
        
        if let shareTextObj = shareText{
            objectsToShare.append(shareTextObj as AnyObject)
        }
        
        if let shareImageObj = shareImage{
            objectsToShare.append(shareImageObj)
        }
        
        if shareText != nil || shareImage != nil{
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        }else{
            print("There is nothing to share")
        }
    }
    
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == clvColor) {
            return colors.count
        }else if(collectionView == clvSticker) {
            return 40
        }else if(collectionView == clvEffect) {
            return 19
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == clvColor) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
            cell.row = indexPath.row
            let color = UIColor(hex: colors[indexPath.row])
            selectColor = self.addtickerView?.colorLabel ?? 0
            if(selectColor == indexPath.row) {
                cell.vParent.backgroundColor = color
                cell.vChild.backgroundColor = color
                cell.vParent.borderWidth = 1
            }else {
                cell.vParent.backgroundColor = UIColor.clear
                cell.vChild.backgroundColor = color
                cell.vParent.borderWidth = 0
            }
            cell.colorClickBlock = { row in
                self.selectColor = row
                self.addtickerView?.colorLabel = self.selectColor
                if let subview = self.addtickerView?.contentView as? UILabel {
                    subview.textColor = UIColor(hex: self.colors[row])
                }
                self.clvColor.reloadData()
            }
            return cell
        }else if(collectionView == clvEffect) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EffectCell", for: indexPath) as! EffectCell
            let nameImage = "e\(indexPath.row)"
            print("trungnc \(nameImage)")
            cell.ivEffect.image = UIImage(named: nameImage)
            if(posEffect == indexPath.row) {
                cell.vBound.borderWidth = 1
            }else {
                cell.vBound.borderWidth = 0
            }
            return cell
        }
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerCell
        aCell.ivSticker.image = UIImage(named: "sticker_\(indexPath.row + 1)")
        return aCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == clvSticker) {
            if let cell = collectionView.cellForItem(at: indexPath) as? StickerCell{
                if let imageSticker = cell.ivSticker.image {
                    let testImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
                    testImage.image = imageSticker
                    testImage.contentMode = .scaleAspectFit
                    let stickerView3 = StickerView.init(contentView: testImage)
                    stickerView3.center = CGPoint.init(x: 150, y: 150)
                    stickerView3.delegate = self
                    stickerView3.setImage(UIImage.init(named: "Close")!, forHandler: StickerViewHandler.close)
                    stickerView3.setImage(UIImage.init(named: "Rotate")!, forHandler: StickerViewHandler.rotate)
                    stickerView3.setImage(UIImage.init(named: "Flip")!, forHandler: StickerViewHandler.flip)
                    stickerView3.showEditingHandlers = false
                    stickerView3.tag = 101
                    stickerView3.opacity = 1
                    self.vOpacitySlider.value = 1
                    self.ivPreview.addSubview(stickerView3)
                    self.addtickerView = stickerView3
                }else{
                    print("Sticker not loaded")
                }
            }
        }else if(collectionView == clvEffect) {
            posEffect = indexPath.row
            let nameImage = "e\(indexPath.row)"
            imageEffect.image = UIImage(named: nameImage)
            if(posEffect == 0) {
                imageEffect.isHidden = true
            }else {
                imageEffect.isHidden = false
            }
            let alpha = imageEffect.alpha
            vOpacityEffect.value = Float(alpha)
            clvEffect.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == clvSticker) {
            let width = clvSticker.frame.width/10
            return CGSize(width: width, height: width)
        }else if(collectionView == clvEffect) {
            return CGSize(width: 100, height: 72)
        }
        return CGSize(width: 28, height: 28)
    }
}

extension ViewController : StickerViewDelegate {
    func stickerViewDidTap(_ stickerView: StickerView) {
        if let subview = stickerView.contentView as? UILabel {
            showViewWithType(viewType: ViewType.addText)
            let size = labelSticker?.font.pointSize
            self.vTextSizeSlider.value = Float(size ?? 16)
            clvColor.reloadData()
        }else {
            showViewWithType(viewType: ViewType.sticker)
        }
        self.vOpacitySlider.value = stickerView.opacity
        self.addtickerView = stickerView
    }
    
    func stickerViewDidBeginMoving(_ stickerView: StickerView) {
        self.addtickerView = stickerView
    }
    
    func stickerViewDidChangeMoving(_ stickerView: StickerView) {
    }
    
    func stickerViewDidEndMoving(_ stickerView: StickerView) {
    }
    
    func stickerViewDidBeginRotating(_ stickerView: StickerView) {
    }
    
    func stickerViewDidChangeRotating(_ stickerView: StickerView, scale: CGFloat) {
        
    }
    
    func stickerViewDidEndRotating(_ stickerView: StickerView) {
    }
    
    func stickerViewDidClose(_ stickerView: StickerView) {
    }
}
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - UIPickerViewDelegate and UIPickerViewDataSource methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fonts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fonts[row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            let title = fonts[row]
            let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            return attributedString
        }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = fonts[row]
        if let subview = self.addtickerView?.contentView as? UILabel {
            let size = subview.font.pointSize
            if(selectedOption == "Default") {
                subview.font = UIFont.systemFont(ofSize: size)
            }else {
                subview.font = UIFont(name: selectedOption, size: size)
            }
            self.addtickerView?.fontName = selectedOption
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    // UIImagePickerControllerDelegate method to handle the selected image
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                showViewWithType(viewType: ViewType.sticker)
                let tempImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
                tempImage.image = selectedImage
                tempImage.contentMode = .scaleAspectFit
                let stickerView = StickerView.init(contentView: tempImage)
                stickerView.center = CGPoint.init(x: 150, y: 150)
                stickerView.delegate = self
                stickerView.setImage(UIImage.init(named: "Close")!, forHandler: StickerViewHandler.close)
                stickerView.setImage(UIImage.init(named: "Rotate")!, forHandler: StickerViewHandler.rotate)
                stickerView.setImage(UIImage.init(named: "Flip")!, forHandler: StickerViewHandler.flip)
                stickerView.showEditingHandlers = false
                stickerView.tag = 101
                self.vOpacitySlider.value = 1
                self.vOpacitySlider.minimumValue = 0
                self.vOpacitySlider.maximumValue = 1
                self.ivPreview.addSubview(stickerView)
                self.addtickerView = stickerView
            }

            picker.dismiss(animated: true, completion: nil)
        }

        // UIImagePickerControllerDelegate method to handle the user canceling the image picker
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
