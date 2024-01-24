
import UIKit
import FSPagerView
import Lottie

class SavedImageVC: UIViewController {
    @IBOutlet weak var vShare: PUIView!
    @IBOutlet weak var vPageControl: FSPageControl!
    
    @IBOutlet weak var vAnimation: UIView!

    @IBOutlet weak var vFunc: UIView!
    @IBOutlet weak var vEmpty: UIView!
    @IBOutlet weak var vPagerView: FSPagerView!
    var posIndex = 0
    var listSave: [ImageDocModel] = []
    let animationEmpty = LottieAnimationView(name: "empty")

    override func viewDidLoad() {
        super.viewDidLoad()

        vPagerView.delegate = self
        vPagerView.dataSource = self
        vPagerView.transformer = FSPagerViewTransformer(type: .overlap)
        let transform = CGAffineTransform(scaleX: 0.6, y: 1)
        self.vPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.vPagerView.itemSize = self.vPagerView.frame.size.applying(transform)
        self.vPagerView.decelerationDistance = FSPagerView.automaticDistance

        vPageControl.currentPage = 0
        vPageControl.setFillColor(.lightGray, for: .normal)
        vPageControl.setFillColor(.white, for: .selected)
        
        animationEmpty.contentMode = .scaleAspectFill
        vAnimation.addSubview(animationEmpty)
        animationEmpty.frame = CGRect(x: 0, y: 0, width: vAnimation.frame.width, height: vAnimation.frame.height)
        self.animationEmpty.play(fromProgress: 0,
                                   toProgress: 1,
                                   loopMode: LottieLoopMode.loop,
                                   completion: { (finished) in})
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listSave = ImageDocModel.readFromFileJson()
        vPageControl.numberOfPages = listSave.count
        showViewEmpty()
        self.vPagerView.reloadData()
    }
    func showViewEmpty() {
        if(listSave.count == 0) {
            vEmpty.isHidden = false
            vFunc.isHidden = true
        }else {
            vEmpty.isHidden = true
            vFunc.isHidden = false
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionShare(_ sender: Any) {
        if(listSave.count == 1) {
            posIndex = 0
        }
        if(posIndex < listSave.count) {
            let model = listSave[posIndex]
            if let image = UIImage(contentsOfFile: model.url.path) {
                let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                share.popoverPresentationController?.sourceView = self.vShare
                self.present(share, animated: true, completion: nil)
            }else {
                MessageApp.shared.showMessage(messageType: .error, message: "Share image error")
            }
        }else {
            MessageApp.shared.showMessage(messageType: .error, message: "Share image error")
        }
       
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        if(listSave.count == 1) {
            posIndex = 0
        }
        if(posIndex < listSave.count) {
            let pos = posIndex
            ImageDocModel.deleteFile(model: listSave[posIndex])
            listSave.remove(at: pos)
            vPageControl.numberOfPages = listSave.count
            vPagerView.reloadData()
            showViewEmpty()
        }else {
            MessageApp.shared.showMessage(messageType: .error, message: "Delete image error")
        }
       
    }
    
}
extension SavedImageVC :FSPagerViewDataSource,FSPagerViewDelegate{
    // MARK:- FSPagerViewDataSource
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return listSave.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let model = listSave[index]
        let image = UIImage(contentsOfFile: model.url.path)
        cell.imageView?.image = image
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
       
    }
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.vPageControl.currentPage = targetIndex
        posIndex = targetIndex
        print("trungnc: 1234: \(posIndex)")
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.vPageControl.currentPage = pagerView.currentIndex
        print("trungnc: posIndex: \(pagerView.currentIndex)")

    }
}
