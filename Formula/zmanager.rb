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
      url "https://github.com/tzap-org/zmanager/releases/download/v1.0.4/zm-aarch64-apple-darwin.tar.gz"
      sha256 "24439fb951b08a21fa6987a2cd475cfc0b6362daf369ba80cc236a5fec9e2281"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v1.0.4/zm-x86_64-apple-darwin.tar.gz"
      sha256 "7dc9cdd6ca3525154270ec099f0516c68e94d7efd94081626caf33f197cd4140"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v1.0.4/zm-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9a1ecd1999e74d8f6833ec91a84149660af1d4f79573d4f937a08f19416da557"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v1.0.4/zm-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0e96bbdeebd9f967fdbb80c217f308cf21de3ad222bf9a648497e4005ffa7283"
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
