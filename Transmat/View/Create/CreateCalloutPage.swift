//
//  CreateCalloutPage.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-11.
//

import SwiftUI
import UniformTypeIdentifiers

struct CreateCalloutPage: View {
    @StateObject var viewModel = ViewModel()
    @Environment(\.design) var design
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.managedObjectContext) var context
    @Environment(\.editMode) var editMode

    @Binding var selectedPage: CalloutPage?

    @State var pageTitle = ""
    @State var calloutDescription = ""
    @State var calloutAction = ""
    @State var imageType: ImageType = .color
    @State var localImage: UIImage?
    @State var color: Color = .green
    @State var url: String = ""
    @State var showImagePicker = false
    @State var networkImageSuccess = false

    @State var showSaveTooltip = false
    @State var showAddTooltip = false

    @State var dragging: Callout?
    @State var hasChangedLocation = false

    var body: some View {
        HorizontalAdapter {
            Form {
                TextField("create-page-title", text: $pageTitle)
                    .font(.system(size: 18))

                descriptionSection

                imageSection

                HStack(spacing: 4) {
                    Button(action: addCallout) {
                        Label("create-add-callout-button", systemImage: "plus.app")
                    }
                    .disabled(!canAddCallout)
                }
            }.sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $localImage)
            }.toolbar {
                HStack {
                    if editMode?.wrappedValue.isEditing != true {
                        Button(action: savePage) {
                            Text("create-save-callout-page-button")
                        }
                        .disabled(!canSavePage)
                    }

                    EditButton()
                }
            }

            Divider()

            calloutGrid
        }
        .navigationBarTitle("create-page-navigation-title")
    }

    @ViewBuilder
    var descriptionSection: some View {
        Section("create-description-section-title") {
            TextField("create-callout-description", text: $calloutDescription)
            if descriptionExistsInPage {
                Label("create-description-exists", systemImage: "exclamationmark.triangle")
                    .accentColor(.red)
            }

            TextField("create-callout-action", text: $calloutAction)
        }
    }

    @ViewBuilder
    var imageSection: some View {
        Section("create-image-section-title") {
            HStack {
                Text("create-image-type")

                Spacer()

                Picker("create-image-type", selection: $imageType) {
                    ForEach(ImageType.allCases) { type in
                        Text(type.localizedKey).tag(type)
                    }
                }.pickerStyle(.menu)
            }

            if imageType == .localImage {
                HStack {
                    Button(action: { showImagePicker.toggle() }) {
                        Text("create-image-picker")
                    }

                    Spacer()

                    if let image = localImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .aspectRatio(contentMode: .fill)
                    }
                }
            } else if imageType == .color {
                ColorPicker("create-color-picker", selection: $color)
            } else if imageType == .networkImage {
                HStack {
                    TextField("create-url-value", text: $url)
                    if let url = URL(string: url) {
                        AsyncImage(url: url) { state in
                            switch state {
                            case .empty, .failure:
                                Text("create-invalid-url")
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .aspectRatio(contentMode: .fill)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    var calloutGrid: some View {
        GeometryReader { proxy in
            LazyVGrid(columns: gridItems(height: Int(proxy.size.height),
                                         width: Int(proxy.size.width),
                                         itemCount: viewModel.callouts.count,
                                         padding: Int(design.spacing * 2)),
                      spacing: design.spacing) {
                ForEach(viewModel.callouts) { callout in
                    ZStack(alignment: .topTrailing) {
                        CalloutView(callout: callout)

                        if editMode?.wrappedValue.isEditing == true {
                            Button(action: {
                                viewModel.callouts.removeAll(where: { $0 == callout })
                            }) {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.red)
                                    .font(.system(size: 24))
                                    .background(Circle()
                                        .foregroundColor(.init(white: 0.5,
                                                               opacity: 0.5))
                                            .blur(radius: 8))
                                    .offset(x: 6, y: -12)
                            }
                        }
                    }
                    .onDrag {
                        dragging = callout
                        return NSItemProvider(object: callout.display as NSItemProviderWriting)
                    }
                    .onDrop(
                        of: [UTType.text],
                        delegate: DragRelocateService(
                            item: callout,
                            listData: $viewModel.callouts,
                            current: $dragging,
                            hasChangedLocation: $hasChangedLocation
                        ) { from, to in
                            withAnimation {
                                viewModel.callouts.move(fromOffsets: from,
                                                        toOffset: to)
                            }
                        }
                    )
                }
            }.padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    func addCallout() {
        let callout = Callout(context: context)
        let image = CalloutImage(context: context)

        switch imageType {
        case .localImage:
            image.imageType = ImageType.localImage.rawValue
            image.imageData = localImage?.pngData()
            callout.action = calloutAction
            callout.display = calloutDescription
            callout.image = image
        case .networkImage:
            image.imageType = ImageType.networkImage.rawValue
            image.url = URL(string: url)
            callout.action = calloutAction
            callout.display = calloutDescription
            callout.image = image
        case .color:
            image.imageType = ImageType.color.rawValue
            image.colorData = try? JSONEncoder().encode(color)
            callout.action = calloutAction
            callout.display = calloutDescription
            callout.image = image
        }

        withAnimation {
            viewModel.callouts.append(callout)
            calloutDescription = ""
            calloutAction = ""
        }
    }

    func savePage() {
        do {
            let page = CalloutPage(context: context)
            page.title = pageTitle
            let _ = viewModel.callouts.map(page.addToCallouts(_:))
            try context.save()
            selectedPage = page
        } catch let error {
            debugPrint(error)
        }
    }

    var canSavePage: Bool {
        !viewModel.callouts.isEmpty &&
        !pageTitle.isEmpty
    }

    var descriptionExistsInPage: Bool {
        viewModel.callouts.contains(where: { $0.description == calloutDescription })
    }

    var canAddCallout: Bool {
        guard !calloutDescription.isEmpty, !descriptionExistsInPage else { return false }

        switch imageType {
        case .localImage:
            return localImage != nil
        case .color:
            return true
        case .networkImage:
            return URL(string: url) != nil
        }
    }
}

struct CreateCalloutPage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                CreateCalloutPage(selectedPage: .constant(nil))
            }
            .navigationViewStyle(.stack)
            .previewInterfaceOrientation(.portraitUpsideDown)
            NavigationView {
                CreateCalloutPage(selectedPage: .constant(nil))
            }
            .preferredColorScheme(.dark)
            .navigationViewStyle(.stack)
            .previewInterfaceOrientation(.landscapeLeft)
            NavigationView {
                CreateCalloutPage(selectedPage: .constant(nil))
            }
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .navigationViewStyle(.stack)
            .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
