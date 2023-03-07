//
//  ViewController.swift
//  soyfri
//
//  Created by Jordy Gonzalez on 3/6/23.
//

import UIKit
import Combine
import AlamofireImage

class ViewController: UIViewController {
    
    let viewModel = MealViewModel(apiClient: ApiClient.default)
    var cancellable: Set<AnyCancellable> = []
    
    let mealsTableView  = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UINib(nibName: "MealCell", bundle: nil),
                           forCellReuseIdentifier: MealCell.mealCellIdentifier)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let loaderIndicator = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    func setupUI() {
        view.addSubview(mealsTableView)
        view.addSubview(loaderIndicator)
        
        mealsTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mealsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mealsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mealsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        loaderIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loaderIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        mealsTableView.dataSource = self
        mealsTableView.delegate = self
    }

    func bindViewMode() {
        viewModel.objectWillChange.sink { [weak self] _ in
            guard let self = self else { return }
            
            if let err = self.viewModel.error {
                print(err.localizedDescription)
            } else {
                if !self.viewModel.isLoading {
                    self.loaderIndicator.stopAnimating()
                    self.mealsTableView.reloadData()
                } else {
                    self.loaderIndicator.startAnimating()
                }
            }
        }.store(in: &cancellable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewMode()
        viewModel.fetchMeals()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return max(tableView.frame.height, tableView.frame.width) / 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.mealList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meal = self.viewModel.mealList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.mealCellIdentifier, for: indexPath) as! MealCell
        cell.setupUI(meal: meal)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
         let contentYoffset = scrollView.contentOffset.y
         let distanceFromBottom = scrollView.contentSize.height - contentYoffset
         if distanceFromBottom < height {
             viewModel.fetchMeals()
         }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = self.viewModel.mealList[indexPath.row]
        
        if let url = URL(string: meal.youtubeUrl ?? "") {
            UIApplication.shared.open(url)
        }
    }
}

extension ViewController: UITableViewDelegate {
    
}
