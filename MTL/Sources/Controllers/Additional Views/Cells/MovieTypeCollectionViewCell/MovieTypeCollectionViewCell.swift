//
//  MovieTypeCollectionViewCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 07.05.2021.
//

import UIKit

final class MovieTypeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieTypeCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("MovieTypeCollectionViewCell")
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let watchStatmentIndicator: UIView = {
        let indicator = UIView()
        indicator.backgroundColor = nil
        indicator.layer.cornerRadius = 5
        return indicator
    }()
    
    override var isHighlighted: Bool {
        didSet {
            label.textColor = isHighlighted ? .label : .secondaryLabel
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepareUIForReuse()
    }
    
    func configure(text: String, color: UIColor?) {
        label.text = text
        watchStatmentIndicator.backgroundColor = color
    }
}

// MARK: - Setup
extension MovieTypeCollectionViewCell {
    private func setupUI() {
        addSubview(watchStatmentIndicator)
        addSubview(label)
        setupFrames()
    }
    
    private func prepareUIForReuse() {
        label.textColor = .secondaryLabel
    }
    
    private func setupFrames() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        watchStatmentIndicator.translatesAutoresizingMaskIntoConstraints = false
        if watchStatmentIndicator.backgroundColor != nil {
            watchStatmentIndicator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            watchStatmentIndicator.leadingAnchor.constraint(equalTo: label.safeAreaLayoutGuide.leadingAnchor, constant: label.frame.width - 8).isActive = true
            
            watchStatmentIndicator.widthAnchor.constraint(equalToConstant: 10).isActive = true
            watchStatmentIndicator.heightAnchor.constraint(equalToConstant: 10).isActive = true
        }
    }
}
