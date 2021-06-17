//
//  SearchButton.swift
//  MTL
//
//  Created by Bogdan Grozyan on 28.05.2021.
//

import UIKit

class SearchButton: UIButton {

    init() {
        super.init(frame: .zero)
        addUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let searchLabel: UILabel = {
        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Search"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let magnifierView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont.boldSystemFont(ofSize: 19)
        let configuration = UIImage.SymbolConfiguration(font: font)
        if let image = UIImage(systemName: "magnifyingglass")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal).withConfiguration(configuration) {
            imageView.image = image
        }
        return imageView
    }()
    
    public var blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .prominent)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.isUserInteractionEnabled = false
        blurView.clipsToBounds = true
        blurView.alpha = 0.7
        return blurView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupFrames()
    }
    
    private func addUI() {
        insertSubview(blurEffectView, at: 0)
        addSubview(magnifierView)
        addSubview(searchLabel)
    }
    
    private func setupFrames() {
        blurEffectView.frame = bounds
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(magnifierView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor))
        constraints.append(magnifierView.trailingAnchor.constraint(equalTo: searchLabel.safeAreaLayoutGuide.leadingAnchor, constant: -5))
        constraints.append(magnifierView.heightAnchor.constraint(equalTo: searchLabel.safeAreaLayoutGuide.heightAnchor))
        constraints.append(magnifierView.widthAnchor.constraint(equalTo: magnifierView.safeAreaLayoutGuide.heightAnchor))
        
        let font = searchLabel.font
            let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (searchLabel.text! as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        
        searchLabel.frame = CGRect(
            x: bounds.width / 2 - size.width / 2 + magnifierView.frame.width / 2,
            y: bounds.height / 2 - size.height / 2,
            width: size.width,
            height: size.height)
        
        NSLayoutConstraint.activate(constraints)
    }
}
