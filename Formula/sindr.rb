class Sindr < Formula
  desc "Project-specific commands as a CLI"
  homepage "https://github.com/mbark/sindr"
  url "https://github.com/mbark/sindr/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "444dda2926da4dff6444d6c668a3f7b8d4f249bd77b3178a1a27a5c3b33f86b2"
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
