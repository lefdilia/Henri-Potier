//
//  CartViewController.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 25/4/2022.
//

import UIKit


class CartViewController: UIViewController {
    
    let viewModel: CartViewModel

    init(viewModel: CartViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    lazy var orderTableView: UITableView = {
        let table = UITableView()
        table.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.contentInset.bottom = 20
        table.estimatedRowHeight = 120
        table.rowHeight = UITableView.automaticDimension
        table.backgroundColor = .Background
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.fetchOffers()
        
        let backImage = UIImage(named: "Back-Button")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
        
        title = viewModel.title
        view.backgroundColor = .Background
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(orderTableView)
        
        NSLayoutConstraint.activate([
            orderTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            orderTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            orderTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            orderTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CartViewController: CartDelegate {

    func updateCartOffer(offer: [String: Int]?) {
        guard let offer = offer else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            let customCart = CustomCartView(offer: offer)
            
            customCart.orderConfirmed = {
                self?.navigationController?.popViewController(animated: true)
                self?.viewModel.scheduleLocalNotification()
                
                if let cartItems = self?.viewModel.cartItems {                
                    self?.viewModel.clearCartItems(books: cartItems)
                }
            }

            if let width = self?.orderTableView.bounds.size.width {
                let size = customCart.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height))
                if customCart.frame.size.height != size.height {
                    customCart.frame.size.height = size.height
                    self?.orderTableView.tableFooterView = customCart
                }
            }
        }
    }
}


extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let removeFromCart = UIContextualAction(style: .destructive, title: "") { [weak self] (_, _, completion) in
            
            self?.viewModel.removeItemsFromCart(indexPath: indexPath)
            
            DispatchQueue.main.async {
                if self?.viewModel.cartItems.count == 0 {
                    self?.orderTableView.tableFooterView = nil
                }
                
                UIView.animate(withDuration: 0.3) {
                    tableView.reloadData()
                }
            }
            completion(true)
        }
        
        removeFromCart.backgroundColor = .Background
        removeFromCart.image =  UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))?.withTintColor(.trashColor).withRenderingMode(.alwaysOriginal)

        let swipes = UISwipeActionsConfiguration(actions: [removeFromCart])
        
        return swipes
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as! OrderTableViewCell
        
        cell.bookInCart = viewModel.configureCell(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let gbView = UIView()
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = "Votre panier est vide!"
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.cartItems.count > 0 ? 0 : 350
    }
    
}

//MARK: - Functions
extension CartViewController {
    @objc private func didTapBackButton(){
        navigationController?.popViewController(animated: true)
    }
}


