class Sindr < Formula
  desc "Project-specific commands as a CLI."
  homepage "https://github.com/mbark/sindr"
  url "https://github.com/mbark/sindr/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "2d2ab73379b5c95c26058c6f2b5d9077f1eefe841ad333f922c8f6b170578aeb"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"sindr", "./cmd/main.go"
  end

  test do
    system bin/"sindr", "--help"
  end
end
