//
//  BookmarksViewModel.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 28/4/2022.
//

import Foundation

class BookmarksViewModel {
        
    var bookmarks: [Books] = []
    
    let apiManager: APIManagerProtocol
    let coreDataManager: CoreDataManager

    let title = "Signets"
    
    init(apiManager: APIManagerProtocol = APIManager(), coreDataManager: CoreDataManager = CoreDataManager()){
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
        
    }
    
    //MARK: - Fetch Bookmarks
    func fetchBookMarks(){
        bookmarks = coreDataManager.fetchBookMarks()
    }
    
    //MARK: - Cell Config
    func configureCell(indexPath: IndexPath) -> Books {
        return bookmarks[indexPath.item]
    }
    
    //MARK: - Add bookmarked item to Cart
    func addToCart(book: Books){
        _ = coreDataManager.addToCart(book: book)
    }
}
