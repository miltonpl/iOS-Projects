

import UIKit


class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageBook:UIImageView!
    @IBOutlet weak var titleBook:UILabel!
    @IBOutlet weak var subtitleBook:UILabel!
    
    func setProterties( item: VolumeInfo){
        imageBook.layer.cornerRadius = imageBook.frame.width/2
        imageBook.layer.borderWidth = 2
        imageBook.layer.borderColor = UIColor.black.cgColor
        imageBook.layer.backgroundColor = UIColor.green.cgColor
        
        titleBook.text = item.title
        subtitleBook.text = item.subtitle
        subtitleBook.isHidden = item.subtitle?.isEmpty ?? true
        
        guard let thumbNail = item.imageLinks?.smallThumbnail, let url = URL(string: thumbNail) else { return }
        self.imageBook.downloadImage(with: url)
    }
    
}

extension UIImageView {
    
    func downloadImage(with url: URL){
        DispatchQueue.global().async {
            do {
                //convert data to UIImage
                let data  = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            catch {
                print(error)
            }
        }
    }
}
