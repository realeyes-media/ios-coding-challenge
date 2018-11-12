//
//  ContentSelectorTableViewController.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/11/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

let kShowItemDetailSegueIdentifier = "ShowItemDetail"
let kContenItemCellIdentifier = "ContentItem"

class ContentSelectorTableViewController: UITableViewController {
    
    let viewModel = ContentSelectorViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        viewModel.getItems()
    }
    
    private func addObservers() {
        viewModel.contentItems.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: kContenItemCellIdentifier)) { _, item, cell in
                guard let cell = cell as? ContentItemTableViewCell else { fatalError("Could not dequeue cell with identifier: \(kContenItemCellIdentifier)") }
                cell.item = item
            }
            .disposed(by: disposeBag)
        
        let itemSelected = tableView.rx.itemSelected
        let itemSelected$ = itemSelected.asObservable()
        
        itemSelected$
            .map { [weak self] indexPath -> ContentItem? in
                guard let cell = self?.tableView.cellForRow(at: indexPath) as? ContentItemTableViewCell else { fatalError("Could not dequeue cell at indexPath: \(indexPath)") }
                return cell.item
            }
            .subscribe(onNext: { [weak self] (item: ContentItem?) in
                self?.viewModel.updateSelectedItem(item: item)
            })
            .disposed(by: disposeBag)
    }

}
