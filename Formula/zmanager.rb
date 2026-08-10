class Zmanager < Formula
  desc "Universal file archiver for fast compression and safe extraction"
  homepage "https://github.com/tzap-org/zmanager"
  license all_of: ["Apache-2.0", :cannot_represent]

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.0.1/zm-aarch64-apple-darwin.tar.gz"
      sha256 "162e7946cc6cbc574ec23736362b941054f031afb7c631138b08e86a49cbb5cc"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.0.1/zm-x86_64-apple-darwin.tar.gz"
      sha256 "f99b141d924696783ab78df07d01139878de18ffd54ff92a8e1175bf68bde047"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.0.1/zm-aarch64-unknown-linux-musl.tar.gz"
      sha256 "824d91b0cd1cc3734b61d5328432f33004c87f2dd0fe4911f23a292a47f3e8e8"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.0.1/zm-x86_64-unknown-linux-musl.tar.gz"
      sha256 "46c13c14361eadd68428f5cba5a4f78c423cd1d4b171fd5ac20faebb72b19914"
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
