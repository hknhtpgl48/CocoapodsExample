import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var redView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = Asset.ies3.image
    }
    
    //MARK: - KingFisher
    
    func setImageViaKingFisher() {
        imageView.kf.setImage(with: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlVxhG1HeyS6lkarVsOCdw42yiuQXziBy77Q&usqp=CAU"))
    }
    
    func setImageViaAlamofire() {
        let url = URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlVxhG1HeyS6lkarVsOCdw42yiuQXziBy77Q&usqp=CAU")
        let cache = NSCache<AnyObject, AnyObject>()
        if let imageFromCache = cache.object(forKey: url as AnyObject) as? UIImage {
            imageView.image = imageFromCache
            return
        }
        AF.request(url!, method: .get).response { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let data):
                guard let data = data,
                      let image = UIImage(data: data) else {
                    return
                }
                cache.setObject(image, forKey: url as AnyObject)
                self.imageView.image = image
            }
        }
    }
    
    //MARK: - Snapkit
    
    func setConstraintsViaSnapKit() {
        redView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(256.0)
            make.height.equalTo(128.0)
        }
    }
    
    func setConstraintsViaLayout() {
        redView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            redView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            redView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            redView.heightAnchor.constraint(equalToConstant: 128.0),
            redView.widthAnchor.constraint(equalToConstant: 256.0)
        ])
    }
    //MARK: -Alamofire
    
    func fetchWithAlamofire() {
        AF.request("https://httpbin.org/get").response { response in
            debugPrint(response)
        }
    }
    
    func fetchWithURLSession() {
        let url = URL(string: "https://stackoverflow.com")
        let request = URLRequest(url: url!)
        //Task oluşturma
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            print(String(data: data, encoding: .utf8) ?? "Data not found or Not in correct format.")
        }
        //Task çalıştırma
        task.resume()
    }
    
    func fetchWithAlamofire2() {
        // Servis isteğini oluşturuyoruz.
        let request = AF.request("http://www.stackoverflow.com")
        // Servis istediğini gerçekleştiriyoruz ve dönecek cevap JSON tipinde olacağından responseJSON metodu ile cevabı karşılıyoruz.
        request.responseJSON { (data) in
            print(data)
        }
        
    }
    
}

