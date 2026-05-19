class Rura < Formula
  desc "Interactive TUI pipeline editor built for rapid iteration"
  homepage "https://github.com/tlipinski/rura"
  version "1.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tlipinski/rura/releases/download/v1.1.1/rura-aarch64-apple-darwin.tar.xz"
      sha256 "d6437a38790fcd90e3475e7f6c74050c5c5667b4cfb649e2aede3f08d5125eda"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tlipinski/rura/releases/download/v1.1.1/rura-x86_64-apple-darwin.tar.xz"
      sha256 "8d83cff02aa6c6ee506104ff8c441844c31216268f56da880740d73f8ff48488"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tlipinski/rura/releases/download/v1.1.1/rura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "97159d15a7cad38aef514ba00167616f265ee56a8980f25023a7b28d84f0e3b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tlipinski/rura/releases/download/v1.1.1/rura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6b5b40715349a44a2c3196d75c517051e485b3d98bb8ddcf5f7ac3da95e22410"
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
