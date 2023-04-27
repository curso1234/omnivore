import Models
import SwiftUI
import Utils
import Views
import Services
import CoreData
import Models

final class NavigationModel: ObservableObject {
  @Published var linkedItemFilter = LinkedItemFilter.inbox.rawValue
  @Published var activeLabels = Set<LinkedItemLabel>()
  @Published var detailViewNavigation = DetailViewNavigation.empty
}

enum DetailViewNavigation: Equatable {
  case empty
  case savedItemObject(objectID: NSManagedObjectID)
  case savedItemPDFObject(objectID: NSManagedObjectID)
  case requestLink(requestID: String)
  
  var objectID: NSManagedObjectID? {
    switch self {
    case .empty, .requestLink:
      return nil
    case .savedItemObject(objectID: let objectID):
      return objectID
    case .savedItemPDFObject(objectID: let objectID):
      return objectID
    }
  }
}

@available(iOS 16.0, *)
public struct RootSplitView: View {
  @StateObject private var labelsViewModel = LabelsViewModel()
  @StateObject private var libraryViewModel = LibraryViewModel()
  @StateObject private var navigationModel = NavigationModel()

  public var body: some View {
    NavigationSplitView {
      SplitViewSidebar(
        libraryViewModel: libraryViewModel,
        navigationModel: navigationModel,
        labelsViewModel: labelsViewModel
      )
    } content: {
      SplitViewContent(
        libraryViewModel: libraryViewModel,
        navigationModel: navigationModel
      )
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("Library")
    } detail: {
      DetailView(navigation: navigationModel.detailViewNavigation)
    }
    .accentColor(.appGrayTextContrast)
    .navigationBarTitleDisplayMode(.inline)
  }
}

private struct DetailView: View {
  let navigation: DetailViewNavigation
  
  var body: some View {
    switch navigation {
    case .empty:
      Text(LocalText.navigationSelectLink)
    case .savedItemObject(let objectID):
      LinkedItemDetailView(linkedItemObjectID: objectID)
    case .savedItemPDFObject(let objectID):
      PDFDetailView(pdfObjectID: objectID)
    case .requestLink(let requestID):
      Text(requestID)
    }
  }
}