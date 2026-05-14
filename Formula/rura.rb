class Rura < Formula
  desc "Interactive TUI pipeline editor built for rapid iteration"
  homepage "https://github.com/tlipinski/rura"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tlipinski/rura/releases/download/v1.0.1/rura-aarch64-apple-darwin.tar.xz"
      sha256 "8029898d3e26f970ebabf5121f925fed6d2e2d0ee0ac4bc9844a2218f90f9a32"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tlipinski/rura/releases/download/v1.0.1/rura-x86_64-apple-darwin.tar.xz"
      sha256 "1ee8718a39d6b64fa09a57c03a6467cc2a42abe214c3bfea8d6db78637644607"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tlipinski/rura/releases/download/v1.0.1/rura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4c0ee3c3a101be72e68204a47edf03bb505f33793f9174275e65468a89509382"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tlipinski/rura/releases/download/v1.0.1/rura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "12d234c058bd7d6d7d026d153ba11ae6c099179882bd4aba81f14fff2358d831"
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
