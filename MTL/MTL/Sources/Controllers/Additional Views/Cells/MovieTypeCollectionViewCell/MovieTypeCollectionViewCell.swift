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
        addUI()
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
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = nil
        indicator.layer.cornerRadius = 5
        return indicator
    }()
    
    func configure(text: String, color: UIColor?) {
        label.text = text
        watchStatmentIndicator.backgroundColor = color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupFrames()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepareUIForReuse()
    }
    
    private func addUI() {
        addSubview(watchStatmentIndicator)
        addSubview(label)
    }
    
    private func prepareUIForReuse() {
        label.textColor = .secondaryLabel
    }
    
    private func setupFrames() {
        label.frame = contentView.bounds
        if watchStatmentIndicator.backgroundColor != nil {
            watchStatmentIndicator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            watchStatmentIndicator.leadingAnchor.constraint(equalTo: label.safeAreaLayoutGuide.leadingAnchor, constant: label.frame.width - 8).isActive = true
            
            watchStatmentIndicator.widthAnchor.constraint(equalToConstant: 10).isActive = true
            watchStatmentIndicator.heightAnchor.constraint(equalToConstant: 10).isActive = true
        }
    }
    override var isHighlighted: Bool {
            didSet {
                label.textColor = isHighlighted ? .label : .secondaryLabel
            }
        }
    
}
