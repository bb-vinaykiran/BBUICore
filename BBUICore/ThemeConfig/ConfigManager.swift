//
//  ConfigManager.swift
//  BBCore
//
//  Created by Bigbasket on 24/09/21.
//

import Foundation
import UIKit

public enum ImageNameKey: Int {
    case kPLFilterRadioBtnActive
    case kPLFilterRadioBtnInactive
    case kPDRadioBtnActive
    case kPLFilterSquareRadioBtnActive
    case kPLFilterSquareRadioBtnInactive
    case kPLRadioBtnInactiveGreen
    case kBackBtn
    case kCloseBtn
    case kFilterDropDown
    case kFilterDropUp
    case kFitlerSearchIcon
    case kLoaderCricle
    case kRatingSelectedStar
    case kRatingUnSelectedStar
    case kNavBarShare
    case kNavBarBasket
    case kNavBarSearch
    case kPDVeg
    case kPDNonVeg
    case kPDEgg
    case kPDWeightDropdown
    case kPLVeg
    case kPLNonVeg
    case kPLEgg
    case kComoboDetailArrow
    case kExpressIcon
    case kStandardIcon
    case kPDExpandIcon
    case kPDCollapseIcon
    case kPDCosmeticOOS
    case kPDShadeIcon
    case kPDBBYIcon
    case kPDBasketIcon
    case kPDBasketIncr
    case kPDBasketDecr
    case kPDMNotifyMeIcon
    case kPDMNotifiedIcon
    case kPDSFLAddConfirm
    case kPDSFLSFLIcon
    case kPDSimilarItemIcon
    case kPDBtmActionArrow
    case kPDBtmActionArrowDisabled
    case kPDSimilarItemDisabledIcon
    case kPDCartLoader
    case kPDCartLoaderFMCG
    case kNavBarGrayCloseBig
    case kShadeUnAvailableCross
    case kRnRNoRateImage
    case kRnRInfoIcon
    case kRnRReviewInfoIcon
    case kPDVariableWeightIcon
    case kFilterBBY
    case kCartIncrementActionIcon
    case kCartDecrementActionIcon
    case kExtraOfferBackground
    case kExtraOfferGreenDropDownIcon
    case kNotifyButtonIcon
    case kQuantityDropDownIcon
    case kQuantityCosmeticDropDownIcon
    case kDeliveryIcon
    case kCloseDarkBtn
    case kOfferDark
    case kNotifySpinnerIcon
    case kEntryPointIcon
    case kFilterIcon
    case kFilterIconSelected
    case kPLFilterCategoryTabArrow
    case kgraySearchIcon
    case kgrayBasketIcon
    case kPDQtyIncr
    case kPDQtyDecr
    case kPDGrayBasketIcon
    case kShadeNotAvailable
}


public enum ColorKey: Int {
    case kNavBarColor
    case kTextGreen
    case kLightGreenColor
    case kLightGrayishGreen
    case kShadowColor
    case kTabTitleTextColor
    case kSeperatorColor
    case kSecondaryTextColor
    case kRatingStarColorDefault
    case kRatingStarColorbelow2
    case kRatingStarColorbelow3
    case kPDBageTextColor
    case kOOSTextColor
    case kPDBageBGColor
    case kDiscountBGColor
    case kSPColor
    case kMRPStrikeColor
    case kPDMoreImageTextColor
    case kPDThumbnailBorderSelected
    case kPDThumbnailBorderUnSelected
    case kPDPackSizeSelectionBG
    case kPDPackSizeCartZeroBG
    case kPDPackSizeCartNonZeroBG
    case kPDPackSizeSelectedRadioBtnBorder
    case kPDPackSizeUnSelectedRadioBtnBorder
    case kPDPackSizeCartZeroBGBorder
    case kPDPackSizeCartNonZeroBGBorder
    case kPDPackSizeSelectedAvailableBGBorder
    case kPDPackSizeSelectedUnAvailableBGBorder
    case kPDPackSizeUnSelectedBGBorder
    case kETATextColor
    case kPDWebViewTitleTextColor
    case kPDBandBG
    case kPDBandBorder
    case kPDCartActionColor
    case kPDActionDisabledTextColor
    case kPDActionDisabledBGColor
    case kPDActionDisabledBorderColor
    case kPDBtmAddToCartBorder
    case kToastBG
    case kGrayNavBar
    case kShadeSelectedBG
    case kOOSBG
    case kOOSGrayBGTextColor
    case kPrimaryTextColor
    case kBorderGrayColor1
    case kBorderGrayColor2
    case kSecondaryTextColor3
    case kGray72Color
    case kLightBlack
    case kAnnotationTextColor
    case kQuantityDarkColor
    case kCartActionBGColor
    case kCartActionBorderColor
    case kCartActionAddColor
    case kCartActionCountLabelTextColor
    case kExtraOfferViewTextColor
    case kNotifyMeButtonColor
    case kOfferBGColor
    case kNotifiedBtnBGColor
    case kQuantityViewBorderColor
    case kSingleQuantityBackgroundColor
    case kProductCellShimmerPrimaryColor
    case kProductCellShimmerSecondaryColor
    case kGrayTextColor
    case kProductCellHighlightColor
    case kbasePriceUnitColor
    case kGrayColor
    case kBlackColor
    case kWhiteColor
    case kClearColor
    case kProductShimmerFirstColor
    case kdarkGrayColor
    case kEasyTipBGColor
    case kProductCellBgGreenColor
    case kPLCategoryTabBgColor1
    case kPLCategoryTabBgColor2
    case kPLCategoryShadowColor
    case kPLInfoButtonShadowColor
    case kPLProductInfoTabColor
    case kPLProductInfoTitleLabelColor
    case kPLProductInfoCategoryBorderColor
    case kPLCategoryTabCellCat1BackgroundColor
    case kPLCategoryTabCellBackgroundColor
    case kPLCategoryTabCellLabelTextSelectedColor
    case kPLCategoryTabCellLabelTextSelectedPSColor
    case kPLCategoryTabCellLabelTextUnSelectedColor
    case kPLProductInfoSecondaryTextColor
    case kPLProductInfoCategoryTabTextColor
    case kPLProductInfoCategoryTabTextHighlightedColor
    case kPLProductInfoBarBackgroundColor
    case kBlueColor
    case klightBlackolor
    case kCosmeticPopupOOSTextAndBorderColor
    case kCosmeticPopupShadeUnselectedBorderColor
    case kCosmeticPopupShadeUnselectedBGColor
    case kCosmeticPopupShadeSelectedBorderColor
    case kCosmeticPopupShadeSelectedBGColor
    case klightGray2
    case kDarkBlack
    case kRedColor
    case klightGreen1
    case kPLFilterShimmerFirstColor
    case kPLFilterShimmerSecondColor
    case kCategoryShimmerFirstColor
    case kCategoryShimmerSecondColor
}

public enum FontKey: Int {
    case kRegular
    case kSemibold
    case kBold
    case kMedium
}

public enum FontSizeKey: Int {
    case kPLFont12
    case kPLFont10
    case kPLFont8
    case kPLFont11
    case kPLFont13
    case kPLFont14
    case kPLFont15
    case kPLFont16
    case kPLFont17
    case kPLFont18
    case kPLFont20
    case kPLFont30
}

@objcMembers public class AppAssetConfigManager: NSObject {
   
    public static var colorProvider: ((ColorKey) -> UIColor)!
    public static var imageProvider: ((ImageNameKey) -> String)!
    public static var fontProvider: ((FontKey) -> String)!
    public static var fontSizeProvider: ((FontSizeKey) -> CGFloat)!
}
