//
//  ImageViewer.swift
//  BBUICore
//
//  Created by Bigbasket on 09/11/21.
//

import UIKit

public protocol ImageViewerDelegate: AnyObject {
    func imageViewer(_ imageViewer: ImageViewer, didSelectImageAtIndex index: Int)
    func imageViewer(_ imageViewer: ImageViewer, didZoomImageAtIndex index: Int)
}

public class ImageViewer: UIViewController {

    var thumbnailCollectionView: UICollectionView!
    var imageCollectionView: UICollectionView!
    var imageViewerVM: ImageViewerVM!
    var selectedIndexOfImage: Int
    public weak var delegate: ImageViewerDelegate? = nil
    
    public init(withImageViewerVM imageViewerVM: ImageViewerVM, selectedIndex: Int) {
        
        self.imageViewerVM = imageViewerVM
        self.selectedIndexOfImage = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        createAndlayoutViews()
        // Do any additional setup after loading the view.
        view.setNeedsLayout()
        view.layoutIfNeeded()
        if let selectedIndex = imageViewerVM.getSelectedItemVMIndex() {
            imageCollectionView.scrollToItem(at: IndexPath(item: selectedIndexOfImage, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
        self.selectedIndexOfImage = -1
    }
    
    @objc func didTapCloseButton(_ sender: UIButton)
    {
        self.dismiss(animated: true) {
            
        }
    }
    
    private  func createAndlayoutViews() {
     
        view.backgroundColor = UIColor.white
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn)
        btn.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        btn.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        btn.addTarget(self, action: #selector(didTapCloseButton(_:)), for: UIControl.Event.touchUpInside)
        let imgName = BBUICoreConfigManager.imageProvider(.kGrayCloseBtn)
        let image = UIImage(named: imgName)
        btn.setImage(image, for: UIControl.State.normal)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        thumbnailCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
        thumbnailCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -20.0).isActive = true
        thumbnailCollectionView.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 10.0).isActive = true
        thumbnailCollectionView.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: -10.0).isActive = true
        thumbnailCollectionView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        thumbnailCollectionView.backgroundColor = UIColor.clear
        
        let layout1 = UICollectionViewFlowLayout.init()
        layout1.scrollDirection = .horizontal
        imageCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout1)
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.backgroundColor = UIColor.clear
        view.addSubview(imageCollectionView)
        imageCollectionView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0.0).isActive = true
        imageCollectionView.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 0.0).isActive = true
        imageCollectionView.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: 0.0).isActive = true
        imageCollectionView.bottomAnchor.constraint(equalTo: thumbnailCollectionView.topAnchor, constant: -20.0).isActive = true
        view.bringSubviewToFront(btn)
        registerCells()
    }
    
    private func registerCells() {
        
        thumbnailCollectionView.register(ImageViewerThumbnailCell.self, forCellWithReuseIdentifier: "ImageViewerThumbnailCell")
        imageCollectionView.register(ImageViewerImageCell.self, forCellWithReuseIdentifier: "ImageViewerImageCell")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ImageViewer: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageViewerVM.imageCount()
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
        let prevSelectedItemVM = imageViewerVM.getSelectedItemVM()
        prevSelectedItemVM?.selected = false
        let selectedItemVM = imageViewerVM.getImageItemVM(atIndex: ((self.selectedIndexOfImage != -1) ? self.selectedIndexOfImage: indexPath.row))
        selectedItemVM.selected = true
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == thumbnailCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewerThumbnailCell", for: indexPath) as? ImageViewerThumbnailCell{
                cell.configure(withImage: imageViewerVM.getImageItemVM(atIndex: indexPath.row))
                return cell
            }
        }
        else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewerImageCell", for: indexPath) as? ImageViewerImageCell{
                cell.delegate = self
                let selectedItem = imageViewerVM.getImageItemVM(atIndex: indexPath.row)
                cell.configure(withImage: selectedItem, withIndexPath: indexPath)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == thumbnailCollectionView {
            return CGSize(width: 70.0, height: 70.0)
        }
        else {
            return collectionView.frame.size
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == thumbnailCollectionView {
            return 10.0
        }
        return 0.0
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if thumbnailCollectionView == collectionView {
            
            let prevSelectedItemVM = imageViewerVM.getSelectedItemVM()
            prevSelectedItemVM?.selected = false
            let selectedItemVM = imageViewerVM.getImageItemVM(atIndex: indexPath.row)
            selectedItemVM.selected = true
            imageCollectionView.reloadData()
            imageCollectionView.layoutIfNeeded()
            imageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            delegate?.imageViewer(self, didSelectImageAtIndex: indexPath.row)
        }
    }
}

extension ImageViewer: ImageViewerImageCellDelegate {
    
    func imageViewerImageCellDidZoom(_ imageViewerImageCell: ImageViewerImageCell, atIndex index: Int) {
        delegate?.imageViewer(self, didZoomImageAtIndex: index)
    }
}
