//
//  SearchButton.swift
//  MTL
//
//  Created by Bogdan Grozyan on 28.05.2021.
//

import UIKit

final class SearchButton: UIButton {

    init() {
        super.init(frame: .zero)
        addUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let magnifierView: UIImageView = {
        let imageView = UIImageView()
        let font = UIFont.boldSystemFont(ofSize: 19)
        let configuration = UIImage.SymbolConfiguration(font: font)
        if let image = UIImage(systemName: "magnifyingglass")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal).withConfiguration(configuration) {
            imageView.image = image
        }
        return imageView
    }()
    
    var blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .prominent)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.isUserInteractionEnabled = false
        blurView.clipsToBounds = true
        blurView.alpha = 0.7
        return blurView
    }()
    
    private func addUI() {
        insertSubview(blurEffectView, at: 0)
        addSubview(magnifierView)
        addSubview(searchLabel)
        
        magnifierView.translatesAutoresizingMaskIntoConstraints = false
        magnifierView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        magnifierView.trailingAnchor.constraint(equalTo: searchLabel.safeAreaLayoutGuide.leadingAnchor, constant: -5).isActive = true
        magnifierView.heightAnchor.constraint(equalTo: searchLabel.safeAreaLayoutGuide.heightAnchor).isActive = true
        magnifierView.widthAnchor.constraint(equalTo: magnifierView.safeAreaLayoutGuide.heightAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        blurEffectView.frame = bounds
        
        let font = searchLabel.font
            let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (searchLabel.text! as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        searchLabel.frame = CGRect(
            x: bounds.width / 2 - size.width / 2 + magnifierView.frame.width / 2,
            y: bounds.height / 2 - size.height / 2,
            width: size.width,
            height: size.height)
    }
}
