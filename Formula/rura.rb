class Rura < Formula
  desc "Interactive TUI pipeline editor built for rapid iteration"
  homepage "https://github.com/tlipinski/rura"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tlipinski/rura/releases/download/v1.0.0/rura-aarch64-apple-darwin.tar.xz"
      sha256 "0f4580255f157ca0af2e7d3a84777e6a86321dde267028e0d3163f8254aaa0c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tlipinski/rura/releases/download/v1.0.0/rura-x86_64-apple-darwin.tar.xz"
      sha256 "b1632ba96144c75f2777e8549bbe11a422f57c35901ba4bef3a42bc628354766"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tlipinski/rura/releases/download/v1.0.0/rura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "929bd4f4898c6700b36f11f3cd486cbe16bc8998b9febd2fc9c3e05740131ab7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tlipinski/rura/releases/download/v1.0.0/rura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6a8b73ab4269fd4ccd3a1af61590473f5c2fb87d0743c1e86248169fbd05909c"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "rura" if OS.mac? && Hardware::CPU.arm?
    bin.install "rura" if OS.mac? && Hardware::CPU.intel?
    bin.install "rura" if OS.linux? && Hardware::CPU.arm?
    bin.install "rura" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
