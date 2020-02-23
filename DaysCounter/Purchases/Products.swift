//
//  Products.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 23/02/2020.
//  Copyright © 2020 CloudDroid. All rights reserved.
//

import Foundation

public struct Products {
    
    public static let Premium = "com.clouddroid.DaysCounter.Premium"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [Products.Premium]
    
    public static let store = IAPHelper(productIds: Products.productIdentifiers)
}
