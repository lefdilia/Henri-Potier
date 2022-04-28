//
//  bookmarksTableViewCell.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 28/4/2022.
//

import UIKit


class bookmarksTableViewCell: UITableViewCell {
    
    var addToCart: ((Books)->())? = nil
    
    static var identifier = "OrderCell"

    var book: Books? {
        didSet{
            guard let book = book else {
                return
            }

            //MARK: - Cover
            if let cover = book.cover, let url = URL(string: cover) {
                BookImageView.load(url: url)
            }
            
            //MARK: - Title
            if let title = book.title {
                let attributedText = NSAttributedString(string: title, attributes: [
                    .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                    .foregroundColor: UIColor.TopTitle
                ])
                titleLabel.attributedText = attributedText
            }
            
            //MARK: - ISBN
            if let isbn = book.isbn {
                let attributedText = NSAttributedString(string: "ISBN: \(isbn)", attributes: [
                    .font: UIFont.systemFont(ofSize: 11, weight: .regular),
                    .foregroundColor: UIColor.TopTitle
                ])
                isbnLabel.attributedText = attributedText
            }
            
            //MARK: - Price Label
            let pricePerUnit = book.price

            let priceAttributedText = NSAttributedString(string: "\(pricePerUnit) €", attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                .foregroundColor: UIColor.TopTitle
            ])
            priceLabel.attributedText = priceAttributedText
        }
    }

    //MARK: - Setup Views
    let container: UIView = {
        let container = UIView()
        container.backgroundColor = .Background
        container.layer.cornerRadius = 8
        container.layer.borderWidth = 0.7
        container.layer.shadowOpacity = 0.3
        container.layer.shadowRadius = 4
        container.layer.shadowOffset = .zero
        container.layer.shadowColor = UIColor.gray.cgColor
        container.layer.borderColor = UIColor.clear.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    let BookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let isbnLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Bottom Cart Buttons
    lazy var addToCartButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .bottomAddCartBackground
        configuration.image = UIImage(systemName: "cart.badge.plus", withConfiguration: UIImage.SymbolConfiguration(scale: .small))?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        configuration.titlePadding = 10
        configuration.imagePadding = 10
        configuration.imagePlacement = .leading
        configuration.subtitle = "Commander"
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(didTapAddCart), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.backgroundColor = .Background
        
        contentView.addSubview(container)
        container.addSubview(BookImageView)
        container.addSubview(titleLabel)
        container.addSubview(isbnLabel)
        container.addSubview(addToCartButton)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            BookImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            BookImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            BookImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            BookImageView.heightAnchor.constraint(equalToConstant: 110),
            BookImageView.widthAnchor.constraint(equalTo: BookImageView.heightAnchor, multiplier: 0.68),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: BookImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -2),
            
            isbnLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            isbnLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            isbnLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 5),
            
            addToCartButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant:  -15),
            addToCartButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),

        ])
    }
    
    //MARK: - Add To Cart
    @objc private func didTapAddCart(){
        guard let book = book else {
            return
        }
        addToCart?(book)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
