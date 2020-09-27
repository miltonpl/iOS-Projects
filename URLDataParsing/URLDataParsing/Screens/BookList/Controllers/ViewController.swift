
import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView:UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.tableFooterView = UIView()
            self.tableView.register(BookListTableViewCell.nib(), forCellReuseIdentifier: BookListTableViewCell.identifier)
        }
    }
    
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    var dataSource = [ItemInfo] () {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Books"
        self.activityIndicator.startAnimating()
        self.getDataFromServer()
    }
    //MARK: - getDataFromServer Method
    func getDataFromServer() {
        
        let Url2 = "https://www.googleapis.com/books/v1/volumes?q=coding"
        guard let url = URL(string: Url2) else {return }
        ServiceManager.manager.request(url: url) { (data, error) in
            guard let dataObj = data as? Data else { return }
            do {
                let responseObj = try JSONDecoder().decode(APIResponse.self, from: dataObj)
                self.dataSource = responseObj.items ?? []
                self.activityIndicator.stopAnimating()
            }
            catch {
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    //MARK: - Cell For Row At Method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = dataSource[indexPath.row]
        guard let currentVolumeInfo = item.volumeInfo else {fatalError("Error getting volume info")}
        var cell:ListTableViewCell
        if indexPath.row < 5 {
            guard let cellA = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell  else
            { fatalError("Unable to dequeque cell") }
            cell = cellA
            
        } else {
            guard let cellB = tableView.dequeueReusableCell(withIdentifier: "BookListTableViewCell", for: indexPath) as? BookListTableViewCell else
            { fatalError("Unable to dequeque cell") }
            
            cell = cellB
        }
        cell.setProterties(item: currentVolumeInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    //MARK: - Did Select Row At Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard  let detailVC = storyboard.instantiateViewController(identifier: "DetailBookViewController") as? DetailBookViewController else {return }
        
        let item = self.dataSource[indexPath.row]
        guard let volumeInfo = item.volumeInfo else { fatalError("Not able to acces Volume info") }
        detailVC.volumeInfo = volumeInfo
        self.navigationController?.pushViewController(detailVC, animated: true)
    
    }
    
}
