

import UIKit
import ImageCropper
import FSPagerView

class HomeVC: BaseAppVC {
    
    @IBOutlet weak var clvTag: UICollectionView!
    @IBOutlet weak var clvRatio: UICollectionView!
    
    @IBOutlet weak var ivIconApp: PUIImageView!
    @IBOutlet weak var vPageControl: FSPageControl!
    @IBOutlet weak var vPagerView: FSPagerView!
    
    var listCreate: [CreateModel] = [
        CreateModel(title: "Ratio", listRatio: [RatioModel(ratio: "1x1", name: ""),
                                                RatioModel(ratio: "16x9", name: ""),
                                                RatioModel(ratio: "9x16", name: ""),
                                                RatioModel(ratio: "4x3", name: ""),
                                                RatioModel(ratio: "3x4", name: ""),
                                                RatioModel(ratio: "2x3", name: "")]),
        CreateModel(title: "Facebook", listRatio: [RatioModel(ratio: "851x315", name: "Cover"), RatioModel(ratio: "940x788", name: "Post"), RatioModel(ratio: "810x405", name: "App Image"), RatioModel(ratio: "1200x627", name: "Add Image"), RatioModel(ratio: "720x720", name: "Profile"), RatioModel(ratio: "820x428", name: "Group Cover")]),
        CreateModel(title: "Instagram", listRatio: [RatioModel(ratio: "1080x1080", name: "Post"), RatioModel(ratio: "1080x1350", name: "Post"), RatioModel(ratio: "1080x566", name: "Post")]),
        CreateModel(title: "Youtube", listRatio: [RatioModel(ratio: "2560x1440", name: ""),
                                                  RatioModel(ratio: "1280x720", name: "")]),
        CreateModel(title: "Twitter", listRatio: [RatioModel(ratio: "1500x500", name: ""),
                                                  RatioModel(ratio: "1024x512", name: ""),
                                                  RatioModel(ratio: "200x200", name: "")]),
        CreateModel(title: "Paper", listRatio: [RatioModel(ratio: "595x842", name: ""),
                                                  RatioModel(ratio: "1654x2339", name: ""),
                                                  RatioModel(ratio: "2480x3508", name: "")]),
        CreateModel(title: "Device", listRatio: [RatioModel(ratio: "595x842", name: ""),
                                                  RatioModel(ratio: "1654x2339", name: "")])
        
    ]
    var listRatio: [RatioModel] = []
    var tagSelect = "Ratio"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listRatio = listCreate.first!.listRatio
        setupCollectionView()
    }
    func setupCollectionView() {
        clvTag.delegate = self
        clvTag.dataSource = self
        if let flowLayout = clvTag.collectionViewLayout as? UICollectionViewFlowLayout {
               flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
           }
        clvTag.register(UINib(nibName: "TagsCell", bundle: nil),forCellWithReuseIdentifier: "TagsCell")
        
        clvRatio.delegate = self
        clvRatio.dataSource = self
        clvRatio.register(UINib(nibName: "RatioCell", bundle: nil),forCellWithReuseIdentifier: "RatioCell")
        
        vPagerView.delegate = self
        vPagerView.dataSource = self
        vPagerView.transformer = FSPagerViewTransformer(type: .overlap)
        let transform = CGAffineTransform(scaleX: 0.5, y: 1)
        self.vPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.vPagerView.itemSize = self.vPagerView.frame.size.applying(transform)
        self.vPagerView.decelerationDistance = FSPagerView.automaticDistance

        vPageControl.numberOfPages = 20
        vPageControl.currentPage = 0
        vPageControl.setFillColor(.lightGray, for: .normal)
        vPageControl.setFillColor(.white, for: .selected)
    }

    @IBAction func actionSetting(_ sender: Any) {
        let vc = SettingVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionGallery(_ sender: Any) {
        let vc = SavedImageVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension HomeVC :FSPagerViewDataSource,FSPagerViewDelegate{
    // MARK:- FSPagerViewDataSource
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 20
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let nameImage = "thumb_\(index+1)"
        cell.imageView?.image = UIImage(named: nameImage)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.layer.cornerRadius = 16
        cell.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        let vc = ViewController()
        let nameImage = "thumb__\(index+1)1"
        vc.imagePreview = UIImage(named: nameImage)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.vPageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.vPageControl.currentPage = pagerView.currentIndex
    }
}
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(clvTag == collectionView) {
            return listCreate.count
        }
        return listRatio.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == clvTag) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCell", for: indexPath) as! TagsCell
            let itemTag = listCreate[indexPath.row]
            cell.lblTag.text = itemTag.title
            cell.row = indexPath.row
            if(tagSelect == itemTag.title) {
                cell.lblTag.textColor = UIColor.cyan
            }else {
                cell.lblTag.textColor = UIColor.white
            }
            cell.tagClickBlock = { row in
                self.tagSelect = itemTag.title
                self.listRatio = self.listCreate[row].listRatio
                self.clvRatio.reloadData()
                self.clvTag.reloadData()
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatioCell", for: indexPath) as! RatioCell
        let item = listRatio[indexPath.row]
        cell.lblRatio.text = item.ratio
        cell.row = indexPath.row
        cell.ratioClickBlock = { row in
            let vc = RatioVC()
            vc.ratioSize = item.ratio
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let widthAndHeight = item.ratio.components(separatedBy: "x")

        if widthAndHeight.count == 2 {
            let width = Int(widthAndHeight[0])!
            let height = Int(widthAndHeight[1])!
            let fixedWidth = 100
            let calculatedHeight = fixedWidth * width / height
            print("trungnc: height: \(calculatedHeight)")
            cell.constrantWidth.constant = CGFloat(fixedWidth)
            cell.contrantHeight.constant = CGFloat(calculatedHeight)
        } 
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 300)
    }
}
