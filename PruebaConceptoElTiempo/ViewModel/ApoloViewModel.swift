//
//  ApoloViewModel.swift
//  PruebaConceptoElTiempo
//
//  Created by mespinal on 7/03/21.
//

import Foundation

struct ApoloViewModel
{
    var apoloList = [ApoloModel]()
    
    init(apoloList: [ApoloModel])
    {
        self.apoloList = apoloList
        self.updateApoloList()
    }
    
    private mutating func updateApoloList()
    {
        for i in 0..<apoloList.count
        {
            let apoloTitle = apoloList[i].apoloDataList![0].apoloDataTitle ?? ""
            let apoloDesc = apoloList[i].apoloDataList![0].apoloDataDesc ?? ""
            let apoloKeywords = apoloList[i].apoloDataList![0].apoloDataKewords ?? []
            let apoloIsFavorite = apoloList[i].apoloIsFavorite ?? false
            var apoloImageUrl = ""
            
            if let apoloLink = apoloList[i].apoloLinks?.filter({ $0.apoloLinkRel == "preview" }).first
            {
                apoloImageUrl = apoloLink.apoloLinkUrl ?? ""
            }
            
            apoloList[i].apoloTitle = apoloTitle
            apoloList[i].apoloDesc = apoloDesc
            apoloList[i].apoloKeywords = apoloKeywords
            apoloList[i].apoloImageUrl = apoloImageUrl
            apoloList[i].apoloIsFavorite = apoloIsFavorite
        }
    }
    
    mutating func updateFavorite(name: String, isFavorite: Bool)
    {
        for i in 0..<self.apoloList.count
        {
            if apoloList[i].apoloTitle == name
            {
                apoloList[i].apoloIsFavorite = isFavorite
                
                break
            }
        }
    }
}

