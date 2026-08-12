//
//  AddCandidateView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 12/08/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct AddCandidateView: View {

    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var candidateViewModel: CandidateViewModel

    let defaultJob: JobEntity?
    var defaultStage: PipelineStage = .applied

    @State private var name = ""
    @State private var role = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var stage: PipelineStage = .applied
    @State private var experience = ""
    @State private var matchScore = 75
    @State private var showFileImporter = false
    @State private var resumeData: Data?
    @State private var resumeFileName: String?

    var body: some View {

        Form {

            Section("Basic Details") {

                TextField("Full Name", text: $name)

                TextField("Role", text: $role)

                TextField("Experience (e.g. 3 Yrs Exp)", text: $experience)
            }

            Section("Contact Details") {

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)

                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)
            }

            Section("Pipeline") {

                Picker("Stage", selection: $stage) {

                    ForEach(PipelineStage.allCases, id: \.self) { stage in
                        Text(stage.title).tag(stage)
                    }
                }

                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {

                    HStack {

                        Text("Match Score")
                            .font(.subheadline)

                        Spacer()

                        Text("\(matchScore)%")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color("textSecondary"))
                    }

                    Slider(
                        value: Binding(
                            get: { Double(matchScore) },
                            set: { matchScore = Int($0) }
                        ),
                        in: 0...100,
                        step: 1
                    )
                    .tint(Color("textSecondary"))
                }
            }

            Section("Resume") {

                Button {
                    showFileImporter = true
                } label: {

                    HStack(spacing: 10) {

                        Image(
                            systemName:
                                resumeData == nil
                                ? "doc.badge.plus"
                                : "doc.fill"
                        )
                        .font(.body)

                        Text(
                            resumeFileName
                                ?? "Attach Resume (PDF)"
                        )
                        .font(.subheadline)
                        .lineLimit(1)

                        Spacer()

                        if resumeData != nil {

                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    .foregroundStyle(
                        Color("textSecondary")
                    )
                }
            }

            Section {

                Button {
                    saveCandidate()
                } label: {

                    Text("Add Candidate")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .disabled(
                    name.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty
                )
            }
        }
        .navigationTitle("New Candidate")
        .navigationBarTitleDisplayMode(.inline)
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.pdf, .plainText],
            allowsMultipleSelection: false
        ) { result in

            switch result {

            case .success(let urls):

                guard let url = urls.first,
                      url.startAccessingSecurityScopedResource() else {
                    return
                }

                defer {
                    url.stopAccessingSecurityScopedResource()
                }

                if let data = try? Data(contentsOf: url) {

                    resumeData = data
                    resumeFileName = url.lastPathComponent
                }

            case .failure:
                break
            }
        }
        .onAppear {

            if role.isEmpty {
                role = defaultJob?.title ?? ""
            }

            stage = defaultStage
        }
    }

    private func saveCandidate() {

        candidateViewModel.addCandidate(
            name: name,
            role: role,
            email: email,
            phone: phone,
            stage: stage,
            experience: experience,
            matchScore: matchScore,
            resume: resumeData,
            job: defaultJob
        )

        dismiss()
    }
}

#Preview {

    NavigationStack {

        AddCandidateView(
            defaultJob: nil
        )
        .environmentObject(CandidateViewModel())
    }
}
