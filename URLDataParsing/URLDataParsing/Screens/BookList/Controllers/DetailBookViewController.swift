//
//  DetailBookViewController.swift
//  URLDataParsing
//
//  Created by Milton Palaguachi on 9/22/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit
enum nameLabel:String {
    case title = "Title"
    case subtitle = "Subtitle"
    case author = "Author"
    case publisher = "Publisher"
    case publishedDate = "Published Date"
    case description = "Description"
    case pageCount = "Page Count"
    case averageRating = "Average Rating"
    case language = "Language"
}

class DetailBookViewController: UIViewController {
    
    @IBOutlet private weak var bookImageView: UIImageView!
    @IBOutlet weak var detailTableView:UITableView! {
        didSet {
            detailTableView.tableFooterView = UIView()
        }
    }
    var previewLink:String?
    var volumeInfo: VolumeInfo?
    var nameArray = [nameLabel]() {
        didSet {
            detailTableView.reloadData()
            }
        }
    var dictArray = [nameLabel: String]() {
        didSet {
            detailTableView.reloadData()
            }
        }
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setProperties()
        self.setupDetailTableView()
        }
        // MARK: - Set Properties
    @objc func webSearch (_ sender: UIBarButtonItem){
        guard let url = URL(string: previewLink ?? "") else {return}
        
        UIApplication.shared.open(url)
    }
    func setProperties() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(webSearch(_:)))
        //Fill up only data available
        if let volume = volumeInfo {
            if let title = volume.title{
                dictArray[.title] = title
                nameArray.append(.title)
            }
            if let subtitle = volume.subtitle {
                dictArray[.subtitle] = subtitle
                nameArray.append(.subtitle)
            }
            if let author = volume.authors {
                dictArray[.author] = author.joined(separator: " ")
                nameArray.append(.author)
            }
            if let publisher = volume.publisher {
                dictArray[.publisher] = publisher
                nameArray.append(.publisher)
            }
            if let publishedDate = volume.publishedDate {
                dictArray[.publishedDate] = publishedDate
                nameArray.append(.publishedDate)
            }
            if let description = volume.description {
                dictArray[.description] = description
                nameArray.append(.description)
            }
            if let count = volume.pageCount {
                dictArray[.pageCount] = "\(count)"
                nameArray.append(.pageCount)
            }
            if let averageRating = volume.averageRating {
                dictArray[.averageRating] = "\(averageRating)"
                nameArray.append(.averageRating)
            }
            if let language = volume.language {
                dictArray[.language] = language
                nameArray.append(.language)
            }
            if let previewLink = volume.previewLink {
                self.previewLink = previewLink
            }
            guard let thumbNail = volume.imageLinks?.smallThumbnail, let url = URL(string: thumbNail) else { return }
            bookImageView.downloadImage(with: url)
        }
    }
    //MARK: - TableView Setup
    func setupDetailTableView() {
        detailTableView.rowHeight = UITableView.automaticDimension
        detailTableView.estimatedRowHeight = 50
        detailTableView.allowsSelection = false
        detailTableView.tableFooterView = UIView()
    }
}

extension DetailBookViewController: UITableViewDelegate {
   
}
extension DetailBookViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nameArray.count
    }
    //MARK: - CellForRowAt Method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = detailTableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else {
            fatalError("Unable to dequeue DetailTableViewCell")
        }
        let type = nameArray[indexPath.row]
        guard let data = dictArray [type] else {fatalError("Fatal Erro")}
        let labelName = type.rawValue
        cell.setupProperties(name: labelName, data: data)
        return cell
    }
    

}
