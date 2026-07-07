class Zmanager < Formula
  desc "Universal file archiver for fast compression and safe extraction"
  homepage "https://github.com/tzap-org/zmanager"
  license all_of: ["Apache-2.0", :cannot_represent]

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libb2"
    depends_on "lz4"
    depends_on "xz"
    depends_on "zstd"

    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v1.0.6/zm-aarch64-apple-darwin.tar.gz"
      sha256 "61ad90e7491211256f8e75671170ab960639722d840311da40cc2682c8c2065d"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v1.0.6/zm-x86_64-apple-darwin.tar.gz"
      sha256 "5d1df87e3828eb2825ca4877c3b321235977d1011ae9bc93c92538f2c5d0ba15"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v1.0.6/zm-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fd9a3bc649aca6753ea8d3ca9deba2e99bc3d517c9fa3fd94b0a3851f14f55bb"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v1.0.6/zm-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5ebdd0c550f1aaa6b40b504e7b204a8fc4ed7763c511eb102078d9f6577b76aa"
    end
  end

  def install
    bin.install "zm"
    man1.install "man/man1/zm.1"
    bash_completion.install "completions/zm.bash" => "zm"
    zsh_completion.install "completions/_zm" => "_zm"
    fish_completion.install "completions/zm.fish"
    doc.install "README.md", "LICENSE", "NOTICE", "THIRD_PARTY_NOTICES.md"
  end

  def caveats
    <<~EOS
      Shell completions are installed for bash, zsh, and fish.
      Bash users can enable completion without extra packages by adding:
        source #{HOMEBREW_PREFIX}/etc/bash_completion.d/zm

      Or generate completions manually:
        source <(zm completions bash)

      PowerShell users can generate a completer manually:
        zm completions powershell > zm.ps1
    EOS
  end

  test do
    assert_match "zm #{version}", shell_output("#{bin}/zm --version")

    (testpath/"payload.txt").write("hello from Homebrew\n")
    system bin/"zm", "create", "payload.zip", "payload.txt"
    system bin/"zm", "test", "payload.zip"
  end
end
