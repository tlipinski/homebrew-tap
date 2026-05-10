class Rura < Formula
  desc "Interactive TUI pipeline editor built for rapid iteration"
  homepage "https://github.com/tlipinski/rura"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tlipinski/rura/releases/download/v0.1.0/rura-aarch64-apple-darwin.tar.xz"
      sha256 "69226342c596cffafebb26afdfa1a28f4304116297992d7e50074f4a213f3631"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tlipinski/rura/releases/download/v0.1.0/rura-x86_64-apple-darwin.tar.xz"
      sha256 "fe0d3aeeecf927ef6deef59a538cd263190812b687bcbb56a50ebd407dcb65e1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tlipinski/rura/releases/download/v0.1.0/rura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b222d64724f631ae18b8a92cd097587921e0ab7a7bc49345b472a2fccc830762"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tlipinski/rura/releases/download/v0.1.0/rura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "592a0661d2b1e20f0b1bfc1b981451f416bd8c17c400487b03aad3ced6918f33"
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
