//
//  ImageViewerThumbnailCell.swift
//  BBUICore
//
//  Created by Bigbasket on 09/11/21.
//

import UIKit

class ImageViewerThumbnailCell: UICollectionViewCell {
    
    var cellImgView: UIImageView!
//    var imageViewerItemVM: ImageViewerItemVM!
    override init(frame: CGRect) {
     
        super.init(frame: frame)
        createAndlayoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleProductViewModel(event: ImageViewerItemVMEvent, witImageViewerItemVM imageViewerItemVM: ImageViewerItemVM) {
        
        switch event {
        case .changeSelectionState:
            updateSelection(withImageViewerVM: imageViewerItemVM)
            break
        }
    }
    
    
    func configure(withImage imageViewerItemVM: ImageViewerItemVM) {
        
//        self.imageViewerItemVM = imageViewerItemVM
        imageViewerItemVM.viewModelEventCallback = {[weak self] (imgViewerItemVM: ImageViewerItemVM, event: ImageViewerItemVMEvent) in
            
            guard let self = self else { return }
            self.handleProductViewModel(event: event, witImageViewerItemVM: imgViewerItemVM)
        }
        cellImgView.setImage(fromURLString: imageViewerItemVM.getThumbURL())
        if imageViewerItemVM.selected {
            selecteCell()
        }
        else {
            deselectCell()
        }
    }
    
    func updateSelection(withImageViewerVM imageViewerItemVM: ImageViewerItemVM) {
        
        if imageViewerItemVM.selected {
            selecteCell()
        }
        else {
            deselectCell()
        }
    }
    
    func selecteCell() {
        
        cellImgView.layer.borderColor = BBUICoreConfigManager.colorProvider(.kImageViewerSelectedBorder).cgColor
    }
    
    func deselectCell() {
        cellImgView.layer.borderColor = BBUICoreConfigManager.colorProvider(.kImageViewerUnSelectedBorder).cgColor
    }
    
    func createAndlayoutViews() {

        let imageView = UIImageView.init()
        cellImgView = imageView
        cellImgView.translatesAutoresizingMaskIntoConstraints = false
        cellImgView.isUserInteractionEnabled = false
        contentView.addSubview(cellImgView)
        cellImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
        cellImgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0).isActive = true
        cellImgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0).isActive = true
        cellImgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0).isActive = true
        cellImgView.layer.cornerRadius = 2.0
        cellImgView.layer.masksToBounds = true
        cellImgView.layer.borderWidth = 1.0
    }
}
