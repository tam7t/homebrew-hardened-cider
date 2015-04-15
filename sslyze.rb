require 'formula'

class Sslyze < Formula
  homepage 'https://github.com/nabla-c0d3/sslyze'
  url 'https://github.com/nabla-c0d3/sslyze/archive/release-0.11.tar.gz'
  sha256 'd0adf9be09d5b27803a923dfabd459c84a2eddb457dac2418f1bf074153f8f93'
  version '0.11.0'

  depends_on :arch => :x86_64
  depends_on :python

  conflicts_with 'openssl', :because => 'nassl builds against its own openssl'

  resource 'nassl' do
    url 'https://github.com/nabla-c0d3/nassl/archive/v0.11.tar.gz'
    sha256 '83fe1623ad3e67ba01a3e692211e9fde15c6388f5f3d92bd5c0423d4e9e79391'
  end

  resource 'openssl' do
    url 'https://www.openssl.org/source/openssl-1.0.2a.tar.gz'
    sha256 '15b6393c20030aab02c8e2fe0243cb1d1d18062f6c095d67bca91871dc7f324a'
  end

  resource 'zlib' do
    url 'http://zlib.net/zlib-1.2.8.tar.gz'
    sha256 '36658cb768a54c1d4dec43c3116c27ed893e88b02ecfcb44f2166f9c0b7f2a0d'
  end

  def shim_script
    <<-EOS.undent
        #!/bin/sh
        python #{prefix}/sslyze.py "$@"
      EOS
  end

  def install
    ENV.deparallelize
    resource('nassl').stage do
      nasslpath = Pathname.new(Dir.pwd)

      resource('openssl').stage do
        (nasslpath/'openssl-1.0.2a').install Dir["*"]
      end

      resource('zlib').stage do
        (nasslpath/'zlib-1.2.8').install Dir["*"]
      end

      system 'python', 'buildAll_unix.py'
      prefix.install 'test/nassl'
    end

    prefix.install Dir['*']
    (bin + 'sslyze').write shim_script
  end

  test do
    system "#{bin}/sslyze", '--version'
  end
end
