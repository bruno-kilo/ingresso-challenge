// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "IngressoKit",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
    ],
    products: [
        .library(name: "IngressoDomain", targets: ["IngressoDomain"]),
        .library(name: "IngressoData", targets: ["IngressoData"]),
        .library(name: "IngressoInfrastructure", targets: ["IngressoInfrastructure"]),
        .library(name: "IngressoPresentation", targets: ["IngressoPresentation"]),
        .library(name: "IngressoUI", targets: ["IngressoUI"]),
        .library(name: "IngressoMock", targets: ["IngressoMock"]),
    ],
    targets: [
        // MARK: - Domain (ZERO deps)
        .target(name: "IngressoDomain"),

        // MARK: - Infrastructure (ZERO internal deps)
        .target(name: "IngressoInfrastructure"),

        // MARK: - Data (Domain + Infrastructure)
        .target(
            name: "IngressoData",
            dependencies: ["IngressoDomain", "IngressoInfrastructure"]
        ),

        // MARK: - Presentation (Domain + Infrastructure)
        .target(
            name: "IngressoPresentation",
            dependencies: ["IngressoDomain", "IngressoInfrastructure"]
        ),

        // MARK: - UI (Domain + Presentation + Infrastructure)
        .target(
                    name: "IngressoUI",
                    dependencies: ["IngressoDomain", "IngressoPresentation", "IngressoInfrastructure"],
                    resources: [.process("Resources")]
                ),

        // MARK: - Mock (all layers)
        .target(
            name: "IngressoMock",
            dependencies: [
                "IngressoDomain",
                "IngressoData",
                "IngressoInfrastructure",
                "IngressoPresentation",
            ]
        ),

        // MARK: - Tests
        .testTarget(
            name: "IngressoDomainTests",
            dependencies: ["IngressoDomain", "IngressoMock"]
        ),
        .testTarget(
            name: "IngressoDataTests",
            dependencies: ["IngressoData", "IngressoDomain", "IngressoInfrastructure", "IngressoMock"]
        ),
        .testTarget(
            name: "IngressoInfrastructureTests",
            dependencies: ["IngressoInfrastructure"]
        ),
        .testTarget(
            name: "IngressoPresentationTests",
            dependencies: ["IngressoPresentation", "IngressoDomain", "IngressoInfrastructure", "IngressoMock"]
        ),
    ]
)
