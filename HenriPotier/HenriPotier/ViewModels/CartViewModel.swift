//
//  CartViewModel.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 26/4/2022.
//

import Foundation
import UserNotifications

protocol CartDelegate: AnyObject {
    func updateCartOffer(offer: [String: Int]?)
    func presentError(type messageCases: SearchMessageCases)
}

extension CartDelegate {
    func presentError(type: SearchMessageCases = .Clear) {}
}


class CartViewModel {
    
    weak var delegate: CartDelegate?
    
    var title = "Détails de la commande"
    var cartItems: [Books]
    
    var commmercialOffers: CommercialOffers?

    let apiManager: APIManagerProtocol?
    let coreDataManager: CoreDataManager?

    init(apiManager: APIManagerProtocol = APIManager(), coreDataManager: CoreDataManager = CoreDataManager()){
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
        
        cartItems = coreDataManager.fetchBooks(inCart: true)
    }
    
    //MARK: - Clear Cart
    
    func clearCartItems(books: [Books]){
        coreDataManager?.clearCartItems(books: cartItems)
    }
    
    //MARK: - Cell Config
    func configureCell(indexPath: IndexPath) -> Books {
        return cartItems[indexPath.item]
    }
    
    //MARK: - Fetch Offers init
    func fetchOffers() {
        ///1. Fetch cart for items
        ///2. calculate Subtotal in price
        ///3. pass to `calculateOffer`
         
        let subTotal = cartItems.reduce(0, { $0 + Int($1.quantity * $1.price) })
        let isbns = cartItems.filter({ $0.quantity > 0 && $0.isbn != nil }).map({ $0.isbn! })
                
        guard !isbns.isEmpty else {
            delegate?.presentError(type: .Custom("Can't find ISBNS for Books"))
            return
        }
        
        self.apiManager?.fetchRemoteOffers(url: .Offers(isbns), completion: { [weak self] (result: Result<CommercialOffers, NetworkError>) in
            switch result {
            case .success(let offers):
                self?.commmercialOffers = offers
                let finalOffer = self?.calculateOffer(subTotal: subTotal, offers: offers)
                self?.delegate?.updateCartOffer(offer: finalOffer)
            case .failure(_):break
            }
        })
    }
    
    //MARK: - Remove from Cart
    
    func removeItemsFromCart(indexPath: IndexPath){
        
        let index = indexPath.row
        let bookAtIndex = cartItems[index]
        
        if let _ = coreDataManager?.removeFromCart(book: bookAtIndex) {
            if let offers = self.commmercialOffers, let cartItems = coreDataManager?.fetchBooks(inCart: true) {
                self.cartItems = cartItems
                let subTotal = self.cartItems.reduce(0, { $0 + Int($1.quantity * $1.price) })
                let finalOffer = self.calculateOffer(subTotal: subTotal, offers: offers)
                
                self.delegate?.updateCartOffer(offer: finalOffer)
            }
        }
    }
    
    //MARK: - Calculate Best Offers
    private func calculateOffer(subTotal: Int, offers commercialOffers: CommercialOffers) -> [String: Int]? {
        guard subTotal > 0 else {
            return nil
        }
        
        var offers: [Int] = []
        var finalOffer: [String: Int] = ["subtotal": subTotal, "discount": 0, "total": subTotal]
        
        if let sliceOffer = commercialOffers.offers.first(where: { $0.sliceValue != nil }), let sliceValue = sliceOffer.sliceValue {
            let counted = subTotal / sliceValue //  Number of round (Tranches)
            let deduce = counted * sliceOffer.value
            offers.append(deduce)
        }
        
        if let percentage = commercialOffers.offers.first(where: { $0.type == "percentage"})?.value {
            let deduce = (subTotal * percentage) / 100
            offers.append(deduce)
        }
        
        if let minus = commercialOffers.offers.first(where: { $0.type == "minus"})?.value {
            offers.append(minus)
        }
        
        if let discount = offers.max(){
            finalOffer["discount"] = discount
            finalOffer["total"] = subTotal - discount
        }
                
        return finalOffer
    }
    
    
    
    //MARK: - Notifcations
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .badge, .list, .sound])
    }
    
    func scheduleLocalNotification() {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "🔖 La bibliothèque d'Henri Potier"
        notificationContent.body = "Merci d'avoir passé la commande"

        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.5, repeats: false)

        let notificationRequest = UNNotificationRequest(identifier: "HenriPotier_notification", content: notificationContent, trigger: notificationTrigger)

        UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: nil)
        
    }
    
}



