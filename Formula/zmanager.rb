class Zmanager < Formula
  desc "Universal file archiver for fast compression and safe extraction"
  homepage "https://github.com/tzap-org/zmanager"
  license all_of: ["Apache-2.0", :cannot_represent]

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.0.0/zm-aarch64-apple-darwin.tar.gz"
      sha256 "7d0b8c62dff69dcf689a27957a1de9e645f0fe7852744648b30674c3e3d42e72"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.0.0/zm-x86_64-apple-darwin.tar.gz"
      sha256 "37dfeab3ac77ad924c85370ac3189e990e6376aa848da273751ae53ec11f2490"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.0.0/zm-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8bd5d8be1b9259a77132218e34545bfe455ce312762351e6dc4afa5c380b7f8c"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.0.0/zm-x86_64-unknown-linux-musl.tar.gz"
      sha256 "16abfff89b8ae43ad803f94e6d650fc29cf1c9eb250f25d1c4830991db841627"
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
