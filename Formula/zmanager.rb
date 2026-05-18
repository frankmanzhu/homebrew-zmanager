class Zmanager < Formula
  desc "Fast, safe archive utility for ZIP, 7z, TAR.ZST, and broad extraction"
  homepage "https://github.com/frankmanzhu/zmanager"
  version "1.0.1"
  license all_of: ["Apache-2.0", :cannot_represent]

  depends_on "libb2"
  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://api.github.com/repos/frankmanzhu/zmanager/releases/assets/423474421",
          headers:  ["Accept: application/octet-stream"],
          verified: "github.com/frankmanzhu/zmanager/"
      sha256 "fd373115a08b6fd6c5b6f92b5de5a791a42154647af660d1094f959e7369b757"
    else
      url "https://api.github.com/repos/frankmanzhu/zmanager/releases/assets/423474416",
          headers:  ["Accept: application/octet-stream"],
          verified: "github.com/frankmanzhu/zmanager/"
      sha256 "e31cf89f311959fe41f4e5c257738c3767623831fb1e0035dd7be16a45e700b9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://api.github.com/repos/frankmanzhu/zmanager/releases/assets/423474417",
          headers:  ["Accept: application/octet-stream"],
          verified: "github.com/frankmanzhu/zmanager/"
      sha256 "b33dfde6c75c352b88fb578a1ba1beda15a1fbe8875f08170de67c0a80ab3f8e"
    else
      url "https://api.github.com/repos/frankmanzhu/zmanager/releases/assets/423474415",
          headers:  ["Accept: application/octet-stream"],
          verified: "github.com/frankmanzhu/zmanager/"
      sha256 "dd1fb3d24ed2a33ce6ca34e63d0445b8e68ce847106dbf92d4e429011bdda7e0"
    end

    depends_on "acl"
    depends_on "bzip2"
    depends_on "libxml2"
    depends_on "openssl@3"
    depends_on "zlib"
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
