//
//  Font.swift
//  Graffity
//
//  Created by Karen Khachatryan on 25.11.24.
//

import UIKit

extension UIFont {
    static func regular(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-Regular", size: CGFloat(size))
    }
    
    static func medium(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-Medium", size: CGFloat(size))
    }
    
    static func semibold(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-SemiBold", size: CGFloat(size))
    }
    
    static func bold(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-Bold", size: CGFloat(size))
    }
    
    static func regularSFPro(size: CFloat) -> UIFont? {
        return UIFont(name: "SFProText-Regular", size: CGFloat(size))
    }
    
    static func semiboldSFPro(size: CFloat) -> UIFont? {
        return UIFont(name: "SFProText-Semibold", size: CGFloat(size))
    }
    
    static func montserratMedium(size: CFloat) -> UIFont? {
        return UIFont(name: "Montserrat-Medium", size: CGFloat(size))
    }
    
    static func montserratSemibold(size: CFloat) -> UIFont? {
        return UIFont(name: "Montserrat-SemiBold", size: CGFloat(size))
    }
}
