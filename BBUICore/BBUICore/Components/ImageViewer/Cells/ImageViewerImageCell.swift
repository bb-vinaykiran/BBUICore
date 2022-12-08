//
//  ImageViewerImageCell.swift
//  BBUICore
//
//  Created by Bigbasket on 09/11/21.
//

import UIKit

protocol ImageViewerImageCellDelegate: AnyObject {
    
    func imageViewerImageCellDidZoom(_ imageViewerImageCell: ImageViewerImageCell, atIndex index: Int)
}

class ImageViewerImageCell: UICollectionViewCell {
 
    var scrollView: UIScrollView!
    var cellImgView: UIImageView!
    var indexPath: IndexPath!
    var delegate: ImageViewerImageCellDelegate? = nil
    override init(frame: CGRect) {
     
        super.init(frame: frame)
        createAndlayoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withImage image: ImageViewerItemVM, withIndexPath indexPath: IndexPath) {
        
        self.indexPath = indexPath
        cellImgView.setImage(fromURLString: image.getImageURL())
    }
    
    func createAndlayoutViews() {

        let scrlView = UIScrollView.init(frame: self.bounds)
        scrollView = scrlView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrlView)
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.delegate = self
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true
        scrollView.backgroundColor = UIColor.clear
        
        
        let imageView = UIImageView.init()
        cellImgView = imageView
        cellImgView.tag = 1001
        cellImgView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cellImgView)
        cellImgView.isUserInteractionEnabled = false
        cellImgView.contentMode = UIView.ContentMode.scaleAspectFit
        cellImgView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0.0).isActive = true
        cellImgView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0.0).isActive = true
        cellImgView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0.0).isActive = true
        cellImgView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0.0).isActive = true
        cellImgView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0).isActive = true
        cellImgView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.0).isActive = true
    }
}

extension ImageViewerImageCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return cellImgView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        delegate?.imageViewerImageCellDidZoom(self, atIndex: indexPath.row)
    }
}
