//
//  ViewModelFactory+Mock.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation

extension ViewModelFactory {
    func makeMockStationsNetworkViewModel() -> StationsNetworkViewModel {
        return StationsNetworkViewModel(apiClient: MockAPIClient())
    }
}
