//
//  ImageViewerItemVM.swift
//  BBUICore
//
//  Created by Bigbasket on 09/11/21.
//

import Foundation

enum ImageViewerItemVMEvent: String {

    case changeSelectionState
}

public class ImageViewerItemVM {
    
    private var thumbnailUrl: String?
    private var imageURL: String?
    public var selected = false {
        
        didSet {
            viewModelEventCallback?(self, .changeSelectionState)
        }
    }
    var viewModelEventCallback: ((_ imageViewerVM: ImageViewerItemVM, _ event: ImageViewerItemVMEvent) ->())? = nil
    
    public init(withThumbnailURL thumbUrl: String?, imageURL imgUrl: String?) {
        thumbnailUrl = thumbUrl
        imageURL = imgUrl
    }
    
    func getThumbURL() -> String? {
        thumbnailUrl
    }
    
    func getImageURL() -> String? {
        imageURL
    }
}
