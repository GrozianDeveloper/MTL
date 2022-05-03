//
//  SearchModels.swift
//  MTL
//
//  Created by Bogdan Grozian on 03.05.2022.
//

import Foundation

// MARK: Discrover

// https://developers.themoviedb.org/3/discover/movie-discover
//Params:
/*
 sort_by
 page
 with_cast
 with_crew
 with_people
 with_genre
 with_keywords
 */

// MARK: Search by movie name
///https://api.themoviedb.org/3/search/movie?api_key=25c6029c1f7c22b43349255ec73021e9&query=Hulk&page=1

// MARK: Search person by name
///https://api.themoviedb.org/3/search/person?api_key=25c6029c1f7c22b43349255ec73021e9&query=robert&page=1
struct SearchPersonResponse: Decodable {
    let page: Int
    let results: [Person]?
}

// MARK: Search by person id
///https://api.themoviedb.org/3/person/12835/movie_credits?api_key=25c6029c1f7c22b43349255ec73021e9&language=en-US

// MARK: Search by keywords name and id
///https://api.themoviedb.org/3/search/keyword?api_key=25c6029c1f7c22b43349255ec73021e9&query=ho&page=1
