//
//  ErrorAlertVC.swift
//  BigBasket
//
//  Created by Abhishek Rai on 7/25/18.
//

import UIKit
struct BBUICoreConstant {
    static func getUICoreFrameWorkBundle(forClass inClass: AnyClass) -> Bundle {
        
        let path = Bundle.init(for: inClass).path(forResource: "BBUICore", ofType: "bundle")
        let bundle = Bundle.init(path: path!)
        return bundle!
    }
}

public class ErrorAlertVC: UIViewController {

    @IBOutlet weak fileprivate var titleLbl: UILabel!
    @IBOutlet weak fileprivate var descriptionLbl: UILabel!
    @IBOutlet weak fileprivate var cancelBtn: UIButton!
    @IBOutlet weak fileprivate var continueBtn: UIButton!
    @IBOutlet weak fileprivate var alertContainer: UIView!
    @IBOutlet weak fileprivate var outsideTapBtn: UIButton!
    @IBOutlet weak fileprivate var btnGap: NSLayoutConstraint!
    weak fileprivate var negativeBtnWidth: NSLayoutConstraint?
    public var outsideTap: ((_ errorAlertVC: ErrorAlertVC) ->())? = nil
    public var positiveButtonAction: ((_ errorAlertVC: ErrorAlertVC) ->())? = nil
    public var negativeButtonAction: ((_ errorAlertVC: ErrorAlertVC) ->())? = nil
    var negativeBtnTitle: String? = nil
    var positiveBtnTitle: String!
    var alertDescription: String!
    var alertTitle: String!
    
    public init(withTitle title: String, withDescription desc: String, positiveButtonText positiveBtnText: String, negativeButtonText negativeBtnText: String?) {
        alertTitle = title
        alertDescription = desc
        negativeBtnTitle = negativeBtnText
        positiveBtnTitle = positiveBtnText
        let bundle = BBUICoreConstant.getUICoreFrameWorkBundle(forClass: ErrorAlertVC.self)
        super.init(nibName: "ErrorAlertVC", bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(inVC viewController: UIViewController) {
    
        view.translatesAutoresizingMaskIntoConstraints = false
        viewController.add(childViewContrller: self, inView: viewController.view, withFrame: viewController.view.bounds)
        view.addConstraint(fromView: viewController.view, withEdgeInset: UIEdgeInsets.zero)
    }
    
    @IBAction fileprivate func didTapOutSide() -> Void {
        if let outsideTap = outsideTap {
            outsideTap(self)
        }
        parent?.remove(childControllerVC: self)
    }
    
    @IBAction fileprivate func continueAction() -> Void {
        
        if let positiveButtonAction = positiveButtonAction {
            positiveButtonAction(self)
        }
        parent?.remove(childControllerVC: self)
    }
    
    @IBAction fileprivate func cancelAction() -> Void {
        
        if let negativeButtonAction = negativeButtonAction {
            negativeButtonAction(self)
        }
        parent?.remove(childControllerVC: self)
    }
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        cancelBtn.setTitle("CANCEL", for: .normal) // ABHI_LOC_MO_ LocalizationWrapper.getString(forKey: kCancelTitle).uppercased()
        continueBtn.setTitle("CONTINUE", for: .normal) // ABHI_LOC_MO_LocalizationWrapper.getString(forKey: kContinueTitle).uppercased()
    }
    
    fileprivate func setFontsAndColors() -> Void {
       
        self.view.backgroundColor = UIColor.clear
        self.outsideTapBtn.backgroundColor = UIColor.black.withAlphaComponent(0.2);
        titleLbl.font = UIFont.bbFont(withName: AppAssetConfigManager.fontProvider(.kSemibold), withSize: AppAssetConfigManager.fontSizeProvider(.kPLFont18))
        self.descriptionLbl.font = UIFont.bbFont(withName: AppAssetConfigManager.fontProvider(.kRegular), withSize: AppAssetConfigManager.fontSizeProvider(.kPLFont14))
        self.cancelBtn.titleLabel?.font = UIFont.bbFont(withName: AppAssetConfigManager.fontProvider(.kSemibold), withSize: AppAssetConfigManager.fontSizeProvider(.kPLFont16))
        self.continueBtn.titleLabel?.font = UIFont.bbFont(withName: AppAssetConfigManager.fontProvider(.kSemibold), withSize: AppAssetConfigManager.fontSizeProvider(.kPLFont16))
        
        self.titleLbl.textColor = BBUICoreConfigManager.colorProvider(.kErrorAlertTitleText)
        self.descriptionLbl.textColor = BBUICoreConfigManager.colorProvider(.kErrorAlertDescriptionText)
        self.cancelBtn.setTitleColor(BBUICoreConfigManager.colorProvider(.kErrorAlertNegativeBtnText), for: .normal)
        self.continueBtn.setTitleColor(UIColor.white, for: .normal)
        
        self.cancelBtn.backgroundColor = BBUICoreConfigManager.colorProvider(.kErrorAlertNegativeBtnBG)
        self.cancelBtn.layer.borderWidth = 1.0;
        self.cancelBtn.layer.borderColor = BBUICoreConfigManager.colorProvider(.kButtonBorder).cgColor;
        self.cancelBtn.layer.cornerRadius = 3.0
        self.cancelBtn.layer.masksToBounds = true;
        
        self.continueBtn.backgroundColor = BBUICoreConfigManager.colorProvider(.kErrorAlertPositiveBtnBG)
        self.continueBtn.layer.cornerRadius = 3.0
        self.continueBtn.layer.masksToBounds = true;
        
        self.alertContainer.layer.cornerRadius = 3.0
        self.alertContainer.layer.masksToBounds = true;
    }
    
    func configureDescription(withText text: String) {
        self.descriptionLbl.text = text;
    }

    func configureTitle(withText text: String) {
        self.titleLbl.text = text;
    }
    
    func configureBottomBtns() -> Void {
        
        var tempStr = ""
        if let negativeBtnTitle = self.negativeBtnTitle {
        
            if let negativeBtnWidth = negativeBtnWidth {
                self.cancelBtn.removeConstraint(negativeBtnWidth)
            }
            tempStr.append("    ")
            tempStr.append(negativeBtnTitle)
            tempStr.append("    ")
            self.cancelBtn.setTitle(tempStr, for: .normal)
            self.btnGap.constant = 30.0;
        }
        else {
            
            if nil == self.negativeBtnWidth {
                negativeBtnWidth = cancelBtn.widthAnchor.constraint(equalToConstant: 0.0)
                negativeBtnWidth!.isActive = true
            }
            self.cancelBtn.setTitle("", for: .normal)
            self.btnGap.constant = 0.0;
        }
        
        tempStr = ""
        tempStr.append("    ")
        tempStr.append(self.positiveBtnTitle)
        tempStr.append("    ")
        self.continueBtn.setTitle(tempStr, for: .normal)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setFontsAndColors()
        configureTitle(withText: alertTitle)
        configureDescription(withText: alertDescription)
        configureBottomBtns()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func animateViewsForShow(animated: Bool, withCompletion completon: ((Bool) -> Void)? = nil) -> Void {
//
//        if true == animated {
//
//            self.view.alpha = 0.0;
//            self.alertContainer.alpha = 0.0;
//            UIView.animate(withDuration: 0.3, animations: {
//                self.view.alpha = 1.0;
//                self.alertContainer.alpha = 1.0;
//            }, completion: {(completed) in
//
//                completon?(completed)
//            })
//        }
//        else{
//
//            self.view.alpha = 1.0;
//            self.alertContainer.alpha = 1.0;
//        }
//    }
//
//    func animateViewsForHide(withCompletion completon: ((Bool) -> Void)?, animated: Bool) -> Void {
//
//        if true == animated {
//
//            self.view.alpha = 1.0;
//            self.alertContainer.alpha = 1.0;
//            UIView.animate(withDuration: 0.3, animations: {
//
//                self.view.alpha = 0.0;
//                self.alertContainer.alpha = 0.0;
//            }, completion: {(completed) in
//
//                completon?(completed)
//            })
//        }
//        else{
//
//            self.view.alpha = 0.0;
//            self.alertContainer.alpha = 0.0;
//        }
//    }
    func setPreferredLayoutWidthForLbls() -> Void {
        
        self.descriptionLbl.preferredMaxLayoutWidth = self.descriptionLbl.frame.size.width;
        self.titleLbl.preferredMaxLayoutWidth = self.titleLbl.frame.size.width;
    }
}
