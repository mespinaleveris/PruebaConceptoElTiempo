//
//  ApoloListViewController.swift
//  PruebaConceptoElTiempo
//
//  Created by mespinal on 5/03/21.
//

import UIKit
import Kingfisher
import MBProgressHUD

protocol ApoloListViewProtocol
{
    func updateFavoriteInRow(name: String, isFavorite: Bool, indexPath: IndexPath)
}

class ApoloListViewController: UIViewController
{
    @IBOutlet weak var apoloListTableView: UITableView!
    @IBOutlet weak var apoloListSearchBar: UISearchBar!
    
    private(set) var apoloViewModel: ApoloViewModel?
    
    var apoloList: [ApoloModel] = [] {
        didSet {
            self.apoloViewModel = ApoloViewModel.init(apoloList: apoloList)
            
            DispatchQueue.main.async {
                ApoloModel.saveApoloList(apoloList: self.apoloViewModel?.apoloList)
                self.apoloListTableView.reloadData()
            }
        }
    }
    
    
    var searchedApoloList: [ApoloModel] = []
    var searching: Bool = false
    var filtered:[String] = []
    var indexPath = IndexPath()
    
    var apoloItemSelected = ApoloModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.apoloListTableView.alwaysBounceVertical = true
        self.apoloListSearchBar.showsCancelButton = true
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.getSavedList()
    }
}

// SearchBar Delegate
extension ApoloListViewController: UISearchBarDelegate
{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchedApoloList.removeAll()
        
        for apoloItem in (self.apoloViewModel?.apoloList)!
        {
            if apoloItem.apoloKeywords!.filter({ $0.lowercased().prefix(searchText.count) == searchText.lowercased() }).count > 0
            {
                self.searchedApoloList.append(apoloItem)
            }
        }
        
        searching = true
        
        apoloListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        apoloListTableView.reloadData()
    }
}

// TableView Delegate
extension ApoloListViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if searching
        {
            return searchedApoloList.count
        }
        else
        {
            return self.apoloList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var apoloItem: ApoloModel = ApoloModel()
        
        if searching
        {
            apoloItem = self.searchedApoloList[indexPath.row]
        }
        else
        {
            apoloItem = (self.apoloViewModel?.apoloList[indexPath.row])!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApoloViewCell", for: indexPath) as! ApoloViewCell
        
        cell.selectionStyle = .none
        
        let apoloData: ApoloDataModel = (apoloItem.apoloDataList?[0])!
        let apoloLinkList: [ApoloLinksModel] = apoloItem.apoloLinks ?? []
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.titleText = apoloData.apoloDataTitle ?? ""
        cell.isFavorite = apoloItem.apoloIsFavorite!
        
        if let apoloLink = apoloLinkList.filter({ $0.apoloLinkRel == "preview" }).first
        {
            if let url = URL(string: apoloLink.apoloLinkUrl!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            {
                cell.apoloImage.kf.setImage(with: url, options: [
                    .transition(.fade(0.5))
                ])
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.searching
        {
            self.apoloItemSelected = self.searchedApoloList[indexPath.row]
            self.indexPath = indexPath
        }
        else
        {
            self.apoloItemSelected = (self.apoloViewModel?.apoloList[indexPath.row])!
            self.indexPath = indexPath
        }
        
        performSegue(withIdentifier: "segueToDetailApolo", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
}

// Get Data Methods
extension ApoloListViewController
{
    func getSavedList()
    {
        let apoloListFromSaved = ApoloModel.loadApoloList()
        
        if apoloListFromSaved.count > 0
        {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            self.apoloList = apoloListFromSaved
            
            print("LISTA CARGADA DE LA MEMORIA")
            
            self.apoloListTableView.reloadData()
        }
        else
        {
            self.getApoloList()
            
            print("CARGANDO LISTA DESDE EL API")
        }
    }
    
    func getApoloList()
    {
        ConnectionManager.shareInstance.getApoloList() { (response, error) in
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            if let apoloList = response?.collecctionApolo?.apoloItems
            {
                self.apoloList = apoloList
            }
            
            if let error = error
            {
                print("Error al intentar traer la lista: \(error.localizedDescription)")
            }
        }
    }
}

// Favorite protocol
extension ApoloListViewController: ApoloListViewProtocol
{
    func updateFavoriteInRow(name: String, isFavorite: Bool, indexPath: IndexPath)
    {
        self.apoloViewModel?.updateFavorite(name: name, isFavorite: isFavorite)
        
        if searching
        {
            for i in 0..<self.searchedApoloList.count
            {
                if searchedApoloList[i].apoloTitle == name
                {
                    searchedApoloList[i].apoloIsFavorite = isFavorite
                    
                    break
                }
            }
        }
        
        DispatchQueue.main.async {
            
            ApoloModel.saveApoloList(apoloList: self.apoloViewModel?.apoloList)
            self.apoloListTableView.reloadRows(at: [indexPath], with: .none)
        }
        
    }
}

// Prepare for Segue
extension ApoloListViewController
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "segueToDetailApolo"
        {
            let detailApoloViewController = segue.destination as! DetailApoloViewController
            detailApoloViewController.delegate = self
            detailApoloViewController.indexPath = self.indexPath
            detailApoloViewController.apoloItem = self.apoloItemSelected
        }
    }
}

