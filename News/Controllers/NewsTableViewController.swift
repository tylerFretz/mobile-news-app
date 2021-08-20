//
//  NewsTableViewController.swift
//  News
//
//  Created by user198890 on 7/28/21.
//

import UIKit

class NewsTableViewController: UITableViewController {
    // API services class instance
    let api = ArticlesAPI()
    // array of Article objects to be displayed in the table
    var articles: [Article] = []
  
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var userPrefsButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // fetch articles from API on view Will Appear
    // this allows app to refetch articles as user switches between views
    override func viewWillAppear(_ animated: Bool) {
        // fetch articles from the News API
        api.fetchArticles() { (articles) in
            self.articles = articles
            self.tableView.reloadData()
        }
        
        // Setting Navigation bar title / subtitle based on current selected country / category
        let country = UserDefaults.standard.string(forKey: "country") ?? ""
        let category = UserDefaults.standard.string(forKey: "category") ?? ""
        let titleLabel = UILabel()
        let subtitleLabel = UILabel()
        titleLabel.text = "News"
        subtitleLabel.text = "\(country) - \(category)"
        subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        let titleView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleView.axis = .vertical
        titleView.alignment = .center
        navigationItem.titleView = titleView
    }


    // MARK: - Table view data source
    
    // setting cell count. Display empty message if no articles
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articles.count == 0 {
            tableView.setEmptyMessage("No articles match that keyword")
        } else {
            tableView.restore()
        }
        return articles.count
    }

    // attach article data to each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        let article = articles[indexPath.row]
        
        cell.source.text = article.source.name
        cell.title.text = article.title
        cell.subtitle.text = article.description
        let dateString = String(article.publishedAt.prefix(10))
        cell.publishedDate.text = dateString
        
        // if api response for this article included a link to an image, get that image
        // else use default image
        if article.urlToImage != nil && verifyURL(urlString: article.urlToImage) == true {
            let imageUrl = URL(string: article.urlToImage ?? "")
            var request = URLRequest(url: imageUrl! )
            request.httpMethod = "GET"

            URLSession.shared.dataTask(with: request) { data, respond, error in
                guard let data = data else { return }
                    DispatchQueue.main.async {
                        cell.articleImage.image = UIImage(data: data)
                    }
            }.resume()
        } else {
            cell.articleImage.image = UIImage(named: "No_Image_Available")
        }
        return cell
    }

    
    // MARK: - Navigation
    
    // show webview when cell is tapped on
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = articles[indexPath.row]
        
        if let viewController = self.storyboard?.instantiateViewController(identifier: "WebViewController") as? WebViewController {
            viewController.url = URL(string: selectedArticle.url)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // segue to user preferences view on nav bar button click
    @IBAction func userPrefsTapped() {
        performSegue(withIdentifier: "showPrefs", sender: nil)
    }
        
    // segue to map view on nav bar button click
    @IBAction func mapTapped(_ sender: Any) {
        performSegue(withIdentifier: "showMap", sender: nil)
    }

    
    
    // MARK: - Utils
    
    // verifies that urls returned from the News API can be accessed
    func verifyURL (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}

// extension function to call News API keyword query on search button tapped
extension NewsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil && !searchBar.text!.isEmpty  {
            api.queryArticlesByKeyword(keyword: searchBar.text!) { (articles) in
                self.articles = articles
                self.tableView.reloadData()
                self.navigationItem.titleView = nil
                self.navigationItem.title = "News"
            }
        } else {
            api.fetchArticles() { (articles) in
                self.articles = articles
                self.tableView.reloadData()
            }
        }
    }
}
