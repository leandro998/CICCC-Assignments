//
//  RestaurantTableViewController.swift
//  MyRestaurants
//
//  Created by Leandro Prado on 2020-08-19.
//  Copyright © 2020 Leandro Prado. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    
    private var cellId = "RestaurantCell"
    private var restaurants: [Restaurants] = Restaurants.restaurants()
    private var filterRestaurants: [Restaurants] = []
    private var searchController = UISearchController(searchResultsController: nil)
    
    private var searchFooter: SearchFooter!
    private var searchFooterBottomConstraint: NSLayoutConstraint!
    
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
      return searchController.isActive && (!isSearchBarEmpty || searchController.searchBar.selectedScopeButtonIndex != 0)
    }
    
    //view controller life cycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //navigation title:
        let titleImageView = UIImageView(image: UIImage(named: "banner"))
        titleImageView.contentMode = .scaleAspectFit
//        titleImageView.constraintWidth(equalToConstant: 150, heightEqualToConstant: 33)
        navigationItem.titleView = titleImageView

        /// TableView
        setupTableView()
        
        /// SearchBar
        setupSearchController()
        setupSearchFooter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //Helper:
    
    private func setupTableView() {
      tableView = UITableView()
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(RestaurantsSubtitleTableViewCell.self, forCellReuseIdentifier: cellId)
      view.addSubview(tableView)
      tableView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func setupSearchController() {
      navigationItem.searchController = searchController
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "Search Restaurant"
//      searchController.searchResultsUpdater = self
//      searchController.searchBar.delegate = self
      // ensure that the search bar doesn't remain on the screen if the user navigates to another view controller while the UISearchController is active
      definesPresentationContext = true
      
      searchController.searchBar.scopeButtonTitles = Restaurants.Category.allCases.map { $0.rawValue }
      
      let notificationCenter = NotificationCenter.default
      notificationCenter.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) {
        self.handleKeyboard(notification: $0)
      }
      notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) {
        self.handleKeyboard(notification: $0)
      }
    }
    
       private func setupSearchFooter() {
         searchFooter = SearchFooter()
         view.addSubview(searchFooter)
         searchFooter.constraintHeight(equalToConstant: 44)
         let constraints = searchFooter.anchors(topAnchor: nil, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor)
         searchFooterBottomConstraint = constraints.bottom
       }
    
    private func filterRestaurants(searchText: String, category: Restaurants.Category? = nil) {
    filterRestaurants = restaurants.filter { (restaurants) in
      let isCategoryMatching = category == .all || category == restaurants.category
      if isSearchBarEmpty {
        return isCategoryMatching
      } else {
        return isCategoryMatching && restaurants.name.lowercased().contains(searchText.lowercased())
      }
    }
        
        isFiltering ? searchFooter.isFilteringToShow(filteredItemCount: filterRestaurants.count, of: restaurants.count) : searchFooter.isNotFiltering()
          
          tableView.reloadData()
        }
    
    private func handleKeyboard(notification: Notification) {
      guard notification.name == UIResponder.keyboardDidShowNotification else {
        // keyboardWillHideNotification
        searchFooterBottomConstraint.constant = 0
        view.layoutIfNeeded()
        return
      }
      // keyboardDidShowNotification
      guard
        let info = notification.userInfo,
        let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
      
      let keyboardHeight = keyboardFrame.cgRectValue.size.height
      
      self.searchFooterBottomConstraint.constant = -keyboardHeight
      UIView.animate(withDuration: 0.1) {
        self.view.layoutIfNeeded()
      }
    }
    
    //table view data source:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return isFiltering ? filterRestaurants.count : restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RestaurantsSubtitleTableViewCell
      let restaurant = isFiltering ? filterRestaurants[indexPath.row] : restaurants[indexPath.row]
      cell.textLabel?.text = restaurant.name
      cell.detailTextLabel?.text = restaurant.category.rawValue
      return cell
    }
    
    //table view delegate
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurantsDetailVC = RestaurantsDetailViewController()
        restaurantsDetailVC.restaurants = isFiltering ? filterRestaurants[indexPath.row] : restaurants[indexPath.row]
        navigationController?.pushViewController(restaurantsDetailVC, animated: true)
      }
      
    }

    // UI Search results updating:

    extension RestaurantTableViewController: UISearchResultsUpdating {
      func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let category = Restaurants.Category(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        filterRestaurants(searchText: searchBar.text!, category: category)
      }
    }

    extension RestaurantTableViewController: UISearchBarDelegate {
      func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = Restaurants.Category(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterRestaurants(searchText: searchBar.text!, category: category)
      }
    }
