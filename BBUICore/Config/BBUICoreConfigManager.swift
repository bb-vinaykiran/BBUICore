//
//  BBUICoreConfigManager.swift
//  BBUICore
//
//  Created by Bigbasket on 09/11/21.
//

import Foundation
import UIKit

public struct BBUICore {

    public enum ColorKey: Int {
        case kImageViewerSelectedBorder
        case kImageViewerUnSelectedBorder
        case kErrorAlertPositiveBtnBG
        case kErrorAlertPositiveBtnText
        case kErrorAlertNegativeBtnBG
        case kErrorAlertNegativeBtnText
        case kErrorAlertTitleText
        case kErrorAlertDescriptionText
        case kButtonBorder
    }
    
    public enum ImageNameKey {
        case kPlaceholder
        case kGrayCloseBtn
    }
}

public class BBUICoreConfigManager {
    
    public static var colorProvider: ((BBUICore.ColorKey) -> UIColor)!
    public static var imageProvider: ((BBUICore.ImageNameKey) -> String)!
}
