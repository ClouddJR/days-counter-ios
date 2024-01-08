import Foundation
import StoreKit

final class Store {
    static let shared = Store()
    
    private var updateListenerTask: Task<Void, Error>? = nil
    
    private init() {}
    
    func initialize() {
        updateListenerTask = listenForTransactions()
        
        Task {
            await updatePremiumStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    await self.updatePremiumStatus()
                    
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    @MainActor
    private func updatePremiumStatus() async {
        Defaults.setPremiumUser(false)
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                switch transaction.productType {
                case .nonConsumable, .autoRenewable:
                    // It's not necessary to check the product id here.
                    // All purchases unlock the same premium features.
                    Defaults.setPremiumUser(true)
                default:
                    break
                }
            } catch {
                print("Transaction failed verification")
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    private enum StoreError: Error {
        case failedVerification
    }
}
