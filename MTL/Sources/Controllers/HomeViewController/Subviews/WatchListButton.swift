//
//  WatchListButton.swift
//  MTL
//
//  Created by Bogdan Grozyan on 28.05.2021.
//

import UIKit

final class WatchListButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        addUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "Watchlist"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let watchImageView: UIImageView = {
        let imageView = UIImageView()
        let font = UIFont.boldSystemFont(ofSize: 17)
        let configuration = UIImage.SymbolConfiguration(font: font)
        if let image = UIImage(systemName: "list.and.film")?.withTintColor(.label, renderingMode: .alwaysOriginal).withConfiguration(configuration) {
            imageView.image = image
        }
        return imageView
    }()
    
    let blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .prominent)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.isUserInteractionEnabled = false
        blurView.clipsToBounds = true
        blurView.alpha = 0.7
        return blurView
    }()
    
    private func setupFrames() {
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        watchImageView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            watchImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 7),
            watchImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            watchImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.45),
            watchImageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.54),
            
            title.topAnchor.constraint(equalTo: watchImageView.safeAreaLayoutGuide.bottomAnchor, constant: 2),
            title.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            title.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.20),
            title.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor)
        ])
    }
    
    private func addUI() {
        insertSubview(blurEffectView, at: 0)
        
        addSubview(watchImageView)
        addSubview(title)
        setupFrames()
    }
}
