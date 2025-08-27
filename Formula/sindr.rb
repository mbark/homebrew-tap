class Sindr < Formula
  desc "Simple CLI tool creator using Starlark configuration"
  homepage "https://github.com/mbark/sindr"
  url "https://github.com/mbark/sindr/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "2d2ab73379b5c95c26058c6f2b5d9077f1eefe841ad333f922c8f6b170578aeb"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/main.go"
    bin.install "main" => "sindr"
  end

  test do
    system "#{bin}/sindr", "--help"
  end
end