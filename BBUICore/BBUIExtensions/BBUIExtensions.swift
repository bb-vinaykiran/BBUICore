//
//  BBUIExtensions.swift
//  BBUICore
//
//  Created by Bigbasket on 28/09/21.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import EasyTipView

public enum ArrowPosition: Int {
    case any = 0
    case top = 1
    case bottom = 2
    case right = 3
    case left = 4
}

public enum BBUIAxis: Int {
    
    case horizontal
    case vertical
}

public enum BBToastAlignment: Int {
    
    case center
    case top
    case bottom
}


public extension UIViewController {
    
    /**
     *  To set add view controller as child to a view controller.
     *
     *  @param childVC  Child View Controller
     *  @param view     View to which child view controller will be added as subview
     *  @param frame    Frame of child view controller
     */
    func add(childViewContrller childVC: UIViewController,
             inView view: UIView,
             withFrame inFrame: CGRect) {
        
        childVC.view.frame = inFrame
        view.addSubview(childVC.view)
        self.addChild(childVC);
        childVC.didMove(toParent: self)
    }
    
    /**
     *  To remove child view controller.
     *
     *  @param childVC Child view controller.
     */
    func remove(childControllerVC childVC: UIViewController) {
        
        childVC.willMove(toParent: nil)
        childVC.removeFromParent()
        childVC.view.removeFromSuperview()
    }
    
    class func getSafeAreaInset() -> UIEdgeInsets {
        
        if #available(iOS 11.0, *) {
            if let appDel = UIApplication.shared.delegate {
                if let mainWindow = appDel.window {
                    return mainWindow?.safeAreaInsets ?? UIEdgeInsets.zero
                }
            }
        }
        return UIEdgeInsets.zero
    }
}

public extension UIBarButtonItem {
    
    class func barButtonItem(withSpace space: CGFloat) -> UIBarButtonItem {
        
        let fixedItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedItem.width = space;
        return fixedItem;
    }
    
    class func barButtonItem(withImageName imgName: String,
                             withTarget target: Any?,
                             withSelector selecter: Selector) -> UIBarButtonItem {
        let img = UIImage(named: imgName)
        let btn = UIBarButtonItem.barButtonCustomButton(withImage: img,
                                                        withTarget: target,
                                                        withSelector: selecter)
        let barBtn = UIBarButtonItem.init(customView: btn)
        return barBtn
    }
    
    class func barButtonCustomButton(withImage image: UIImage?,
                                     withTarget target: Any?,
                                     withSelector selecter: Selector) -> UIButton {
        var xPosition = 16.0
        if #available(iOS 11, *) {
            xPosition = 0.0
        }
        let btn = UIButton.init(frame: CGRect(x: xPosition, y: 0.0, width: 40.0, height: 44.0))
        btn.setImage(image, for: UIControl.State.normal)
        btn.addTarget(target, action: selecter, for: UIControl.Event.touchUpInside)
        return btn
    }
}

public extension UIFont {
    
    class func bbFont(withName name: String,
                      withSize size: CGFloat) -> UIFont {
        //        if([UIDevice isIpadDevice])
        //            fontSize = fontSize + iPadChangeInDynamicFontSize;
        if let font = UIFont(name: name, size: size) {
            return font;
        }
        return UIFont.systemFont(ofSize: size)
    }
}

public extension URLResponse {

    static func isServerMaintainance(errorCode code: Int?) -> Bool {
        if let code = code {
            if code == 502, code == 503, code == 504 {
                return true
            }
        }
        return false
    }
}

public extension URL {

    static func isNoNetwork(errorCode code: Int?) -> Bool {
        if let code = code {
            if code == NSURLErrorNetworkConnectionLost
                ||
                code == NSURLErrorTimedOut
                ||
                code == NSURLErrorNotConnectedToInternet
                ||
                code == NSURLErrorCannotLoadFromNetwork {
                return true;
            }
        }
        return false
    }
}


public extension UIView {
    
    func addConstraint(fromView superView: UIView, withEdgeInset edgeInset: UIEdgeInsets) {
        
        leftAnchor.constraint(equalTo: superView.leftAnchor, constant: edgeInset.left).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor, constant: edgeInset.right).isActive = true
        topAnchor.constraint(equalTo: superView.topAnchor, constant: edgeInset.top).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: edgeInset.bottom).isActive = true
    }
    
    @discardableResult func showToast(withLeftMargin margin: CGFloat, withTopOrBottomMargin topOrBottomMargin: CGFloat, withMessage msg: String, withToastPosition alignment: BBToastAlignment, withTextFont textFont: UIFont? = nil, withCornerRadius cornerRadius: CGFloat, withBackgroundColor bgColor: UIColor, withComplpetionHandler complpetionHandler: ((Bool) -> Void)?) -> UIView {
        
        viewWithTag(9999)?.removeFromSuperview()
        let tosteView = UIView.init()
        tosteView.tag = 9999
        tosteView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tosteView)
        tosteView.backgroundColor = bgColor
        let lbl = UILabel.init()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.text = msg;
        lbl.textColor = UIColor.white
        if let textFont = textFont {
            lbl.font = textFont
        }
        else {
            
            lbl.font = UIFont.bbFont(withName: AppAssetConfigManager.fontProvider(.kRegular), withSize: AppAssetConfigManager.fontSizeProvider(.kPLFont12))
        }
        lbl.textAlignment = .center;
        lbl.backgroundColor = UIColor.clear
        lbl.numberOfLines = 0;
        
        let lblTop: CGFloat = 8.0;
        let lblBottom: CGFloat = -8.0;
        let lblLeft: CGFloat = 8.0;
        let lblRight: CGFloat = -8.0;
        tosteView.addSubview(lbl)
        lbl.leadingAnchor.constraint(equalTo: tosteView.leadingAnchor, constant: lblLeft).isActive = true
        lbl.trailingAnchor.constraint(equalTo: tosteView.trailingAnchor, constant: lblRight).isActive = true
        lbl.topAnchor.constraint(equalTo: tosteView.topAnchor, constant: lblTop).isActive = true
        lbl.bottomAnchor.constraint(equalTo: tosteView.bottomAnchor, constant: lblBottom).isActive = true
        tosteView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        tosteView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
        let centerY = tosteView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0)
        centerY.isActive = true
        tosteView.layoutIfNeeded()
        var offset: CGFloat = 0.0;
        if alignment == BBToastAlignment.center {
            offset -= topOrBottomMargin
        }
        else if alignment == BBToastAlignment.top {
            offset = -(frame.size.height/2) + (tosteView.frame.size.height/2.0) + topOrBottomMargin;
        }
        else if alignment == BBToastAlignment.bottom {
            offset = (frame.size.height/2) - (tosteView.frame.size.height/2.0) - topOrBottomMargin;
        }
        centerY.constant = offset;
        tosteView.layoutIfNeeded()
        tosteView.layer.cornerRadius = cornerRadius;
        tosteView.layer.masksToBounds = true;
        tosteView.clipsToBounds = true;
        bringSubviewToFront(tosteView)
        tosteView.alpha = 0.0;
        UIView.animate(withDuration: 0.4) {
            tosteView.alpha = 1.0
        } completion: { (completed) in
            if let complpetionHandler = complpetionHandler {
                complpetionHandler(completed)
            }
        }
        return tosteView;
        
    }
    
    func removeToast(withComplpetionHandler complpetionHandler: ((Bool) -> Void)?) {
        
        if let toastView = viewWithTag(9999) {
            UIView.animate(withDuration: 0.4) {
                toastView.alpha = 0.0
            } completion: { (completed) in
                if let complpetionHandler = complpetionHandler {
                    complpetionHandler(completed)
                }
            }
        }
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    
    func roundRoundCorners(forCorners corners: UIRectCorner, withRadius radius: CGFloat) {
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.cgPath;
        self.layer.mask = maskLayer;
    }
    
    func startViewLoading() {
        
        self.stopViewLoading()
        
        let containerView = UIView() // [[UIView alloc] initWithFrame: CGRectMake(0, 0, kMainScreenWidth, view.frame.size.height)];
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)
        containerView.tag = 12344;
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: AppAssetConfigManager.imageProvider(.kLoaderCricle))
        backgroundImageView.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        backgroundImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0.0).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0.0).isActive = true
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0.0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1.0;
        rotation.repeatCount = Float.infinity;
        rotation.isRemovedOnCompletion = false;
        backgroundImageView.layer.removeAllAnimations()
        backgroundImageView.layer.add(rotation, forKey: "Spin")
        self.bringSubviewToFront(containerView)
    }
    
    func startCartInlineIndicator(withImageName image: UIImage, withLoaderHeight loaderHeight: CGFloat) {
        
        stopCartInlineIndicator()
        let loadingImage = UIImageView.init(frame: CGRect.zero)
        loadingImage.tag = 12346
        addSubview(loadingImage)
        loadingImage.image = image
        loadingImage.translatesAutoresizingMaskIntoConstraints = false
        loadingImage.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.0).isActive = true
        loadingImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        loadingImage.widthAnchor.constraint(equalToConstant: loaderHeight).isActive = true
        loadingImage.heightAnchor.constraint(equalToConstant: loaderHeight).isActive = true
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0.0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1.0;
        rotation.repeatCount = Float.infinity;
        rotation.isRemovedOnCompletion = false;
        loadingImage.layer.removeAllAnimations()
        loadingImage.layer.add(rotation, forKey: "Spin")
        bringSubviewToFront(loadingImage)
    }
    
    func stopCartInlineIndicator() {

        viewWithTag(12346)?.removeFromSuperview()
    }
    
    func stopViewLoading() {
        
        self.viewWithTag(12344)?.removeFromSuperview()
    }
    
    func showIncrementalFetchLoader() {

        if nil == viewWithTag(10234) {

            isUserInteractionEnabled = false
            let viewWidth: CGFloat = 100.0
            let viewHeight: CGFloat = 80.0
            let container = UIView(frame: CGRect(x: (frame.size.width - viewWidth) / 2.0, y: (frame.size.height - viewHeight) / 2.0, width: viewWidth, height: viewHeight))
            container.tag = 10234

            let activity = UIActivityIndicatorView(style: .white)
            activity.tag = 100
            var temp = activity.frame
            temp.origin = CGPoint(x: ((container.frame.size.width) - activity.frame.size.width) / 2.0, y: ((container.frame.size.width / 2.0) - activity.frame.size.height) / 2.0)
            activity.frame = temp
            container.addSubview(activity)
            activity.startAnimating()
            
            let yOffset: CGFloat = activity.frame.origin.y + activity.frame.size.height
            let label = UILabel(frame: CGRect(x: 0, y: yOffset, width: container.frame.size.width, height: container.frame.size.height - yOffset))
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            label.font = UIFont.bbFont(withName: AppAssetConfigManager.fontProvider(.kRegular), withSize: AppAssetConfigManager.fontSizeProvider(.kPLFont12))
            label.textAlignment = .center
            label.textColor = AppAssetConfigManager.colorProvider(.kWhiteColor)
            label.text = "Loading..."
            container.addSubview(label)
            container.layer.cornerRadius = 10.0
            container.layer.masksToBounds = true
            container.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)

            addSubview(container)
        }
    }
    
    func removeIncrementalFetchLoader() {
        isUserInteractionEnabled = true
        (viewWithTag(10234)?.viewWithTag(100) as? UIActivityIndicatorView)?.stopAnimating()
        viewWithTag(10234)?.removeFromSuperview()
    }
    

    
    func addSeperator(withColor color: UIColor) {
        
        var seperator = self.viewWithTag(111)
        if nil == seperator {
            seperator = UIView()
            seperator!.tag = 111
            seperator!.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(seperator!)
            seperator!.backgroundColor = color
            seperator!.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0).isActive = true
            seperator!.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0).isActive = true
            seperator!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
            seperator!.heightAnchor.constraint(equalToConstant: 1.0).isActive = true;
        }
        else {
            
        }
    }
    
    ///
    /// An Extention to add addDashBorderLayer to this view as a layer
    /// - Parameter colors: stroke color
    /// - Parameter cornerRadius: corner radius is an optional param
    func addDashBorderLayer(color: UIColor, cornerRadius: CGFloat = 0, frame: CGRect)->CAShapeLayer{
        let dashBorder = CAShapeLayer()
        dashBorder.name = "dash_border"
        dashBorder.lineWidth = 0.9
        dashBorder.strokeColor = color.cgColor
        dashBorder.lineDashPattern = [2, 2] as [NSNumber]
        dashBorder.frame = self.bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        return dashBorder
    }
    
    
    func startShimmerAnimating(cornerRadius: CGFloat? = nil, firstColor: UIColor, secondColor: UIColor) {
        let gradientLayer = BBNewGradientLayer(direction: .leftToRight, type: .axial, colors: [firstColor, secondColor], cornerRadius: cornerRadius, locations: [0.0, 0.5, 1.0])
        let cloneGradient = gradientLayer.clone()
        cloneGradient.name = "Shimmer"
        cloneGradient.frame = self.bounds
        if let corner = cornerRadius{
            cloneGradient.cornerRadius = corner
        }else{
            cloneGradient.cornerRadius = self.bounds.height / 2
        }
        self.layer.addSublayer(cloneGradient)
        let animation = addAnimation()
        cloneGradient.zPosition = 1
        cloneGradient.add(animation, forKey: animation.keyPath)
    }
    
    private func addAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 2.0
        //        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    func stopShimmerAnimating() {
        self.layer.sublayers?.forEach({ (layer) in
            if layer.name == "Shimmer" {
                layer.removeFromSuperlayer()
            }
        })
    }
    
    func addGradient(tag: Int, direction: GradientDirection, type: CAGradientLayerType, name: String?, colors: [UIColor], cornerRadius: CGFloat = 0, locations: [Double])->CAGradientLayer {
        let gradientLayer = BBNewGradientLayer(direction: direction, type: type, name: name, colors: colors, cornerRadius: cornerRadius, locations: locations)
        return addGradient(tag: tag, gradientLayer: gradientLayer)
    }
    
    func addGradient(tag: Int, gradientLayer: BBNewGradientLayer, cornerRadius: CGFloat = 0)->CAGradientLayer {
        let cloneGradient = gradientLayer.clone()
        cloneGradient.frame = self.bounds
        cloneGradient.cornerRadius = cornerRadius
        cloneGradient.zPosition = -1
        self.tag = tag
        return cloneGradient
    }
    
    func dropShadow(color: UIColor, opacity: Float, offSet: CGSize, radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
    
    func removeSeperator() {
        
        self.viewWithTag(111)?.removeFromSuperview()
    }
    
    func addTapGesture(withTarget target: Any,
                       withSelector selecter: Selector) {
        
        let tapGesture = UITapGestureRecognizer.init()
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
        tapGesture.addTarget(target, action: selecter)
    }
    
    static func dashedShapeLayer(withColor color: UIColor, inFrame frame: CGRect) -> CAShapeLayer {
        let caShapelayer = CAShapeLayer()
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: frame.origin)
        let endPoint = CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y)
        bezierPath.addLine(to: endPoint)
        
        caShapelayer.strokeStart = 0.0;
        caShapelayer.strokeColor = color.cgColor;
        caShapelayer.lineWidth = 1.0;
        caShapelayer.lineJoin = CAShapeLayerLineJoin.round
        caShapelayer.lineDashPattern = [3, 2];
        caShapelayer.path = bezierPath.cgPath
        return caShapelayer;
    }
    
    func createColorGradientforColours(withColors colors: [UIColor], forAxis axis: BBUIAxis) {
        if let view = viewWithTag(102512) {
            view.removeFromSuperview()
        }
        let view = UIView.init(frame: bounds)
        let gradient = CAGradientLayer.init()
        gradient.frame = bounds;
        var cgColors = [CGColor]()
        for color in colors {
            cgColors.append(color.cgColor)
        }
        gradient.colors = cgColors;
        if axis == BBUIAxis.horizontal {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        }
        else if axis == BBUIAxis.vertical {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        }
        view.tag = 102512;
        view.layer.insertSublayer(gradient, at: 0)
        addSubview(view)
    }
    
    func addConstraints(toSubview subview: UIView, withEdgeInset edgeInset: UIEdgeInsets) {
        
        let left = NSLayoutConstraint(item: subview, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: edgeInset.left)
        let right = NSLayoutConstraint(item: subview, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: edgeInset.right)
        let top = NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: edgeInset.top)
        let bottom = NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: edgeInset.bottom)
        
        self.addConstraints([left, right, top, bottom])
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        
    }
    
    func getEasyTipViewWithArrow(message: String, maxWidth: CGFloat = 320, position: ArrowPosition, font: UIFont? = UIFont(name: AppAssetConfigManager.fontProvider(.kMedium), size: AppAssetConfigManager.fontSizeProvider( .kPLFont10))!) -> EasyTipView {
        
        var aPosition = EasyTipView.ArrowPosition.bottom
        
        switch position {
        case .any:
            aPosition = EasyTipView.ArrowPosition.any
        case .top:
            aPosition = EasyTipView.ArrowPosition.top
        case .bottom:
            aPosition = EasyTipView.ArrowPosition.bottom
        case .right:
            aPosition = EasyTipView.ArrowPosition.right
        case .left:
            aPosition = EasyTipView.ArrowPosition.left
        }

        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: AppAssetConfigManager.fontProvider(.kMedium), size: AppAssetConfigManager.fontSizeProvider( .kPLFont10))!
        preferences.drawing.foregroundColor = .white
        preferences.drawing.arrowPosition = aPosition
        preferences.drawing.cornerRadius = 4.0
        preferences.drawing.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        preferences.positioning.maxWidth = maxWidth
        preferences.positioning.bubbleHInset = 20
        preferences.drawing.textAlignment = NSTextAlignment.center;
        return EasyTipView(text: message, preferences: preferences)
    }
    
    func getEasyTipViewWithBottomArrow(message: String, maxWidth: CGFloat = 320) -> EasyTipView {
        return self.getEasyTipViewWithArrow(message: message, maxWidth: maxWidth, position: .bottom)
    }
    
    func getEasyTipViewWithDefaultPreferences(message: String, maxWidth: CGFloat = 320) -> EasyTipView {
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: AppAssetConfigManager.fontProvider(.kRegular), size: AppAssetConfigManager.fontSizeProvider( .kPLFont12))!
        preferences.drawing.foregroundColor = AppAssetConfigManager.colorProvider(.kWhiteColor)
        preferences.drawing.backgroundColor = AppAssetConfigManager.colorProvider(.kEasyTipBGColor)
        preferences.positioning.maxWidth = maxWidth
        preferences.positioning.bubbleHInset = 20
        return EasyTipView(text: message, preferences: preferences)
    }
}

public enum GradientDirection {
    case topToBottom
    case bottomToTop
    case leftToRight
    case rightToLeft
    case topLeftToBottomRight
    case topRightToBottomLeft
    case bottomLeftToTopRight
    case bottomRightToTopLeft
}

class BBNewGradientHelper {
    
    public static func getStartAndEndPointsOf(_ gradientDirection: GradientDirection) -> (startPoint: CGPoint, endPoint: CGPoint) {
        switch gradientDirection {
        case .topToBottom:
            return (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
        case .bottomToTop:
            return (CGPoint(x: 0.5, y: 1.0), CGPoint(x: 0.5, y: 0.0))
        case .leftToRight:
            return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
        case .rightToLeft:
            return (CGPoint(x: 1.0, y: 0.5), CGPoint(x: 0.0, y: 0.5))
        case .topLeftToBottomRight:
            return (CGPoint.zero, CGPoint(x: 1.0, y: 1.0))
        case .topRightToBottomLeft:
            return (CGPoint(x: 1.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
        case .bottomLeftToTopRight:
            return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0))
        case .bottomRightToTopLeft:
            return (CGPoint(x: 1.0, y: 1.0), CGPoint(x: 0.0, y: 0.0))
        }
    }
    
    public static func getGradientDirection(value: String)->GradientDirection {
        switch value {
        case "TOP_BOTTOM":
            return .topToBottom
        case "TR_BL":
            return .topRightToBottomLeft
        case "RIGHT_LEFT":
            return .rightToLeft
        case "BR_TL":
            return .bottomRightToTopLeft
        case "BOTTOM_TOP":
            return .bottomToTop
        case "BL_TR":
            return .bottomLeftToTopRight
        case "LEFT_RIGHT":
            return .leftToRight
        case "TL_BR":
            return .topLeftToBottomRight
        default:
            return .topLeftToBottomRight
        }
    }
}
open class BBNewGradientLayer: CAGradientLayer {
    
    private var direction: GradientDirection = .leftToRight
    
    // swiftlint:disable:next discouraged_optional_collection
    public init(direction: GradientDirection, type: CAGradientLayerType, name: String? = nil, colors: [UIColor], cornerRadius: CGFloat?, locations: [Double]? = nil) {
        super.init()
        self.direction = direction
        self.type = type
        self.name = name
        self.colors = colors.map { $0.cgColor as Any }
        let (startPoint, endPoint) = BBNewGradientHelper.getStartAndEndPointsOf(direction)
        self.startPoint = startPoint
        self.endPoint = endPoint
        if let radius = cornerRadius{
            self.cornerRadius = radius
        }else{
            self.cornerRadius = self.bounds.height / 2
        }
        self.locations = locations?.map { NSNumber(value: $0) }
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    public final func clone() -> BBNewGradientLayer {
        if let colors = self.colors {
            // swiftlint:disable:next force_cast
            return BBNewGradientLayer(direction: self.direction, type: self.type, name: self.name, colors: colors.map { UIColor(cgColor: ($0 as! CGColor)) }, cornerRadius: self.cornerRadius, locations: self.locations?.map { $0.doubleValue } )
        }
        return BBNewGradientLayer(direction: self.direction, type: self.type, name: self.name, colors: [], cornerRadius: self.cornerRadius, locations: self.locations?.map { $0.doubleValue })
    }
}


public extension Int {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    var delimiter: String {
        return Int.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

public extension CGSize {
    func isGreaterOrEqual(to size: CGSize) -> Bool {
        return width >= size.width &&
            height >= size.height
    }
    
    func isGreaterThanSize(_ size: CGSize) -> Bool {
        return width > size.width &&
            height > size.height
    }
}

public extension UINavigationBar {
    
    func showNavigationBarShadow() {
        layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 4.0;
        layer.shadowOpacity = 0.6
    }

    func hideNavigationBarShadow() {
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 0.0
    }
}

public extension UIColor {
    
    class func color(forRating rating: CGFloat) -> UIColor {
        var ratingColor = AppAssetConfigManager.colorProvider(.kRatingStarColorDefault)
        if rating < 2 {
            ratingColor = AppAssetConfigManager.colorProvider(.kRatingStarColorbelow2)
        }
        else if rating < 3 {
            ratingColor = AppAssetConfigManager.colorProvider(.kRatingStarColorbelow3)
        }
        return ratingColor;
    }
    
    convenience init(hex: String) {
        let red, green, blue, alpha: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    alpha = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: red, green: green, blue: blue, alpha: alpha)
                    return
                }
            }
        }
        self.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return
    }
    
     static func colorWithHex(hexString: String?) -> UIColor {
         if let  hexStr = hexString, !(hexStr.isEmpty) {
             let colorString = hexStr.replacingOccurrences(of: "#", with: "").uppercased()
             var alpha: CGFloat
             var red: CGFloat
             var blue: CGFloat
             var green: CGFloat

             var color: UIColor?
             switch (colorString.count) {
             case 3 /* #RGB */:
                 alpha = 1.0
                 red = self.colorComponent(from: colorString, start: 0, length: 1)
                 green = self.colorComponent(from: colorString, start: 1, length: 1)
                 blue = self.colorComponent(from: colorString, start: 2, length: 1)
                 color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
             case 4 /* #ARGB */:
                 alpha = self.colorComponent(from: colorString, start: 0, length: 1)
                 red = self.colorComponent(from: colorString, start: 1, length: 1)
                 green = self.colorComponent(from: colorString, start: 2, length: 1)
                 blue = self.colorComponent(from: colorString, start: 3, length: 1)
                 color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
             case 6 /* #RRGGBB */:
                 alpha = 1.0
                 red = self.colorComponent(from: colorString, start: 0, length: 2)
                 green = self.colorComponent(from: colorString, start: 2, length: 2)
                 blue = self.colorComponent(from: colorString, start: 4, length: 2)
                 color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
             case 8 /* #AARRGGBB */:
                 alpha = self.colorComponent(from: colorString, start: 0, length: 2)
                 red = self.colorComponent(from: colorString, start: 2, length: 2)
                 green = self.colorComponent(from: colorString, start: 4, length: 2)
                 blue = self.colorComponent(from: colorString, start: 6, length: 2)
                 color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
             default:
                 color = .white
             }
             return color!
         } else {
             return .white
         }
     }
    
   static func colorComponent(from colorString: String, start: Int, length: Int) -> CGFloat {

        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt32 = 0

        guard Scanner(string: String(fullHexString)).scanHexInt32(&hexComponent) else {
            return 0
        }
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        return floatValue
    }
}

public extension UIImageView {
    
    func setImage(fromURLString urlStr: String?, withPlaceHolder placeHolder: UIImage? = UIImage(named: BBUICoreConfigManager.imageProvider(.kPlaceholder))) {
        
        image = placeHolder
        if let urlStr = urlStr {
            self.image = placeHolder
            AF.request(urlStr).responseImage { [weak self] response in
                
                guard let self = self else { return }
                if case .success(let image) = response.result {
                    
                    self.image = image
                }
            }
        }
    }
}
