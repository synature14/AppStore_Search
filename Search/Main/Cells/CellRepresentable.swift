//
//  CellRepresentable.swift
//  Search
//
//  Created by Suvely on 2021/12/31.
//


import UIKit

protocol TableCellRepresentable {
    var cellType: UITableViewCell.Type { get }
}

protocol BindableTableViewCell: UITableViewCell {
    func bindCellVM(_ cell: TableCellRepresentable?)
}

enum SearchCellType {
    case allResultsCell(RecentSearchHistoryCellViewModel)       // 앱 기동시 core data에 저장된 기록 나열
    case searchResultsCell(RecentSearchHistoryCellViewModel)    // searchBar에 텍스트 editing할때 나열될 셀
    
    // '검색' 버튼 눌렀을때 결과 뿌려주는 셀
    case appIconCell(ResultCellViewModel)
    case landScapeScreenShotCell            // 스크린샷이 1장(landscape 모드)
    case portaitScreenShotCell              // 스크린샷 2장 이상 (portrait 모드)
    case noResultsCell
}
