//
//  BooksCollectionViewCell.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 23/4/2022.
//

import UIKit

class BooksCollectionViewCell: UICollectionViewCell {
    
    var setBookmark: ((Books)->())? = nil

    static var identifier = "BookCell"
    
    var book: Books? {
        didSet {
            guard let book = book else {
                return
            }

            bookmarkButton.isSelected = book.bookmark
            
            if let cover = book.cover, let url = URL(string: cover) {
                imageView.load(url: url)
            }
        }
    }

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray.withAlphaComponent(0.4)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var bookmarkButton: UIButton = {
        var configuration = UIButton.Configuration.plain()

        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(didTapBookmark), for: .touchUpInside)
        
        button.tintColor = .clear
        button.setImage(UIImage(named: "like-book-init"), for: .normal)
        button.setImage(UIImage(named: "like-book-done"), for: .selected)

        return button
    }()
    
    @objc private func didTapBookmark(_ sender: UIButton){
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            sender.isSelected.toggle()
            if sender.isSelected == true {
                sender.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }
        } completion: { _ in
            sender.transform = .identity
        }
        
        guard let book = book else {
            return
        }
        
        setBookmark?(book)
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.addSubview(bookmarkButton)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            bookmarkButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
