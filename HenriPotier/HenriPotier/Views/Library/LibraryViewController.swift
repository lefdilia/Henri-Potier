//
//  LibraryViewController.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 23/4/2022.
//

import UIKit
import UserNotifications

class LibraryViewController: UIViewController {
    
    let viewModel: LibraryViewModel
    
    init(viewModel: LibraryViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - Shopping Cart
    let cartButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "shopping-cart")?.withTintColor(.TopTitle)
        let button = UIButton(configuration: configuration)
        button.imageView?.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cartBadge: UILabel = {
        let label = UILabel()
        label.backgroundColor = .CartBadgeBackground
        label.layer.cornerRadius = 12
        label.layer.borderColor = UIColor.CartBadgeBorder.cgColor
        label.layer.borderWidth = 3
        label.layer.masksToBounds = true
        label.clipsToBounds = true
        label.textAlignment = .center
        label.text = "0"
        label.textColor = .white

        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()

    lazy var cartViewContainer: UIView = {
        let _view = UIView()
        _view.isUserInteractionEnabled = true
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.addSubview(cartButton)
        _view.addSubview(cartBadge)

        NSLayoutConstraint.activate([

            cartButton.topAnchor.constraint(equalTo: _view.topAnchor),
            cartButton.trailingAnchor.constraint(equalTo: _view.trailingAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: 30),
            cartButton.bottomAnchor.constraint(equalTo: _view.bottomAnchor, constant: 0),

            cartBadge.bottomAnchor.constraint(equalTo: cartButton.topAnchor, constant: 17),
            cartBadge.leadingAnchor.constraint(equalTo: cartButton.trailingAnchor, constant: -22),
            cartBadge.heightAnchor.constraint(equalToConstant: 24),
            cartBadge.widthAnchor.constraint(equalToConstant: 24),
            
            _view.heightAnchor.constraint(equalTo: cartButton.heightAnchor),
            _view.widthAnchor.constraint(equalTo: cartButton.widthAnchor),
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCartCheckButton))
        _view.addGestureRecognizer(gesture)
        
        return _view
    }()
    
    //MARK: - Search Texfield
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.tintColor = .TintColor
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.placeholder = "Henri Potier..."
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1.2
        textField.layer.borderColor = UIColor.borderColor.cgColor
        if let image = UIImage(named: "search")?.withTintColor(.TintColor).withRenderingMode(.alwaysOriginal) {
            let iconView = UIImageView(frame: CGRect(x: 10, y: 0, width: 14, height: 14))
            iconView.image = image
            let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 15))
            iconContainerView.addSubview(iconView)
            textField.leftView = iconContainerView
            textField.leftViewMode = .always
        }
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.returnKeyType = .continue
        textField.keyboardType = .alphabet
        textField.addTarget(self, action: #selector(didStartSearch), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //MARK: - Empty search Message
    let emptySearchMessageLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "errorMessage"
        return label
    }()

    //MARK: - Books Collection
    lazy var booksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize.zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BooksCollectionViewCell.self, forCellWithReuseIdentifier: BooksCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: - PageControl
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .currentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = .pageIndicatorTintColor
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var previousBook: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Previous-Book")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapPreviousBook), for: .touchUpInside)
        return button
    }()
    
    lazy var nextBook: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Next-Book")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapNextBook), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Book Title
    let bookTitleLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "", attributes: [
            .font: UIFont(name: Theme.GentiumBookBasicBold, size: 20)!,
            .foregroundColor: UIColor.TopTitle
        ])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Synopsis
    let bookSynopsisLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "", attributes: [
            .font: UIFont(name: Theme.GentiumBookBasicRegular, size: 16)!,
            .foregroundColor: UIColor.TopTitle
        ])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Bottom Cart Buttons
    lazy var addToCart: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .bottomAddCartBackground
        configuration.image = UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration(scale: .small))?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        configuration.titlePadding = 10
        configuration.imagePadding = 10
        configuration.imagePlacement = .trailing
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: view.frame.width/2.5, bottom: 12, trailing: 0)
        
        var attText = AttributedString("Add to Cart")
        attText.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        configuration.attributedTitle = attText
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(didTapAddCart), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Price View
    lazy var priceView: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.backgroundColor = .bottomPriceBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Bookmarks
    lazy var bookmarksButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "bookmarks")
        button.setImage(image, for: .normal)
        button.backgroundColor = .BookMarksBackground
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.bookmarksBorder.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapBooksmarks), for: .touchUpInside)
        return button
    }()
    
    //MARK: - ScrollView
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var globalContentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///Update cart after removing Items
        viewModel.countCart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure User Notification Center
        UNUserNotificationCenter.current().delegate = self
        
        viewModel.delegate = self
        viewModel.fetchBooks()
        
        view.backgroundColor = .Background
        
        title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true

        //MARK: - Right Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartViewContainer)
        navigationItem.titleView?.isOpaque = false

        //MARK: - Setup Scroll View
        view.addSubview(scrollView)
        scrollView.addSubview(globalContentView)
        
        let bottomAnchor = globalContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        bottomAnchor.priority = UILayoutPriority(250)
        
        let centerYAnchor = globalContentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        centerYAnchor.priority = UILayoutPriority(250)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            globalContentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            globalContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            globalContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            globalContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            centerYAnchor,
            bottomAnchor,
        ])
        
        //MARK: - Setup Views Layout
        globalContentView.addSubview(searchTextField)
        globalContentView.addSubview(emptySearchMessageLabel)
        globalContentView.addSubview(booksCollectionView)
        
        globalContentView.addSubview(pageControl)
        globalContentView.addSubview(previousBook)
        globalContentView.addSubview(nextBook)
        
        globalContentView.addSubview(bookTitleLabel)
        globalContentView.addSubview(bookSynopsisLabel)
        globalContentView.addSubview(addToCart)
        addToCart.addSubview(priceView)
        
        globalContentView.addSubview(bookmarksButton)
        
        let constraint = emptySearchMessageLabel.heightAnchor.constraint(equalToConstant: 0)
        constraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: globalContentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.centerXAnchor.constraint(equalTo: globalContentView.centerXAnchor),
            searchTextField.widthAnchor.constraint(equalTo: globalContentView.widthAnchor, multiplier: 0.86),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),

            emptySearchMessageLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            emptySearchMessageLabel.centerXAnchor.constraint(equalTo: globalContentView.centerXAnchor),
            emptySearchMessageLabel.widthAnchor.constraint(equalTo: globalContentView.widthAnchor, multiplier: 0.7),
            constraint,

            booksCollectionView.topAnchor.constraint(equalTo: emptySearchMessageLabel.bottomAnchor, constant: 0),
            booksCollectionView.centerXAnchor.constraint(equalTo: globalContentView.centerXAnchor),
            booksCollectionView.heightAnchor.constraint(equalToConstant: 300),
            booksCollectionView.widthAnchor.constraint(equalTo: booksCollectionView.heightAnchor, multiplier: 0.68),
            
            pageControl.topAnchor.constraint(equalTo: booksCollectionView.bottomAnchor, constant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            previousBook.centerYAnchor.constraint(equalTo: booksCollectionView.centerYAnchor, constant: 50),
            previousBook.trailingAnchor.constraint(equalTo: booksCollectionView.leadingAnchor, constant: -20),
            
            nextBook.centerYAnchor.constraint(equalTo: previousBook.centerYAnchor),
            nextBook.leadingAnchor.constraint(equalTo: booksCollectionView.trailingAnchor, constant: 20),
            
            bookTitleLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 30),
            bookTitleLabel.centerXAnchor.constraint(equalTo: globalContentView.centerXAnchor),
            
            bookSynopsisLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 10),
            bookSynopsisLabel.centerXAnchor.constraint(equalTo: bookTitleLabel.centerXAnchor),
            bookSynopsisLabel.widthAnchor.constraint(equalTo: globalContentView.widthAnchor, multiplier: 0.8),
            
            addToCart.topAnchor.constraint(equalTo: bookSynopsisLabel.bottomAnchor, constant: 40),
            addToCart.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            addToCart.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            priceView.centerYAnchor.constraint(equalTo: addToCart.centerYAnchor),
            priceView.leadingAnchor.constraint(equalTo: addToCart.leadingAnchor, constant: 7),
            priceView.heightAnchor.constraint(equalTo: addToCart.heightAnchor, multiplier: 0.8),
            priceView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15),
            
            bookmarksButton.centerYAnchor.constraint(equalTo: addToCart.centerYAnchor),
            bookmarksButton.heightAnchor.constraint(equalTo: addToCart.heightAnchor),
            bookmarksButton.trailingAnchor.constraint(equalTo: addToCart.leadingAnchor, constant: -7),
            bookmarksButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15),
            
            addToCart.bottomAnchor.constraint(equalTo: globalContentView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    /// Page Control
    private func setControllIndicators(index: Int){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) { [weak self] in
            if #available(iOS 14.0, *) {
                self?.pageControl.setIndicatorImage(UIImage(named: "page"), forPage: self?.pageControl.currentPage ?? 0)
            }
            self?.pageControl.currentPage = index
            if #available(iOS 14.0, *) {
                self?.pageControl.setIndicatorImage(UIImage(named: "current-page"), forPage: index)
            }
        }
    }
    
    @objc private func didTapNextBook(){
        var currentPage = pageControl.currentPage + 1
        
        if currentPage == pageControl.numberOfPages {
            currentPage = 0
            let indexPath = IndexPath(item: currentPage, section: 0)
            pageControl.currentPage = pageControl.numberOfPages
            setControllIndicators(index: currentPage)
            booksCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            return
        }
        
        if currentPage < pageControl.numberOfPages {
            let indexPath = IndexPath(item: currentPage, section: 0)
            setControllIndicators(index: currentPage)
            booksCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc private func didTapPreviousBook(){
        let currentPage = pageControl.currentPage - 1
        
        if currentPage < 0 {
            let nextPage = pageControl.numberOfPages - 1
            let indexPath = IndexPath(item: nextPage, section: 0)
            setControllIndicators(index: nextPage)
            booksCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        if currentPage < pageControl.numberOfPages && currentPage >= 0 {
            let indexPath = IndexPath(item: currentPage, section: 0)
            setControllIndicators(index: currentPage)
            booksCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    ///Cart
    @objc private func didTapAddCart(){
        if let visibleBookCell = self.booksCollectionView.visibleCells.first, let indexPath = booksCollectionView.indexPath(for: visibleBookCell) {
            let book = viewModel.books[indexPath.row]
            viewModel.addToCart(book: book)
        }
    }
    
    ///Bookmarks Controller
    @objc private func didTapBooksmarks(_ sender: UIButton){
        let bookmarksViewModel = BookmarksViewModel()
        let bookmarksViewController = BookmarksViewController(viewModel: bookmarksViewModel)
        navigationController?.pushViewController(bookmarksViewController, animated: true)
    }

    ///Check Out Button
    @objc private func didTapCartCheckButton(){
        let cartViewModel = CartViewModel()
        let cartViewController = CartViewController(viewModel: cartViewModel)
        navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    ///Textfield Functions
    @objc private func didStartSearch(_ textfield: UITextField){
        let keyword = textfield.text

        if let keyword = keyword, keyword.isEmpty, viewModel.books.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            booksCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            setControllIndicators(index: 0)
        }
        viewModel.searchBook(keyword: keyword)
    }
    
    ///Empty search Result
    private func EmptySearchMessage(type messageCases: SearchMessageCases = .Clear){
        
        let attributedText = NSAttributedString(string: messageCases.description, attributes: [
                .font: UIFont(name: Theme.GentiumBookBasicBold, size: 28)!,
                .foregroundColor: UIColor.TopTitle ])

        emptySearchMessageLabel.attributedText = attributedText
        
        for _view in globalContentView.subviews where _view is UITextField == false && _view.accessibilityIdentifier != "errorMessage" {
            _view.isHidden = messageCases == .Clear ? false : true
        }
    }
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BooksCollectionViewCell.identifier, for: indexPath) as! BooksCollectionViewCell
        
        cell.book = viewModel.configureCell(indexPath: indexPath)
        
        cell.setBookmark = { [weak self] book in
            self?.viewModel.setBookmark(book: book)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
        let pageInt = Int(round(pageFloat))
        
        setControllIndicators(index: pageInt)
        viewModel.updateBook(index: pageInt)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
        let pageInt = Int(round(pageFloat))
        
        viewModel.updateBook(index: pageInt)
    }
}

extension LibraryViewController: PresentBooksDelegate {

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.booksCollectionView.reloadData()
            self?.pageControl.numberOfPages = self?.viewModel.numberOfPages ?? 0
            //Fix PageControll
            let current = self?.pageControl.currentPage ?? 0
            self?.setControllIndicators(index: current)
            self?.viewModel.updateBook(index: current)
        }
    }
    
    func updateCart(quantity: Int) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) { [weak self] in
                self?.cartBadge.text = "\(quantity)"
                self?.cartBadge.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            } completion: { [weak self] _ in
                self?.cartBadge.transform = .identity
            }
        }

    }
    
    //MARK: - Update View
    func updateView(book: Books, index: Int ){
        
        ///Title
        if let title = book.title {
            bookTitleLabel.attributedText = NSAttributedString(string: "\(book.index). \(title)", attributes: [
                .font: UIFont(name: Theme.GentiumBookBasicBold, size: 20)!,
                .foregroundColor: UIColor.TopTitle
            ])
        }
        
        ///Synopsis
        if let synopsis = book.synopsis?.first{
            let _synopsis = synopsis.replacingOccurrences(of: ".", with: ".\n\n")
            let synopsisAttributedText = NSAttributedString(string: "\(_synopsis)", attributes: [
                .font: UIFont(name: Theme.GentiumBookBasicRegular, size: 16)!,
                .foregroundColor: UIColor.TopTitle
            ])
            bookSynopsisLabel.attributedText = synopsisAttributedText
        }
        
        ///Price
        let price = "\(book.price)€"
        let attributedText = NSAttributedString(string: price, attributes: [
            .font : UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor: UIColor.bottomPriceTintColor,
        ])
        priceView.attributedText = attributedText
    }
    
    //MARK: - Show Error
    func presentError(type: SearchMessageCases) {
        DispatchQueue.main.async { [weak self] in
            self?.EmptySearchMessage(type: type)
        }
    }
}

extension LibraryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        EmptySearchMessage(type: .Clear)
        
        DispatchQueue.main.async { [weak self] in
            self?.setControllIndicators(index: 0)
        }
        return true
    }
}

extension LibraryViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        //Fix Cart Items Border: Lost in mode switch
        cartBadge.layer.borderColor = UIColor.CartBadgeBorder.cgColor
        cartBadge.layer.borderWidth = 3
        cartBadge.layer.masksToBounds = true
        view.setNeedsLayout()
        
        //Fix Bookmarks Button
        bookmarksButton.layer.cornerRadius = 8
        bookmarksButton.layer.borderWidth = 1
        bookmarksButton.layer.borderColor = UIColor.bookmarksBorder.cgColor
    }
}

extension LibraryViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .list, .banner])
    }
    
}
