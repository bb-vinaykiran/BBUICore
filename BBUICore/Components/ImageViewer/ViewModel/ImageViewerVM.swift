//
//  ImageViewerVM.swift
//  BBUICore
//
//  Created by Bigbasket on 09/11/21.
//

import Foundation

public class ImageViewerVM {
    
    private var imageItemVMs = [ImageViewerItemVM]()
    
    public init(withImageViewerItemVMs imageViewerItemVMs: [ImageViewerItemVM]) {
        
        imageItemVMs = imageViewerItemVMs
    }
    
    func getImageItemVM(atIndex index: Int) -> ImageViewerItemVM {
        
        return imageItemVMs[index]
    }
    
    func getSelectedItemVM() -> ImageViewerItemVM? {
        return imageItemVMs.first { (itemVM) -> Bool in
            return itemVM.selected
        }
        
    }
    
    func getSelectedItemVMIndex() -> Int? {
        return imageItemVMs.firstIndex { (imageViewerItemVM) -> Bool in
            if imageViewerItemVM.selected {
                return true
            }
            return false
        }
        
    }
    
    func imageCount() -> Int {
        
        return imageItemVMs.count
    }
    
    
}
