//
//  ApoloModel.swift
//  PruebaConceptoElTiempo
//
//  Created by mespinal on 5/03/21.
//

import Foundation

struct BaseConnectionModel: Codable
{
    var collecctionApolo: CollectionApolo?
    
    enum CodingKeys: String, CodingKey
    {
        case collecctionApolo = "collection"
    }
}

struct CollectionApolo: Codable
{
    var apoloItems: [ApoloModel]?
    
    enum CodingKeys: String, CodingKey
    {
        case apoloItems = "items"
    }
}

struct ApoloModel: Codable
{
    var apoloTitle: String?
    var apoloDesc: String?
    var apoloKeywords: [String]?
    var apoloImageUrl: String?
    var apoloLinks: [ApoloLinksModel]?
    var apoloDataList: [ApoloDataModel]?
    
    enum CodingKeys: String, CodingKey
    {
        case apoloLinks = "links"
        case apoloDataList = "data"
    }
}

struct ApoloLinksModel: Codable
{
    var apoloLinkUrl: String?
    var apoloLinkRel: String?
    
    enum CodingKeys: String, CodingKey
    {
        case apoloLinkUrl = "href"
        case apoloLinkRel = "rel"
    }
}

struct ApoloDataModel: Codable
{
    var apoloDataTitle: String?
    var apoloDataDesc: String?
    var apoloDataKewords: [String]?
    
    enum CodingKeys: String, CodingKey
    {
        case apoloDataTitle = "title"
        case apoloDataDesc = "description"
        case apoloDataKewords = "keywords"
    }
}
