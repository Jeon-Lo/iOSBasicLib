//
//  JSTabView.swift
//  editor
//
//  Created by Jeon on 2023/07/21.
//

import SwiftUI

protocol TabViewDelegate {
    func onEditMenuTapped(_ tabTag : String)
}

struct JSTabViewPreviews: View {
    @State private var tabSelection: TabBarItem = .home
    @Binding var isEditMode : Bool
    
    var body: some View {
        JSTabView(selection: $tabSelection, isEditMode: $isEditMode) {
//            HomeScreen()
//                .tabBarItem(tab: .home, selection: $tabSelection)
            
//            MyFilesScreen(isEditMode: $isEditMode)
//                .tabBarItem(tab: .myFiles, selection: $tabSelection)
            
//            FavoritesScreen(isEditMode: $isEditMode)
//                .tabBarItem(tab: .favorites, selection: $tabSelection)
            
//            SearchScreen()
//                .tabBarItem(tab: .search, selection: $tabSelection)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct JSTabViewPreviews_Previews: PreviewProvider {
    static var previews: some View {
        JSTabViewPreviews(isEditMode: .constant(false))
    }
}

struct JSTabView<Content: View>: View {
    let content: Content
    @Binding var selection: TabBarItem
    @Binding var isEditMode : Bool
    @State private var tabs: [TabBarItem] = [.home, .myFiles, .favorites, .home]
    @State private var editTabs: [TabBarItem] = [.merge, .share, .upload, .delete]
    private var delegator : TabViewDelegate?
    
    init(selection: Binding<TabBarItem>, isEditMode : Binding<Bool>, delegator : TabViewDelegate? = nil, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self._isEditMode = isEditMode
        self.delegator = delegator
        self.content = content()
    }
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                content
            }
            JSTabBarView(tabs: tabs, editTabs: editTabs, localSelection: selection, selection: $selection, isEditMode: $isEditMode, delegator: self.delegator)
        }
        .onPreferenceChange(TabBarItemPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

struct JSTabBarView : View {
    let tabs: [TabBarItem]
    let editTabs: [TabBarItem]
   
    @Namespace private var namespace
    @State var localSelection: TabBarItem
    @Binding var selection: TabBarItem
    @Binding var isEditMode : Bool
    var delegator : TabViewDelegate?
    
    var body: some View {
        if !isEditMode {
            VStack {
                HStack {
                    ForEach(tabs, id:\.self) { tab in
                        tabItemView(tab: tab)
                            .onTapGesture {
                                UIWindow.topViewController?.dismissKeyboard()
                                selection = tab
                            }
                            .frame(height: 32)
                            
                    }
                }
                .padding(.horizontal, 10)
            }
            .frame(height: 76)
            .background(RoundedRectangle(cornerRadius: 1)
                .fill( Color(hex:"#393A3E"))
                .shadow(color: Color(hex:"#000000", opacity: 0.25), radius: 2, x: 0, y: -4))
            .ignoresSafeArea(edges: .bottom)
            .onChange(of: selection) { newValue in
                localSelection = newValue
            }
        }
        else {
            VStack {
                HStack {
                    ForEach(self.editTabs, id:\.self) { tab in
                        editItemView(tab: tab)
                            .onTapGesture {
                                self.delegator?.onEditMenuTapped(String(describing: tab))
                            }
                            .frame(height: 32)
                            .opacity(self.hasPermission(tab) ? 1 : 0.3)
                            .disabled(!self.hasPermission(tab))
                    }
                }
                .padding(.horizontal, 10)
            }
            .frame(height: 76)
            .background(RoundedRectangle(cornerRadius: 1)
                .fill( Color(hex:"#3149AC"))
                .shadow(color: Color(hex:"#000000", opacity: 0.25), radius: 2, x: 0, y: -4))
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    private func hasPermission(_ tab : TabBarItem) -> Bool {
//        if tab == .upload && !Session.shared.hasPermission(.CLOUD) {
//            return false
//        }
//        if tab == .merge && !Session.shared.hasPermission(.EDIT) {
//            return false
//        }
        return true
    }
    
    private func tabItemView(tab: TabBarItem) -> some View {
        HStack {
            Image(localSelection == tab ? tab.iconName.sel : tab.iconName.nor)
                .font(.headline)
                .frame(width: 32, height: 32)
            Text(tab.title)
                .font(.system(size: 16, weight: .bold, design: .default))
        }
        .foregroundColor(localSelection == tab ?
                            Color(hex:"#8DA9FF") :
                            Color(hex:"#B0B0B0"))
        .frame(maxWidth: .infinity)
        .background(.clear)
//        .background(localSelection == tab ? tab.color.opacity(0.8) : .clear)
//        .cornerRadius(10)
    }
    
    private func editItemView(tab: TabBarItem) -> some View {
        HStack {
            Image(localSelection == tab ? tab.iconName.sel : tab.iconName.nor)
                .font(.headline)
                .frame(width: 32, height: 32)
            Text(tab.title)
                .font(.system(size: 16, weight: .bold, design: .default))
        }
        .foregroundColor(localSelection == tab ?
                            Color(hex:"#8DA9FF") :
                            Color(hex:"#B0B0B0"))
        .frame(maxWidth: .infinity)
        .background(.clear)
//        .background(localSelection == tab ? tab.color.opacity(0.8) : .clear)
//        .cornerRadius(10)
    }
}

struct TabBarItemPreferenceKey: PreferenceKey {
    static var defaultValue = [TabBarItem]()
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
        // appending not change
    }
}

struct TabBarItemViewModifier: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarItemPreferenceKey.self, value: [tab])
    }
}
