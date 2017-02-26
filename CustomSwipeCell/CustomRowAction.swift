//
//  CustomRowAction.swift
//  CustomSwipeCell
//
//  Created by Atuooo on 25/02/2017.
//  Copyright © 2017 xyz. All rights reserved.
//

import UIKit

private let defaultTextPadding: CGFloat = 15

class CustomRowAction: UITableViewRowAction {
    
    typealias TextInfo = (text: String, textColor: UIColor, font: UIFont)
    
    init(cellHeight: CGFloat, bgColor: UIColor, with titleInfo: TextInfo) {
        super.init()

        // calculate actual size & set title with spaces

        let titleAttributes = [
            NSFontAttributeName: titleInfo.font,
            NSForegroundColorAttributeName: titleInfo.textColor
        ]
        
        let defaultAttributes = [ NSFontAttributeName: UIFont.systemFont(ofSize: 18)]

        let textSize = (titleInfo.text as NSString).size(attributes: titleAttributes)
        let oneSpaceWidth = (" " as NSString).size(attributes: defaultAttributes).width
        let numOfSpace = Int(ceil(textSize.width / oneSpaceWidth))
        
        let placeHolder = String(repeating: " ", count: numOfSpace)
        
        title = placeHolder

        // draw text

        let titleWidth = (placeHolder as NSString).size(attributes: defaultAttributes).width
        
        let rowActionWidth = titleWidth + defaultTextPadding * 2
        let rowActionSize = CGSize(width: rowActionWidth, height: cellHeight)
        
        let textRect = CGRect(x: (rowActionWidth - textSize.width) / 2, y: (cellHeight - textSize.height) / 2, width: textSize.width, height: textSize.height)
        
        UIGraphicsBeginImageContextWithOptions(rowActionSize, false, UIScreen.main.nativeScale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(bgColor.cgColor)
        context.fill(CGRect(origin: .zero, size: rowActionSize))
        
        titleInfo.text.draw(in: textRect, withAttributes: titleAttributes)
        let titleImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        backgroundColor = UIColor(patternImage: titleImage)
    }
    
    init(size: CGSize, image: UIImage, bgColor: UIColor) {
        super.init()

        // calculate actual size & set title with spaces
        
        let defaultAttributes = [ NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
        let oneSpaceWidth = NSString(string: " ").size(attributes: defaultAttributes).width
        let titleWidth = size.width - defaultTextPadding * 2
        let numOfSpace = Int(ceil(titleWidth / oneSpaceWidth))
        
        let placeHolder = String(repeating: " ", count: numOfSpace)
        let newWidth = (placeHolder as NSString).size(attributes: defaultAttributes).width + defaultTextPadding * 2
        let newSize = CGSize(width: newWidth, height: size.height)
        
        title = placeHolder

        // set background with pattern image
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.nativeScale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(bgColor.cgColor)
        context.fill(CGRect(origin: .zero, size: newSize))
        
        let originX = (newWidth - image.size.width) / 2
        let originY = (size.height - image.size.height) / 2
        image.draw(in: CGRect(x: originX, y: originY, width: image.size.width, height: image.size.height))
        let patternImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        backgroundColor = UIColor(patternImage: patternImage)
    }
    
    init(cellHeight: CGFloat, bgColor: UIColor, titleInfo: TextInfo, icon: UIImage) {
        
        super.init()
        
        let titleAttributes = [
            NSFontAttributeName: titleInfo.font,
            NSForegroundColorAttributeName: titleInfo.textColor
        ]
        
        let defaultAttributes = [ NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
        
        let textSize = (titleInfo.text as NSString).size(attributes: titleAttributes)
        let oneSpaceWidth = (" " as NSString).size(attributes: defaultAttributes).width
        let numOfSpace = Int(ceil(textSize.width / oneSpaceWidth))
        
        let placeHolder = String(repeating: " ", count: numOfSpace)
        
        title = placeHolder
        
        let titleWidth = (placeHolder as NSString).size(attributes: defaultAttributes).width
        
        let rowActionWidth = titleWidth + defaultTextPadding * 2
        let rowActionSize = CGSize(width: rowActionWidth, height: cellHeight)
        
        let iconOriginX = (cellHeight - icon.size.height - textSize.height - 4) / 2
        
        let iconRect = CGRect(x: (rowActionWidth - icon.size.width) / 2, y: iconOriginX, width: icon.size.width, height: icon.size.height)
        let textRect = CGRect(x: (rowActionWidth - textSize.width) / 2, y: iconRect.maxY + 4, width: textSize.width, height: textSize.height)
        
        UIGraphicsBeginImageContextWithOptions(rowActionSize, false, UIScreen.main.nativeScale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(bgColor.cgColor)
        context.fill(CGRect(origin: .zero, size: rowActionSize))
        
        icon.draw(in: iconRect)
        titleInfo.text.draw(in: textRect, withAttributes: titleAttributes)
        
        let patternImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        backgroundColor = UIColor(patternImage: patternImage)
    }
}
