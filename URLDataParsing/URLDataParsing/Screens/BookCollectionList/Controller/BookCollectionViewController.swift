//
//  BookCollectionViewController.swift
//  URLDataParsing
//
//  Created by Milton Palaguachi on 9/23/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class BookCollectionViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    private var dataSource = [ItemInfo] () {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .init(white: 1, alpha: 0.8)
        self.showSpinner()
        self.fetchData()
    }
}

extension BookCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected ", indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard  let detailVC = storyboard.instantiateViewController(identifier: "DetailBookViewController") as? DetailBookViewController else {return }
               
        let item = self.dataSource[indexPath.row]
        guard let volumeInfo = item.volumeInfo else { fatalError("Not able to acces Volume info") }
        detailVC.volumeInfo = volumeInfo
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
extension BookCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCoverCollectionViewCell", for: indexPath) as? BookCoverCollectionViewCell,
            let volumeInfo = dataSource[indexPath.row].volumeInfo else{
            fatalError("Unable to dequeueReusableCell in CollectionView")
        }
        
        cell.configure(volumeInfo: volumeInfo)
        return cell
        
    }
    
    
}
extension BookCollectionViewController {
    //MARK: - getDataFromServer Method
       func fetchData() {
           
           let Url2 = "https://www.googleapis.com/books/v1/volumes?q=coding"
           guard let url = URL(string: Url2) else {return }
           ServiceManager.manager.request(url: url) { (data, error) in
               guard let dataObj = data as? Data else { return }
               do {
                   let responseObj = try JSONDecoder().decode(APIResponse.self, from: dataObj)
                   self.dataSource = responseObj.items ?? []
                   self.removeSpinner()

               }
               catch {
                   print(error)
               }
           }
       }
}
