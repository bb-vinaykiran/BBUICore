//
//  BBStarRatingView.swift
//  BBUICore
//
//  Created by Bigbasket on 28/09/21.
//

import UIKit

public enum RatingError: Error {
    case runtimeError(String)
}

public protocol BBStarRatingViewDelegate: AnyObject {

    func bbStarRatingView(_ bbStarRatingView: BBStarRatingView, didGaveRating rating: Int)
}

public class BBStarRatingView: UIView {

    private var ratedImage: UIImage
    private var unRatedImage: UIImage?
    private var starSize: CGSize
    private var rating: Int
    private var maxRating: Int
    private var enableColoring: Bool
    private var margin: CGFloat
    private static let tagOffset = 1000
    public var disabled = false /*{
        
        didSet {

            var ratingColor = UIColor.color(forRating: CGFloat(rating))
            if disabled {
                ratingColor = AppAssetConfigManager.colorProvider(.kSeperatorColor)
                ratingColor = UIColor.purple
            }

            for i in 1...maxRating {
                let tag = BBStarRatingView.tagOffset + i
                if let imageView = self.viewWithTag(tag) as? UIImageView {
                    setImage(forImageView: imageView, withTintColor: ratingColor)
                }
            }
        }
    }*/
    public var delegate: BBStarRatingViewDelegate? = nil
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public init(withRatedImage ratedImage: UIImage,
          withUnRatedImage unRatedImage: UIImage?,
          withStarSize starSize: CGSize,
          withRating rating: Int,
          withMaxRating maxRating: Int = 5,
          enableColoring: Bool = true,
          withMargin margin: CGFloat = 5.0) throws {
        
        self.ratedImage = ratedImage
        self.unRatedImage = unRatedImage
        self.starSize = starSize
        self.rating = rating
        self.maxRating = maxRating
        self.enableColoring  = enableColoring
        self.margin = margin
        let ratedImageSize = ratedImage.size
        if starSize.isGreaterThanSize(ratedImageSize) {
            
            throw RatingError.runtimeError("Rated image size is less than star size")
        }
        if let unRatedImage = unRatedImage {
        
            let unRatedImageSize = unRatedImage.size
            if starSize.isGreaterOrEqual(to: unRatedImageSize) {
                
                throw RatingError.runtimeError("Unrated image size is less than star size")
            }
        }
        
        if maxRating <= 0 {
            throw RatingError.runtimeError("Max rating cannot be less than or equal to zero")
        }
        if rating == 0, nil == unRatedImage {
            throw RatingError.runtimeError("If you are not providing un rated image you cannot set the rating value as 0")
        }
        super.init(frame: CGRect.zero)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeRating(toRating rating: Int) {
        
        self.rating = rating
        
        var ratingColor = UIColor.color(forRating: CGFloat(rating))
        if disabled {
            ratingColor = AppAssetConfigManager.colorProvider(.kSeperatorColor)
        }
        for index in 1...maxRating {
            if let imageView = self.viewWithTag(BBStarRatingView.tagOffset + index) as? UIImageView {
                
                setImage(forImageView: imageView, withTintColor: ratingColor)
            }
            else {
                break
            }
        }
    }
    
    private func setImage(forImageView imageView: UIImageView,
                     withTintColor tintColor: UIColor) {
        
        let index = imageView.tag - BBStarRatingView.tagOffset
        if index <= rating {
            if enableColoring {
                let image = ratedImage.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                imageView.image = image
                imageView.tintColor = tintColor
            }
            else {
                imageView.image = ratedImage
            }
        }
        else {
            if disabled {
                let image = ratedImage.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                imageView.image = image
                imageView.tintColor = tintColor
            }
            else {
                imageView.image = unRatedImage
            }
        }
    }
    
    
    private func createViews() {
       
        var ratingColor = UIColor.color(forRating: CGFloat(rating))
        if disabled {
            ratingColor = AppAssetConfigManager.colorProvider(.kSeperatorColor)
        }
        var prevView: UIImageView? = nil
        for index in 1...maxRating {
//            if i > rating, nil == unRatedImage {
//                break
//            }
            let imageView = UIImageView.init(image: ratedImage)
            imageView.tag = BBStarRatingView.tagOffset + index
            self.addSubview(imageView)
            imageView.isUserInteractionEnabled = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            setImage(forImageView: imageView, withTintColor: ratingColor)
            imageView.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            imageView.addTapGesture(withTarget: self, withSelector: #selector(didTapRating(_:)))
            if nil == prevView {
                
                imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0).isActive = true
            }
            else {
                imageView.leftAnchor.constraint(equalTo: prevView!.rightAnchor, constant: margin).isActive = true
            }
            prevView = imageView
        }
        prevView!.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0).isActive = true
    }
    
    @objc func didTapRating(_ sender: UITapGestureRecognizer) {
        let rate = sender.view!.tag - BBStarRatingView.tagOffset
        delegate?.bbStarRatingView(self, didGaveRating: rate)
    }
}

