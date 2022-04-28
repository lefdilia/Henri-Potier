//
//  CustomCartView.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 26/4/2022.
//

import UIKit


class CustomCartView: UIView {
    
    var subTotal: Int?
    var discountAmount: Int?
    var globalAmount: Int?

    //MARK: - Sub-Total
    let subTotalTitle: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "Sous-total", attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: UIColor.TopTitle
        ])
        label.attributedText = attributedText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subTotalCalculated: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: subTotal?.formattedPrice ?? "", attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: UIColor.TopTitle
        ])
        label.attributedText = attributedText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var subTotalStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [subTotalTitle, subTotalCalculated])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: - Discount
    lazy var discountedAmount: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "- \(discountAmount?.formattedPrice ?? "")", attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: UIColor.TopTitle
        ])
        label.attributedText = attributedText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Separators
    let topLineSeparator: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .borderColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    let bottomLineSeparator: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .borderColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    //MARK: - Montant Global
    let globalAmountTitle: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "Montant global", attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.TopTitle
        ])
        label.attributedText = attributedText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var globalAmountCalculated: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "\(globalAmount?.formattedPrice ?? "")", attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.TopTitle
        ])
        label.attributedText = attributedText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var globalAmountStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [globalAmountTitle, globalAmountCalculated])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Button
    lazy var checkOutButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .CartBadgeBackground
        var attributedString = AttributedString("Valider ma commande")
        attributedString.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        configuration.attributedTitle = attributedString
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didPlaceOrder), for: .touchUpInside)
        return button
    }()
    
    var orderConfirmed: (()->Void)? = nil
    
    @objc private func didPlaceOrder(){
        
        var configuration = checkOutButton.configuration
        configuration?.showsActivityIndicator = true
        configuration?.attributedTitle = nil
        
        checkOutButton.configuration = configuration
        checkOutButton.setNeedsUpdateConfiguration()
        
        //Fake Order
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [weak self] in
            self?.orderConfirmed?()
        }
    }
    
    
    convenience init(offer: [String: Int] ) {
        self.init()
        
        self.subTotal =  offer["subtotal"]
        self.discountAmount = offer["discount"]
        self.globalAmount = offer["total"]

        addSubview(topLineSeparator)
        addSubview(subTotalStack)
        addSubview(discountedAmount)
        addSubview(bottomLineSeparator)
        addSubview(globalAmountStack)
        addSubview(checkOutButton)
        
        NSLayoutConstraint.activate([
            
            topLineSeparator.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            topLineSeparator.heightAnchor.constraint(equalToConstant: 1),
            topLineSeparator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            topLineSeparator.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            subTotalStack.topAnchor.constraint(equalTo: topLineSeparator.bottomAnchor, constant: 20),
            subTotalStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTotalStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            
            discountedAmount.topAnchor.constraint(equalTo: subTotalStack.bottomAnchor, constant: 15),
            discountedAmount.trailingAnchor.constraint(equalTo: subTotalStack.trailingAnchor),
            
            bottomLineSeparator.topAnchor.constraint(equalTo: discountedAmount.bottomAnchor, constant: 25),
            bottomLineSeparator.heightAnchor.constraint(equalToConstant: 1),
            bottomLineSeparator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.86),
            bottomLineSeparator.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            globalAmountStack.topAnchor.constraint(equalTo: bottomLineSeparator.bottomAnchor, constant: 20),
            globalAmountStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            globalAmountStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.86),
            globalAmountStack.heightAnchor.constraint(equalToConstant: 30),

            checkOutButton.topAnchor.constraint(greaterThanOrEqualTo: globalAmountStack.bottomAnchor, constant: 30),
            checkOutButton.centerXAnchor.constraint(equalTo: globalAmountStack.centerXAnchor),
            checkOutButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
            checkOutButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}
