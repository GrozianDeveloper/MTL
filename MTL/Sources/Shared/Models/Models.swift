//
//  Utilities.swift
//  MTL
//
//  Created by Bogdan Grozyan on 22.04.2021.
//

// ApiKey = 25c6029c1f7c22b43349255ec73021e9
import UIKit

// MARK: Genre & Keywords
struct Genre: Decodable {
    let id: Int
    let name: String
}

struct Keyword: Decodable {
    let id: Int
    let name: String
}
/// https://api.themoviedb.org/3/movie/1927/keywords?api_key=25c6029c1f7c22b43349255ec73021e9
struct KeywordsResponse: Decodable {
    let keywords: [Keyword]?
    
    let totalPages: Int?
    
    private enum CodingKeys: String, CodingKey {
        case keywords
        case totalPages = "total_pages"
     }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        keywords = try container.decode([Keyword].self, forKey: .keywords)
        totalPages = try? container.decode(Int.self, forKey: .totalPages)
    }
}

// MARK: Cast
///https://api.themoviedb.org/3/movie/1927/credits?api_key=25c6029c1f7c22b43349255ec73021e9&language=en-US
struct MovieTeamResponse: Decodable {
    let cast: [Person]
    let crew: [Person]
}

struct AllPersonData {
    let person: Person
    let ids: PersonExternalIDsResponse
}

struct PeoplesResponse: Decodable {
    let people: [Person]?
    let totalPages: Int?
    
    private enum CodingKeys: String, CodingKey {
        case people = "results"
        case totalPages = "total_pages"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        people = try container.decode([Person].self, forKey: .people)
        totalPages = try? container.decode(Int.self, forKey: .totalPages)
    }
}

struct Person: Decodable {
    let id: Int?
    let name: String?
    let overview: String?
    let deportament: String?
    var profileImage: UIImage?
    let profileImageURL: URL?
    let popularity: Double?
    let character: String?
    let job: String?
    enum CodingKeys: String, CodingKey {
        case overview
        case id
        case name
        case deportament = "known_for_department"
        case profileImagePath = "profile_path"
        case popularity
        case character
        case job
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        overview = try? container.decode(String.self, forKey: .overview)
        deportament = {
            let deportament = try? container.decode(String.self, forKey: .deportament)
            if deportament == "Acting" { return "Actor" }
            return deportament
        }()
        job = try? container.decode(String.self, forKey: .job)
        character = try? container.decode(String.self, forKey: .character)
        popularity = try? container.decode(Double.self, forKey: .popularity)
        
        let posterPath = try? container.decode(String.self, forKey: .profileImagePath)
        if posterPath != nil {
            profileImageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath!)")
        } else {
            profileImageURL = nil
        }
        profileImage = nil
    }
}
// MARK: - External ID
///    https://api.themoviedb.org/3/person/47/external_ids?api_key=25c6029c1f7c22b43349255ec73021e9&language=en-Us
struct PersonExternalIDsResponse: Decodable {
    let imdb: String?
    let facebook: String?
    let twitter: String?
    let instagram: String?
    
    private enum CodingKeys: String, CodingKey {
        case imdb = "imdb_id"
        case facebook = "facebook_id"
        case twitter = "twitter_id"
        case instagram = "instagram_id"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imdb = try? container.decode(String.self, forKey: .imdb)
        facebook = try? container.decode(String.self, forKey: .facebook)
        twitter = try? container.decode(String.self, forKey: .twitter)
        instagram = try? container.decode(String.self, forKey: .instagram)
    }
}
