//
//  SearchCityViewController.swift
//  Weather-Cover
//
//  Created by Ahsan Khalil🤕 on 06/11/2020.
//

import UIKit
import Toast_Swift

class SearchCityViewController: UIViewController {
    static let identifier = "SearchCityViewController"
    @IBOutlet weak var searchBar: UISearchBar!
    public var completionHandler: ((String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension SearchCityViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if var providedCityName = searchBar.text {
            providedCityName = providedCityName.trimmingCharacters(in: .whitespacesAndNewlines)
            if providedCityName.isEmpty {
                self.view.makeToast("City Name Field is Empty", duration: 2.0, position: .center)
            } else {
                if completionHandler != nil {
                    completionHandler?(providedCityName)
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        print("cancel clicked")
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
