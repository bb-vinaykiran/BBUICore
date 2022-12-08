//
//  NumberRatingView.swift
//  BBUICore
//
//  Created by Bigbasket on 20/10/21.
//

import UIKit

public enum NumberRatingViewStarAlignment {
    case center
    case bottom
}

public class NumberRatingView: UIView {
    var iconHeightConstraint: NSLayoutConstraint!
    var iconWidthConstraint: NSLayoutConstraint!
    var starImageView = UIImageView.init()
    var ratingLabel = UILabel.init()
    var starAlignment = NumberRatingViewStarAlignment.center
    
    var ratingLblFont = UIFont.bbFont(withName: AppAssetConfigManager.fontProvider(.kSemibold), withSize: AppAssetConfigManager.fontSizeProvider(.kPLFont10))
    var bgColor: UIColor? = nil
    var iconSize =  CGSize(width: 7.0, height: 7.0)
    
    @IBInspectable public var rating: Double = 3 {
        
        didSet {
            starImageView.tintColor = UIColor.color(forRating: CGFloat(rating))
            ratingLabel.textColor = starImageView.tintColor
            if(rating.truncatingRemainder(dividingBy: 1) != 0)
            {
                ratingLabel.text = String(format: "%.1f", rating)
            }
            else
            {
                ratingLabel.text = String(format: "%.f", rating)
            }
            if let bgColor = bgColor {
                backgroundColor = bgColor
            }
            else {
                backgroundColor = starImageView.tintColor.withAlphaComponent(0.15)
            }
        }
    }
    
    fileprivate func initilizeViews() {
        
        addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.0).isActive = true
        ratingLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        ratingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true

        addSubview(starImageView)
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        iconWidthConstraint = starImageView.widthAnchor.constraint(equalToConstant: iconSize.width)
        iconWidthConstraint.isActive = true
        iconHeightConstraint = starImageView.heightAnchor.constraint(equalToConstant: iconSize.height)
        iconHeightConstraint.isActive = true
        starImageView.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: (iconSize.width/3.0)).isActive = true
        starImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4.0).isActive = true
        if starAlignment == NumberRatingViewStarAlignment.center {
        starImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        }
        else {
            starImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0).isActive = true
        }
        let imageName = AppAssetConfigManager.imageProvider(.kRatingSelectedStar)
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        starImageView.image = image
        
        ratingLabel.font = ratingLblFont 
        ratingLabel.textAlignment = .center
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initilizeViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initilizeViews()
    }
    
    public init(withRatingFont ratingFont: UIFont, iconSize size: CGSize, withBGColor bgColor: UIColor, withStarAlignement alignment: NumberRatingViewStarAlignment) {
        super.init(frame: CGRect.zero)
        ratingLblFont = ratingFont
        iconSize = size
        starAlignment = alignment
        self.bgColor = bgColor
        initilizeViews()
    }
    
    public func showRatingView(){
        
        iconHeightConstraint.constant = iconSize.width
        iconWidthConstraint.constant = iconSize.height
        let imageName = AppAssetConfigManager.imageProvider(.kRatingSelectedStar)
        starImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
    }
    
    public func hideRatingView(){
        iconHeightConstraint.constant = 0
        iconWidthConstraint.constant = 0
        starImageView.image = UIImage()
        ratingLabel.text = ""
    }
}
