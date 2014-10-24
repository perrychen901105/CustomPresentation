//
//  SelectionObject.swift
//  CustomPresentation
//
//  Created by mac on 14-10-24.
//  Copyright (c) 2014年 Fresh App Factory. All rights reserved.
//

import UIKit

class SelectionObject: NSObject {
   
    var originalCellPosition: CGRect
    var country: Country
    var selectedCellIndexPath: NSIndexPath
    
    init(country:Country, selectedCellIndexPath: NSIndexPath, originalCellPosition: CGRect) {
        self.country = country
        self.selectedCellIndexPath = selectedCellIndexPath
        self.originalCellPosition = originalCellPosition
    }
    
}
