//
//  StationsNetworkView.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation
import SwiftUI

struct StationsNetworkView: View {
  @ObservedObject var viewModel:  StationsNetworkViewModel
    
  var body: some View {
    NavigationStack {
      switch viewModel.viewState {
      case .idle:
        placeholderView()
        
      case .loading:
        loaderView()
        
      case .showNetwork(let network):
        if network.stations.count > 0 {
          showStationsList(stations: network.stations)
        } else {
          emptyListView()
        }

//      case .showError(let errorMessage):
//        errorView(errorMessage: errorMessage)
      }
    }
    .task {
      viewModel.loadNetworkStations()
    }
    .alert(isPresented: $viewModel.alertModel.showAlert, content: { () -> Alert in
        Alert(
          title: Text(viewModel.alertModel.title),
          message: Text(viewModel.alertModel.message),
          dismissButton: .default(Text(Strings.Button.close)))
    })
  }
  
  // MARK: - Placeholder
  private func placeholderView() -> some View {
    EmptyView()
  }
  
  // MARK: - Loading
  private func loaderView() -> some View {
    ProgressView()
  }
  
  // MARK: - Empty list
  private func emptyListView() -> some View {
    Text(Strings.Screen.StationsList.noStations)
  }
  
  // MARK: - Stations list
  private func showStationsList(stations: [Station]) -> some View {
    List(stations.indices, id: \.self) { index in
      Text(stations[index].name)
    }
    .refreshable {
      viewModel.loadNetworkStations()
    }
  }
  
  // MARK: - Error
//  private func errorView(errorMessage: String) -> some View {
//    VStack(alignment: .center) {
//      Spacer()
//      Text(errorMessage)
//        .font(.headline.bold())
//        .multilineTextAlignment(.center)
//      Spacer()
//    }
//    .padding()
//  }
}

struct StationsNetworkView_Previews: PreviewProvider {
    static var previews: some View {
      StationsNetworkView(viewModel: ViewModelFactory.shared.makeMockStationsNetworkViewModel())
    }
}


