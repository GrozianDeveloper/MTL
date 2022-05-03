//
//  VoteRuntimePopularityTableViewCell.swift
//  MTL
//
//  Created by Bogdan Grozyan on 14.05.2021.
//

import UIKit

final class VotePopularityRuntimeTableViewCell: UITableViewCell, Nibable {
    
    @IBOutlet private var voteAverageLabel: UILabel!
    
    @IBOutlet private var popularityLabel: UILabel!
    
    func configure(with voteAverage: Double?, popularity: Double?) {
        let coolVoteAverage = Double(round(10 * (voteAverage ?? 0)) / 10)
        voteAverageLabel.text = "Vote \n \(coolVoteAverage)"
        voteAverageLabel.backgroundColor = .systemBackground
        voteAverageLabel.textColor = .label
        
        popularityLabel.text = "Popularity \n \(Int(popularity ?? 0))"
        popularityLabel.backgroundColor = .systemBackground
        popularityLabel.textColor = .label
    }
}
