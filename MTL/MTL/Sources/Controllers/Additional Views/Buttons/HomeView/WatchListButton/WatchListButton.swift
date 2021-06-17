//
//  WatchListButton.swift
//  MTL
//
//  Created by Bogdan Grozyan on 28.05.2021.
//

import UIKit

final class WatchListButton: UIButton {
    
    public init() {
        super.init(frame: .zero)
        addUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupFrames()
    }
    
    private var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Watchlist"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var watchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont.boldSystemFont(ofSize: 17)
        let configuration = UIImage.SymbolConfiguration(font: font)
        if let image = UIImage(systemName: "list.and.film")?.withTintColor(.label, renderingMode: .alwaysOriginal).withConfiguration(configuration) {
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
    
    private func setupFrames() {
        blurEffectView.frame = bounds
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(watchImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 7))
        constraints.append(watchImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor))
        constraints.append(watchImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.45))
        constraints.append(watchImageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.54))
        
        constraints.append(title.topAnchor.constraint(equalTo: watchImageView.safeAreaLayoutGuide.bottomAnchor, constant: 2))
        constraints.append(title.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor))
        constraints.append(title.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.20))
        constraints.append(title.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addUI() {
        insertSubview(blurEffectView, at: 0)
        
        addSubview(watchImageView)
        addSubview(title)
    }
}
