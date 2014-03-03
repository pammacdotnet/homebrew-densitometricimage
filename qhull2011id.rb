require 'formula'

class Qhull2011id < Formula
  homepage 'http://www.qhull.org/'
  url 'http://www.qhull.org/download/qhull-2011.1-src.tgz'
  md5 'a65061cf2a6e6581182f4df0f3667a8e'

  keg_only "Qhull 2011 is provided for software that doesn't compile against newer versions."
  conflicts_with 'qhull2011', :because =>  "Different versions of the same library."
  depends_on 'cmake' => :build

  def patches
    {:p0 => 'https://trac.macports.org/export/83287/trunk/dports/math/qhull/files/patch-CMakeLists.txt.diff'}
  end

  def install
    system "cmake", ".", "-DMAN_INSTALL_DIR=#{man1}", *std_cmake_args
    system "make install"
  end
end
