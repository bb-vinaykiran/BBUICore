//
//  BBUICoreUtilities.swift
//  BBUICore
//
//  Created by BB on 29/06/22.
//

import Foundation
import UIKit
import EasyTipView


public class BBUICoreUtilities: NSObject {
    
    
    public func ifRequiredAppendBaseURL(_ baseImageURL: String?, toURL urlString: String?) -> String? {
        if let url = urlString{
            if url.hasPrefix("http") {
                return url
            }

            if let baseImageURL = baseImageURL {
                return "\(baseImageURL)\(url )"
            } else {
                return url
            }
        }
        return nil
    }
    
    private func getImageQueryForDevice() -> String {
        if (isDisplayHdRetina()) {
            return "l"
        } else if (isDisplayRetina()) {
            return "m"
        } else {
            return "s"
        }
    }
    
    private func isDisplayHdRetina() -> Bool{
        return (UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) && UIScreen.main.scale > 2.0)
    }
    
    private func isDisplayRetina() -> Bool{
        return (UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) && UIScreen.main.scale > 1.0)
    }
}



