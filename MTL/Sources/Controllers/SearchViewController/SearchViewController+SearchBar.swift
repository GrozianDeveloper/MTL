//
//  SearchViewController+SearchBar.swift
//  MTL
//
//  Created by Bogdan Grozian on 03.05.2022.
//

import UIKit

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        sections = []
        if searchText != "" {
            isNowSearching = true
            tableView.reloadData()
            searchMovieByQuery(text: searchText, page: 1)
            searchPeopleByName(text: searchText, page: 1)
        } else {
            isNowSearching = false
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isNowSearching = false
        tableView.reloadData()
        dismissKeyboard()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isNowSearching = true
        searchBar.showsCancelButton = true
    }
}
