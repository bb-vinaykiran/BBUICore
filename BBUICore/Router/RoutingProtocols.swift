//
//  RoutingProtocols.swift
//  BBCore
//
//  Created by Bigbasket on 14/09/21.
//

import UIKit
import Foundation

public typealias UniversalRouter = UniversallinkRouterCallback & DestinationInfoRouterCallback & DeeplinkRouterCallback &  OrderScreenRouterCallback & RnRScreenRouterCallback & ProductListRouterCallback & MemberPageRouterCallback & AddressRouterCallback & WebPageRouterCallback & DynamicPageRouterCallback & NotificationPageRouterCallback & SelfServicePageRouterCallback & GiftCardRouterCallback & PaymentScreenRouterCallback & CheckoutScreenRouterCallback & LanguageScreenRouterCallback & LoginScreenRouterCallback & TabBarVisibilityCallback & NavBarUtitlityCallback & FlowSwitchRouterCallback


public protocol UniversallinkRouterCallback: AnyObject {
   
    func requiresLogin(forUniversalLink url: URL) -> Bool
    func canAppOpen(universalLink link: URL) -> Bool
    func isUniversal(link: URL) -> Bool
    func openScreen(forUniversallink universallink: URL)
}

public protocol LoginScreenRouterCallback: AnyObject {
    func forceLogoutAndShowLogin(withMsg msg: String?)
    func showLoginVc(withDeeplink deeplink: URL?)
}

public protocol DestinationInfoRouterCallback: AnyObject {
    
    func willPresentOnMenuAction(destinationType type: String) -> Bool
    func willTabSwitchOnMenuAction(destinationType type: String, withSlug slug: String) -> Bool
    func routeScreen(withDestinationinfo info: [String: Any],
                     withPayload payload: [String: Any],
                     animated: Bool);
}

public protocol FlowSwitchRouterCallback: AnyObject {

    func switchToBB1Flow()
}

public protocol DeeplinkRouterCallback: AnyObject {
   
    func isDeep(link: URL) -> Bool
    func canHandleDeeplink(_ url: URL) -> Bool
    func requireLoginTo(forDeeplink deeplink: URL) -> Bool
    func openScreen(forDeeplink deeplink: URL,
                    animated: Bool)
}

public protocol OrderScreenRouterCallback: AnyObject {
    func showOrderAssistance(withExpandOrderId orderID: String,
                            shouldClearBackground clearBG: Bool)
    
    func showOrderDetail(forOrderId orderId: String,
                         forSSFlow ssFlow: Bool,
                         isDeeplinkFlow deepLinkFlow: Bool,
                         hideTabBar: Bool)
    
    func showBasket(animated: Bool)
    
    func showOrderListing()
}


public protocol RnRScreenRouterCallback: AnyObject {
    
    func showRatingForm(withSolicitationId solId: String, isForEdit edit: Bool, entryPointContext context: String?)
    
    func showRatingReviewVC()    
}

public protocol ProductListRouterCallback: AnyObject {
    
    func showShopFromOrder(withOdrderNumber orderNum: String,
                           animated: Bool)
    
    func showSB(animated: Bool,
                withSlug slug: String,
                withType type: String)
    
    func showProductListPage(withSlug slug: String,
                             withType type: String?,
                             withFilter filterData: [[String: Any]],
                             withSearchScope searchScope: String?,
                             withAnalyticsSearchQuery searchQuery: String?,
                             animted: Bool)
    
    func showPD(forProductId productId: String,
                animated: Bool)
    func showSearch(animated: Bool)
    func showShareScreen(withData data: [Any])
}

public protocol MemberPageRouterCallback: AnyObject  {
    func showUpdateProfile(animated: Bool)
    func showWalletPage(animated: Bool)
    func showMyAccount(animated: Bool)
}

public protocol AddressRouterCallback: AnyObject {
    
    func showFormToAddAddress()
    func showLocationPickerViewController()
    func showAddressListing(animated: Bool)
}

public protocol WebPageRouterCallback: AnyObject {
    
    func showWebPage(withURLString URLStr: String,
                     animated: Bool,
                     withReferrer referrer: String,
                     withTitle title: String?)
}

public protocol DynamicPageRouterCallback: AnyObject {
    func showDynamicPage(withScreenName screenName: String,
                         withTitle title: String?,
                         animated: Bool)
    func showHome(animated: Bool)
}

public protocol NotificationPageRouterCallback: AnyObject {
    
    func showNotification(animated: Bool)
}

public protocol SelfServicePageRouterCallback: AnyObject {
    
    func showSelfServicePage(withURLString URLStr: String,
                             animated: Bool)
    func showCallCCPage()
    
    func showEmail()
    
    func showChangeSlotPage(withOrder orderId: String,
                            withOrderNumber orderNum: String?,
                            withL2Id l2Id: String?,
                            resetContext: Bool,
                            hideTabBar: Bool,
                            withLaunchSourceInfo launchSourceInfo: [String: String])
    
    func showCancelOrderPage(orderId: String,
                             withOrderNumber orderNum: String?,
                             forSSFlow ssFlow: Bool,
                             withL2Id l2Id: String?)
}

public protocol GiftCardRouterCallback: AnyObject {
    
    func showGiftCard()
    
    func showMyGiftCard()
}

public protocol PaymentScreenRouterCallback: AnyObject {
    
    func showFundWalletPaymentPage(animated: Bool)
}

public protocol CheckoutScreenRouterCallback: AnyObject {
    
    func showVouchers(forVoucherListing listing: Bool,
                      showLinkedOrderPopup: Bool,
                      animated: Bool);
}

public protocol LanguageScreenRouterCallback: AnyObject {
    
    func showlaungugaeSelection(animated: Bool)
}

public protocol TabBarVisibilityCallback: AnyObject {
    
    func showTabBar()
    func hideTabBar()
    func isTabbarHidden() -> Bool
}

public protocol NavBarUtitlityCallback: AnyObject {
    
    func showCustomStatusBar()
    func showStatusBar()
    func hideCustomStatusBar()
    func hideStatusBar()
    func goBack(animated: Bool)
    func dismiss(controller viewCont: UIViewController, animated: Bool)
    func showMenu()
}



