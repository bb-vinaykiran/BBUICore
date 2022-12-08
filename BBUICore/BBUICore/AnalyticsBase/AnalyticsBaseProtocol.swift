//
//  AnalyticsBaseProtocol.swift
//  BBUICore
//
//  Created by Bigbasket on 13/10/21.
//

import UIKit

public protocol BaseSPEventCallback: AnyObject {

    var screenSlug: String { get set }
    var screenType: String { get set }
    var screenTypeID: Int? { get set }
    var screenInPageContext: String? { get set }
    var screenURL: String? { get set }
    var pageTemplate: String { get set }
    var screenInPagePosition: Int? { get set }
    var referrerScreenType: String? { get set }
    var referrerTypeID: Int? { get set }
    var referrerScreenSlug: String? { get set }
    var referrerScreenUrl: String? { get set }
    var referrerInPagePosition: Int? { get set }
    var referrerSectionItemName: String? { get set }
    var referrerSectionItemPosition: Int? { get set }
    var referrerBannerSlideID: Int? { get set }
    // swiftlint:disable discouraged_optional_collection
    var referrerContextDict: [String: Any]? { get set }
    var referrerInPageContext: String? { get set }
    var referrerSearchAdID: Int? { get set }
    
    func resetAllScreenAndReferrerRelatedData()
    func vcViewWillAppear()
    func vcViewDidAppear()
    func vcViewDidDisappear()
    func vcViewWillDisappear()
    func firePageDisplayEvent()
    func willPop()
    func willDismissPage(withParentNavigationController navController: UINavigationController?)
    func willShowLoginPage()
    func handleMenuAction()
    func fireMenueClickEvent(withMenuData data: [String: Any])
    func willPresentOnMenuAction()
    func willTabSwitchOnMenuAction()
    func fireViewAddressSelected()
    func willOpenUniversal(link: URL)
    func willSwitchToBB1Flow()
}
