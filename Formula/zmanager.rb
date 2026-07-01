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
      url "https://github.com/tzap-org/zmanager/releases/download/v1.0.5/zm-aarch64-apple-darwin.tar.gz"
      sha256 "6fbf86004a1d9aa5e9c05c920cb69066887488121a482c5608afce1a46519d0a"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v1.0.5/zm-x86_64-apple-darwin.tar.gz"
      sha256 "5ae68fae5f8365db077e8e7945658ae55bccbd63d5835c24e1688d703a272486"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v1.0.5/zm-aarch64-unknown-linux-musl.tar.gz"
      sha256 "19477a23bd550067ff5473c1cf8de875184374c662401a2d50723f87df8fa30e"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v1.0.5/zm-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f14b0698808e9d536a642044c8122fbee4bb2f3b88636aaa6c187205a136209d"
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
