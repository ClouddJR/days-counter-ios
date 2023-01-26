import Foundation

public struct Products {
    
    public static let Premium = "com.clouddroid.DaysCounter.Premium"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [Products.Premium]
    
    public static let store = IAPHelper(productIds: Products.productIdentifiers)
}
