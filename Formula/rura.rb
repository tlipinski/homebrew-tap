class Rura < Formula
  desc "Interactive TUI pipeline editor built for rapid iteration"
  homepage "https://github.com/tlipinski/rura"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tlipinski/rura/releases/download/v1.0.0/rura-aarch64-apple-darwin.tar.xz"
      sha256 "c937efe7d80f7fd8d50f094b395a3c47dfd31b2ffdffe6aa25b431b74132cd49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tlipinski/rura/releases/download/v1.0.0/rura-x86_64-apple-darwin.tar.xz"
      sha256 "4167f8eb9b78fe66f25f8a798bea44c4b23d311564eb15401e2e8a3e5e2e9867"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tlipinski/rura/releases/download/v1.0.0/rura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "308ad6e323632b507f8d4add995c3696f623c3e99dca85e0c29c9e8347685d65"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tlipinski/rura/releases/download/v1.0.0/rura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a5d95b8ef3beb9506faf7ce8afaa4bd54cd47114710f62a008512fbedb5e93a5"
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
