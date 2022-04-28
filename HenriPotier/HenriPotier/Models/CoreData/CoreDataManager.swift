//
//  CoreDataManager.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 25/4/2022.
//

import CoreData


class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "HenriPotier")
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Loading of store failed : \(error)")
            }
        }
        return persistentContainer
    }()
    
    var moc: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }
    
    //MARK: - Clear
    func clearCartItems(books: [Books]){        
        let context = books.first?.managedObjectContext
        for book in books {
            book.quantity = 0
        }

        try? context?.save()
    }
    
    //MARK: - Add To Cart
    func addToCart(book: Books) -> Bool {
        guard let context = book.managedObjectContext else {
            return false
        }
        
        book.quantity = book.quantity+1
        
        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }
    
    //MARK: - bookMark
    func bookMark(book: Books) {
        guard let context = book.managedObjectContext else {
            return
        }
        book.bookmark = !book.bookmark
     
        do {
            try context.save()
            return
        }catch {
            return
        }
    }
    

    //MARK: - Remove From Cart
    func removeFromCart(book: Books) -> Bool {
        guard let context = book.managedObjectContext else {
            return false
        }

        if book.quantity >= 1 {
            book.quantity = book.quantity-1
        }else{
            book.quantity = 0
        }

        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }
    
    //MARK: - Fetch Books
    func fetchBooks(inCart: Bool = false) -> [Books] {
        let request = NSFetchRequest<Books>(entityName: "Books")
        request.sortDescriptors = [
            NSSortDescriptor(key: "index", ascending: true)
        ]
        
        if inCart == true {
            request.predicate = NSPredicate(format: "quantity > 0")
            request.sortDescriptors = [
                NSSortDescriptor(key: "quantity", ascending: false)
            ]
        }
        
        do {
            let books = try moc.fetch(request)
            return books
        }catch {
            return [Books]()
        }
    }
    
    
    //MARK: - Cart Cout
    func countCartItems() -> Int {
        let request = NSFetchRequest<Books>(entityName: "Books")
        request.predicate = NSPredicate(format: "quantity > 0")
        do {
            let counted = try moc.fetch(request).reduce(0, { $0 + Int(($1).quantity) })
            return counted
        }catch {
            return 0
        }
    }

    //MARK: - Fetch Bookmarks
    func fetchBookMarks() -> [Books] {
        let request = NSFetchRequest<Books>(entityName: "Books")
        request.predicate = NSPredicate(format: "bookmark == true")
        request.sortDescriptors = [
            NSSortDescriptor(key: "index", ascending: true)
        ]
        
        do {
            let books = try moc.fetch(request)
            return books
        }catch {
            return [Books]()
        }
    }
    
}
