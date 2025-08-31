class Sindr < Formula
  desc "Project-specific commands as a CLI"
  homepage "https://github.com/mbark/sindr"
  url "https://github.com/mbark/sindr/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "7e55e0738902df291eeaf497c57ebdf5bbe2e785aded5fe760cafcc094aa5431"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"sindr", "./cmd/main.go"
    generate_completions_from_executable(bin/"sindr", "completion")
  end

  test do
    system bin/"sindr", "--help"
  end
end
