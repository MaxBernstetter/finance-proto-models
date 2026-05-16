from conan import ConanFile
from conan.tools.cmake import CMake, cmake_layout
from os import getenv


class FinanceProtoModelsConan(ConanFile):
    name = "finance-proto-models"
    version = "0.0.0"

    package_type = "library"

    settings = "os", "compiler", "build_type", "arch"

    options = {
        "shared": [True, False],
    }

    default_options = {
        "shared": False,
    }

    exports_sources = (
        "CMakeLists.txt",
        "gen/cpp/*",
    )

    requires = f"protobuf/{getenv('CONAN_PROTOBUF_VERSION')}"

    generators = "CMakeDeps", "CMakeToolchain"

    def layout(self):
        cmake_layout(self)

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        cmake = CMake(self)
        cmake.install()

    def package_info(self):
        self.cpp_info.libs = ["finance_proto_models"]
