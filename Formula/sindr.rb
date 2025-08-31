class Sindr < Formula
  desc "Project-specific commands as a CLI"
  homepage "https://github.com/mbark/sindr"
  url "https://github.com/mbark/sindr/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "4227cbdd40614e6e0cc6338435e80945ab35044ce17960a86b2e8c7c0f4f5dc7"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"sindr", "./cmd/main.go"
  end

  test do
    system bin/"sindr", "--help"
  end
end
