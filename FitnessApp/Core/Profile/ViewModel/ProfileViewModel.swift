//
//  ProfileViewModel.swift
//  FitnessApp
//
//  Created by mac on 4/20/25.
//

import SwiftUI
import Foundation

class ProfileViewModel: ObservableObject {

    // ➊ 直接把持久化值读进来，可选转非可选省心
    @Published var profileName:  String =
        UserDefaults.standard.string(forKey: "profileName")  ?? ""

    @Published var profileImage: String =
        UserDefaults.standard.string(forKey: "profileImage") ?? "avatar 1"

    @Published var currentName   = ""
    @Published var selectedImage = ""

    @Published var isEditingName  = false
    @Published var isEditingImage = false

    let images = (1...10).map { "avatar \($0)" }

    // MARK: - 状态切换
    func presentEditName()  { isEditingName = true;  isEditingImage = false
                              currentName   = profileName }         // 把旧名字带进输入框
    func presentEditImage() { isEditingName = false; isEditingImage = true
                              selectedImage = profileImage }        // 同理
    func dismissEdit()      { isEditingName = false; isEditingImage = false }

    // MARK: - 保存
    func setNewName() {
        guard !currentName.isEmpty else { return }
        profileName = currentName                           // ← 更新 @Published
        UserDefaults.standard.set(profileName, forKey: "profileName")
        dismissEdit()
    }

    func selectImage() {
        guard !selectedImage.isEmpty else { return }
        profileImage = selectedImage                        // ← 更新 @Published
        UserDefaults.standard.set(profileImage, forKey: "profileImage")
        dismissEdit()
    }
}
