

import UIKit
import Photos
import MobileCoreServices
import ImageCropper

class RatioVC: BaseAppVC {
    @IBOutlet weak var clvCategory: UICollectionView!
    @IBOutlet weak var clvImage: UICollectionView!
    @IBOutlet weak var vCamera: PUIView!
    @IBOutlet weak var vPhoto: PUIView!
    
    var ratioSize: String = ""
    var albumBackground: [AlbumBackgroundModel] = [AlbumBackgroundModel(albumTitle: "Auroras", album: "auroras", size: 21, imagePreview: "auroras_1"),
                                                   AlbumBackgroundModel(albumTitle: "Birthday", album: "birthday", size: 17, imagePreview: "birthday_1"),
                                                   AlbumBackgroundModel(albumTitle: "Bokeh", album: "bokeh", size: 20, imagePreview: "bokeh_1"),
                                                   AlbumBackgroundModel(albumTitle: "Brick", album: "brick", size: 20, imagePreview: "brick_1"),
                                                   AlbumBackgroundModel(albumTitle: "Candy", album: "candy", size: 7, imagePreview: "candy_1"),
                                                   AlbumBackgroundModel(albumTitle: "Car", album: "car", size: 11, imagePreview: "car_1")]
    var albumBackgroundModel: AlbumBackgroundModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        albumBackgroundModel = albumBackground[0]
        
        clvCategory.delegate = self
        clvCategory.dataSource = self
        clvCategory.register(UINib(nibName: "AlbumCategoryCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCategoryCell")
        
        clvImage.delegate = self
        clvImage.dataSource = self
        clvImage.register(UINib(nibName: "AlbumCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCell")
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionGallery(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.transitioningDelegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false { return }
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.modalPresentationStyle = .custom
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func actionCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}
extension RatioVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == clvCategory) {
            return albumBackground.count
        }
        return albumBackgroundModel?.size ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == clvCategory) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCategoryCell", for: indexPath) as! AlbumCategoryCell
            let item = albumBackground[indexPath.row]
            cell.ivAlbum.image = UIImage(named: item.imagePreview)
            cell.lblAlbum.text = item.albumTitle
            cell.row = indexPath.row
            cell.albumCategoryClickBlock = { row in
                self.albumBackgroundModel = self.albumBackground[row]
                self.clvImage.reloadData()
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        let name = "\(albumBackgroundModel?.album ?? "")_\(indexPath.row+1)"
        cell.ivAlbum.image = UIImage(named: name)
        cell.row = indexPath.row
        cell.itemCLickBlock = {
            row in
            let name = "\(self.albumBackgroundModel?.album ?? "")_\(row+1)"
            if let originalImage = UIImage(named: name) {
                let widthAndHeight = self.ratioSize.components(separatedBy: "x")
                var config = ImageCropperConfiguration(with: originalImage, and: ImageCropperConfiguration.ImageCropperFigureType.customRect)
                let width = PosterApp.widthScreen()
                let ratioWidth = Int(widthAndHeight[0])!
                let ratioHeight = Int(widthAndHeight[1])!
                let height = CGFloat(Int(width)*ratioWidth / ratioHeight)
                config.showGrid = false
                config.gridColor = UIColor.white
                config.customRatio = CGSize(width: width, height: height)
                config.maskFillColor = UIColor.black
                config.borderColor = UIColor.black
                config.doneTitle = "CROP"
                config.cancelTitle = "Back"
                let cropper = ImageCropperViewController.initialize(with: config, completionHandler: { _croppedImage in
                    if let image = _croppedImage {
                        saveImageToDoc(image: image)
                    }
                   
                }) {
                    self.navigationController?.popViewController(animated: true)
                }
                
                self.navigationController?.pushViewController(cropper, animated: true)
            }
            
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == clvCategory) {
            return CGSize(width: 140, height: 86)
        }
        let sizeAlbum = clvImage.frame.width/3 - 16
        return CGSize(width: sizeAlbum, height: sizeAlbum)
        
    }
}

extension RatioVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
                   if mediaType == kUTTypeImage as String {
                       if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                           let widthAndHeight = ratioSize.components(separatedBy: "x")
                           var config = ImageCropperConfiguration(with: originalImage, and: ImageCropperConfiguration.ImageCropperFigureType.customRect)
                           let width = PosterApp.widthScreen()
                           let ratioWidth = Int(widthAndHeight[0])!
                           let ratioHeight = Int(widthAndHeight[1])!
                           let height = CGFloat(Int(width)*ratioWidth / ratioHeight)
                           config.showGrid = false
                           config.gridColor = UIColor.white
                           config.customRatio = CGSize(width: width, height: height)
                           config.maskFillColor = UIColor.black
                           config.borderColor = UIColor.black
                           config.doneTitle = "CROP"
                           config.cancelTitle = "Back"
                           let cropper = ImageCropperViewController.initialize(with: config, completionHandler: { _croppedImage in
                               if let image = _croppedImage {
                                   saveImageToDoc(image: image)
                               }
                           }) {
                               self.navigationController?.popViewController(animated: true)
                           }
                           
                           self.navigationController?.pushViewController(cropper, animated: true)
                       }
                   }
               }
        self.dismiss(animated: true, completion: nil)
    }
}
