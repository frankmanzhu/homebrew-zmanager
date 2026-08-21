class Zmanager < Formula
  desc "Universal file archiver for fast compression and safe extraction"
  homepage "https://github.com/tzap-org/zmanager"
  version "2.1.0"
  license all_of: ["Apache-2.0", :cannot_represent]


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.1.0/zm-aarch64-apple-darwin.tar.gz"
      sha256 "eedb6a9a85c2c240c704ecc4049712428514f0dde6ffbf39f52d6c6a5115ba34"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.1.0/zm-x86_64-apple-darwin.tar.gz"
      sha256 "b94f2349719950917c4bdda91f088337a0b70159029b0088c41b470e5f9b623e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.1.0/zm-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0ad7324ce2301cc20a8b0ecfe6e366268c66a986c5b8f5234d72df80ed00fa6c"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.1.0/zm-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7f462652f01693d1f61932103b905c1b90a331f18167cf942e7772909a5b4232"
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
