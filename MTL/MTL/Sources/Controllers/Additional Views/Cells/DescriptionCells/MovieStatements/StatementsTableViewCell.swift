//
//  StatementsTableViewCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 09.05.2021.
//

import UIKit

final class StatementsTableViewCell: UITableViewCell {
    
    static let identifier = "StatementsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "StatementsTableViewCell", bundle: nil)
    }
    
    @IBOutlet private weak var wantButton: UIButton!
    @IBOutlet private weak var watchedButton: UIButton!
    
    @IBOutlet private weak var watchedLabel: UILabel!
    @IBOutlet private weak var tripleDotsButton: UIButton!
    
    private var movieStatment: WatchStatments = .none
    
    var changeStatmentCallBack: ((_ statment: WatchStatments) -> ())?
    
    var pushAlertToChangeStatmentCallBack: (() -> ())?
    
    private var movieId: Int?
    
    public func configure(with statment: WatchStatments, movieId: Int) {
        self.movieId = movieId
        movieStatment = statment
        
        switch movieStatment {
        case .wanted:
            watchedLabel.isHidden = true
            tripleDotsButton.isHidden = true
            
            wantButton.isHidden = false
            watchedButton.isHidden = false
            wantButton.backgroundColor = UIColor(red: 38/255, green: 86/255, blue: 210/255, alpha: 1)
        case .watched:
            watchedLabel.isHidden = false
            tripleDotsButton.isHidden = false
            
            wantButton.isHidden = true
            watchedButton.isHidden = true
        default:
            watchedLabel.isHidden = true
            tripleDotsButton.isHidden = true
            
            wantButton.isHidden = false
            watchedButton.isHidden = false
        }
    }
    
    @IBAction func changeWantStatment(_ sender: Any) {
        switch movieStatment {
        case .none:
            changeStatmentCallBack?(.wanted)
        case .wanted:
            changeStatmentCallBack?(.none)
        default:
            changeStatmentCallBack?(.none)
        }
    }
    
    @IBAction func changeWatchedStatment(_ sender: Any) {
        switch movieStatment {
        case .none, .wanted:
            changeStatmentCallBack?(.watched)
        default:
            changeStatmentCallBack?(.none)
        }
    }
    
    @IBAction func tripleDotsTupped(_ sender: UIButton) {
        pushAlertToChangeStatmentCallBack?()
    }
}
