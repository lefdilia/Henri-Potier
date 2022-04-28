//
//  BookmarksViewController.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 28/4/2022.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    let viewModel: BookmarksViewModel
    
    init(viewModel: BookmarksViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var bookmarksTableView: UITableView = {
        let table = UITableView()
        table.register(bookmarksTableViewCell.self, forCellReuseIdentifier: bookmarksTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.contentInset.bottom = 20
        table.estimatedRowHeight = 120
        table.rowHeight = UITableView.automaticDimension
        table.backgroundColor = .Background
        table.tableFooterView = UIView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        viewModel.delegate = self
        viewModel.fetchBookMarks()
        
        view.backgroundColor = .white
        title = viewModel.title

        let backImage = UIImage(named: "Back-Button")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
        
        title = viewModel.title
        view.backgroundColor = .Background
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(bookmarksTableView)
        
        NSLayoutConstraint.activate([
            bookmarksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            bookmarksTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bookmarksTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bookmarksTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: bookmarksTableViewCell.identifier, for: indexPath) as! bookmarksTableViewCell
        
        cell.book = viewModel.configureCell(indexPath: indexPath)
        
        cell.addToCart = { [weak self] book in
            self?.viewModel.addToCart(book: book)
            self?.navigationController?.popViewController(animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.bookmarks.count > 0 ? 0 : 350
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let gbView = UIView()
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = "la liste des signets est vide."
            label.textColor = .TintColor
            label.textAlignment = .center
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: Theme.GentiumBookBasicBold, size: 24)
            return label
        }()
        
        gbView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: gbView.topAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: gbView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: gbView.trailingAnchor, constant: -10),
            messageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
        
        return gbView
    }
    
}

//MARK: - Functions
extension BookmarksViewController {
    @objc private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
}
