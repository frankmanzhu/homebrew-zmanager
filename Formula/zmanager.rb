class Zmanager < Formula
  desc "Universal file archiver for fast compression and safe extraction"
  homepage "https://github.com/tzap-org/zmanager"
  version "2.1.2"
  license all_of: ["Apache-2.0", :cannot_represent]


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.1.2/zm-aarch64-apple-darwin.tar.gz"
      sha256 "23fc838ec946cf557e67240e312d82668aee05036617b40bccff8e72a43a169c"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.1.2/zm-x86_64-apple-darwin.tar.gz"
      sha256 "50ef0701163d64ecb3de023d8b6975ca8523feef85b9595fdef24a500e00fbf8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.1.2/zm-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ff65ecc299e400f3f3aaf07bb92bc3384ca45a69a95997016b8494325a56a4a9"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.1.2/zm-x86_64-unknown-linux-musl.tar.gz"
      sha256 "121d84beb448821bac4d262b60b6798d956cfdeecac2e392e019395a7a131c45"
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
