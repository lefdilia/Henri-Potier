//
//  LibraryViewModel.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 23/4/2022.
//

import Foundation

protocol PresentBooksDelegate: AnyObject {
    func reloadData()
    func presentError(type messageCases: SearchMessageCases)
    func updateView(book: Books, index: Int)
    func updateCart(quantity: Int)
}

extension PresentBooksDelegate {
    func presentError(messageCases: SearchMessageCases = .Clear) {}
}

enum SearchMessageCases: Equatable {
    case EmptyResult
    case Clear
    case Custom(String)
    
    var description: String {
        switch self {
        case .EmptyResult:
            return "\nAucun résultat pour la recherche\n"
        case .Clear:
            return " "
        case .Custom(let string):
            return "\n\(string)\n"
        }
    }
}

class LibraryViewModel {
    
    weak var delegate: PresentBooksDelegate?
    
    var books: [Books] = []
    var tempData: [Books] = []
    
    let apiManager: APIManagerProtocol
    let coreDataManager: CoreDataManager

    let title = "La bibliothèque"
    
    init(apiManager: APIManagerProtocol = APIManager(), coreDataManager: CoreDataManager = CoreDataManager()){
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
    }
    
    func addToCart(book: Books){
        if coreDataManager.addToCart(book: book) == true {
           let quantity = coreDataManager.countCartItems()
            delegate?.updateCart(quantity: quantity)
        }
    }
    
    func countCart(){
       let quantity = coreDataManager.countCartItems()
        delegate?.updateCart(quantity: quantity)
       
    }
    
    //MARK: - Page Control
    var numberOfPages: Int = 0
    
    //MARK: - Cell Config
    func setBookmark(book: Books){
        coreDataManager.bookMark(book: book)
    }
    
    //MARK: - Cell Config
    func configureCell(indexPath: IndexPath) -> Books {
        return !tempData.isEmpty ? tempData[indexPath.item] : books[indexPath.item]
    }
    
    func numberOfItemsInSection() -> Int{
        if !tempData.isEmpty {
            return tempData.count
        }
        return books.count
    }
    
    //MARK: - Logic
    var tracedErrorMessage: String = ""
    
    func fetchBooks(){
        self.apiManager.fetchRemoteStore(url: .Books, completion: { [weak self] (result: Result<[Books], NetworkError>) in
            switch result {
            case .success(let books):
                self?.books = books
                self?.numberOfPages = books.count
                let quantity = books.reduce(0, { $0 + Int($1.quantity) })
                self?.delegate?.updateCart(quantity: quantity)
                self?.delegate?.reloadData()
            case .failure(let error):
                self?.tracedErrorMessage = error.localizedDescription
                self?.delegate?.presentError(type: .Custom(error.localizedDescription))
            }
        })
    }
    
    func updateBook(index: Int) {
        
        var usedBooks = self.books
        if !tempData.isEmpty {
            usedBooks = tempData
        }

        if self.books.count == 0 {
            return
        }
        
        let book = usedBooks[index]
        let titleIndex = usedBooks.firstIndex(where: { $0 == book }) ?? 0
        delegate?.updateView(book: book, index: titleIndex)
    }
    
    func searchBook(keyword: String?){
        guard let keyword = keyword?.lowercased() else {
            return
        }
        
        if keyword.isEmpty {
            if self.books.count == 0 {
                delegate?.presentError(type: .Custom(tracedErrorMessage))
                return
            }
            tempData = []
            numberOfPages = books.count
            delegate?.reloadData()
            return
        }
        
        let filtredBooks = books.filter { book in
            if let title = book.title {
                return title.lowercased().contains(keyword)
            }
            return false
        }

        let filtredBooksCount = filtredBooks.count
        if filtredBooksCount == 0 {
            delegate?.presentError(type: .EmptyResult)
        }else{
            tempData = filtredBooks
            numberOfPages = filtredBooksCount == 0 ? books.count : filtredBooksCount
            delegate?.presentError(type: .Clear)
            delegate?.reloadData()
        }
    }
}
