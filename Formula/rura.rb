class Rura < Formula
  desc "Interactive TUI pipeline editor built for rapid iteration"
  homepage "https://github.com/tlipinski/rura"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tlipinski/rura/releases/download/v1.1.0/rura-aarch64-apple-darwin.tar.xz"
      sha256 "48c60bbf100c7152ccbb4b59eba737a737306926cc8eef9980229bdfeda160e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tlipinski/rura/releases/download/v1.1.0/rura-x86_64-apple-darwin.tar.xz"
      sha256 "d40936497e15106e65e8482fdd697a8bfec0d95ee3457b8a1c277f71f17fcee9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tlipinski/rura/releases/download/v1.1.0/rura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7ed9150bc43edcf215eee39a5163a83a5a364b7a86b566d7695b0fd4905aa1d8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tlipinski/rura/releases/download/v1.1.0/rura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "13abb6ce4411ea4666d14c001edd6f967582348720dc44777b3b529c1f4af109"
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
