//
//  FrameworkBaseVC.swift
//  BBUICore
//
//  Created by Bigbasket on 13/10/21.
//

import UIKit

public protocol BBNavigationShadowProtocol {
    
    func showNavigationBarShadow(inNavigationController navVC: UINavigationController)

    func hideNavigationBarShadow(inNavigationController navVC: UINavigationController)
}

public extension BBNavigationShadowProtocol {
    
    func showNavigationBarShadow(inNavigationController navVC: UINavigationController) {
       
        navVC.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navVC.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        navVC.navigationBar.layer.shadowRadius = 4.0
        navVC.navigationBar.layer.shadowOpacity = 0.4
    }
    
    func hideNavigationBarShadow(inNavigationController navVC: UINavigationController) {
        
        navVC.navigationBar.layer.shadowColor = UIColor.clear.cgColor;
        navVC.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        navVC.navigationBar.layer.shadowRadius = 0.0;
        navVC.navigationBar.layer.shadowOpacity = 0.0;
    }
}

open class FrameworkBaseVC: UIViewController {

    var vcSPHandler: BaseSPEventCallback? = nil
    var router: UniversalRouter? = nil
    
    public init(withNibName nibName: String?,
                nibBundle bundle: Bundle?,
                withSnowplowhandler spHandler: BaseSPEventCallback?,
                withRouter router: UniversalRouter?) {
        
        vcSPHandler = spHandler
        self.router = router
        super.init(nibName: nibName, bundle: bundle)
    }
    public init(withNibName nibName: String?,
                nibBundle bundle: Bundle?, withRouter router: UniversalRouter?) {
        
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
 
    
    open func baseRouter() -> UniversalRouter? {
        
        return router;
    }
    
    open func baseSPHandler() -> BaseSPEventCallback? {
        
        return vcSPHandler;
    }
    
    @objc open func backTapped(_ tapGes: UIButton) -> Void {
        
        baseSPHandler()?.willPop()
        baseRouter()?.goBack(animated: true)
    }
    
    @objc open func dismissPage(_ tapGes: UIButton) -> Void {
        
        baseSPHandler()?.willDismissPage(withParentNavigationController: nil)
        if let navVC = self.navigationController {
            baseRouter()?.dismiss(controller: navVC, animated: true)
        }
        else {
            baseRouter()?.dismiss(controller: self, animated: true)
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        baseSPHandler()?.vcViewDidAppear()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baseSPHandler()?.vcViewWillAppear()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        baseSPHandler()?.vcViewWillDisappear()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        baseSPHandler()?.vcViewDidDisappear()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    public func handleURL(witURL url: URL) {
        
        if let router = baseRouter() {
            if router.isDeep(link: url) {
                if router.canHandleDeeplink(url) {
                    if true == router.requireLoginTo(forDeeplink: url), false == isLoggedIn() {
                        router.showLoginVc(withDeeplink: url)
                    }
                    else {
                        router.openScreen(forDeeplink: url, animated: false)
                    }
                }
            }
            else if router.isUniversal(link: url) {
                if router.canAppOpen(universalLink: url) {
                    baseSPHandler()?.willOpenUniversal(link: url)
                    if router.requiresLogin(forUniversalLink: url), false == isLoggedIn() {
                        router.showLoginVc(withDeeplink: url)
                    }
                    else {
                        router.openScreen(forUniversallink: url)
                    }
                }
            }
        }
    }
    
    public func handleMenuAction(withData data: [String: Any]) {
        
        guard let dest = data["destination"] as? [String: Any] else { return }
        guard let destType = dest["dest_type"] as? String, !destType.isEmpty  else { return }
        var slug = ""
        if let tempSlug = dest["dest_slug"] as? String {
            slug = tempSlug
        }
        if let spHandler = baseSPHandler() {
            spHandler.handleMenuAction()
            if let staticClick = data["static_click"] as? Bool, staticClick == true {
                
            }
            else {
                spHandler.fireMenueClickEvent(withMenuData: data)
            }
            if let baseRouter = baseRouter() {
                if baseRouter.willPresentOnMenuAction(destinationType: destType) {
                    spHandler.willPresentOnMenuAction()
                }
                else if baseRouter.willTabSwitchOnMenuAction(destinationType: destType, withSlug: slug) {
                    spHandler.willTabSwitchOnMenuAction()
                }
            }
        }
        
        if destType == "address_list" || destType == "change_address" {
            if isLoggedIn() {
                
                baseSPHandler()?.fireViewAddressSelected()
            }
        }
        else if destType == "deep_link" {
            
            if !slug.isEmpty {
                if let url = URL.init(string: slug) {
                    handleURL(witURL: url)
                }
            }
        }
        baseRouter()?.routeScreen(withDestinationinfo: dest, withPayload: [:], animated: false)
    }
    
    open func isLoggedIn() -> Bool {
        return false
    }
    
    public func handleError(statusCode: Int?, errorCode errCode: Int?, withMessage errMsg: String?, withInternalErrorCode internalCode: Int?, inViewController viewController: UIViewController) {
        
        if internalCode == 110 {
            self.baseRouter()?.forceLogoutAndShowLogin(withMsg: errMsg)
        }
        else if statusCode == 401 {
            self.baseRouter()?.forceLogoutAndShowLogin(withMsg: nil)
        }
        else if statusCode == 408 {
            let errorVC = ErrorAlertVC.init(withTitle: "We'll be back!", withDescription: "We are busy updating bigbasket experience for you. We'll be back soon!", positiveButtonText: "OK", negativeButtonText: nil) // ABHI_LOC_MO_LOC
            errorVC.show(inVC: viewController)
        }
        else if statusCode == 400 {
            
            let msg = (errMsg != nil) ? errMsg!: "Something went wrong. Please try after some time." // ABHI_LOC_MO_LOC
            let errorVC = ErrorAlertVC.init(withTitle: "Error", withDescription: msg, positiveButtonText: "OK", negativeButtonText: nil)// ABHI_LOC_MO_LOC
            errorVC.show(inVC: viewController)
        }
        else if URLResponse.isServerMaintainance(errorCode: statusCode) {
            let msg = "We are busy updating bigbasket experience for you. We'll be back soon!"// ABHI_LOC_MO_LOC
            let errorVC = ErrorAlertVC.init(withTitle: "Error", withDescription: msg, positiveButtonText: "OK", negativeButtonText: nil)// ABHI_LOC_MO_LOC
            errorVC.show(inVC: viewController)
        }
        else if URL.isNoNetwork(errorCode: errCode) {
            
            let msg = (errMsg != nil) ? errMsg!: "Something went wrong, please try again."// ABHI_LOC_MO_LOC
            let errorVC = ErrorAlertVC.init(withTitle: "No Internet", withDescription: msg, positiveButtonText: "OK", negativeButtonText: nil)// ABHI_LOC_MO_LOC
            errorVC.show(inVC: viewController)
        }
        else if errCode == NSURLErrorBadServerResponse {
            
            let msg = (errMsg != nil) ? errMsg!: "Something went wrong, please try again."// ABHI_LOC_MO_LOC
            let errorVC = ErrorAlertVC.init(withTitle: "Error", withDescription: msg, positiveButtonText: "OK", negativeButtonText: nil)// ABHI_LOC_MO_LOC
            errorVC.show(inVC: viewController)
        }
        else {
            let msg = (errMsg != nil) ? errMsg!: "Something went wrong, please try again."// ABHI_LOC_MO_LOC
            let errorVC = ErrorAlertVC.init(withTitle: "Oops!", withDescription: msg, positiveButtonText: "OK", negativeButtonText: nil)// ABHI_LOC_MO_LOC
            errorVC.show(inVC: viewController)
        }

    }
}
