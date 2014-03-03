require 'formula'

class Arucoid < Formula
  homepage 'http://www.uco.es/investiga/grupos/ava/node/26'
  url 'http://downloads.sourceforge.net/project/aruco/1.2.4/aruco-1.2.4.tgz'
  sha1 '78e6ba073d59eae1ac62ba0ac226ff6f39a83d59'

  depends_on 'cmake' => :build
  depends_on 'opencvid' => :build
  depends_on 'pkg-config' => :build
  conflicts_with 'aruco' if Formula.installed.join.include? "aruco"
  
  def patches
    DATA
  end

  def install
    args = std_cmake_args + %W[
     ]
    mkdir 'macbuild' do
      system 'cmake', '..', *args
      system "make"
      system "make install"
    end
  end
end

__END__
diff --git a/utils/aruco_test_gl.cpp b/utils/aruco_test_gl.cpp
index 74caf5c..c6c72a6 100644
--- a/utils/aruco_test_gl.cpp
+++ b/utils/aruco_test_gl.cpp
@@ -30,7 +30,7 @@ or implied, of Rafael Muñoz Salinas.
 #include <fstream>
 #include <sstream>
 #ifdef __APPLE__
-#include <gl.h>
+#include <OpenGL/gl.h>
 #include <GLUT/glut.h>
 #else
 #include <GL/gl.h>

diff --git a/utils/aruco_test_board_gl.cpp b/utils/aruco_test_board_gl.cpp
index c21ff31..4681910 100644
--- a/utils/aruco_test_board_gl.cpp
+++ b/utils/aruco_test_board_gl.cpp
@@ -29,7 +29,7 @@ or implied, of Rafael Muñoz Salinas.
 #include <fstream>
 #include <sstream>
 #ifdef __APPLE__
-  #include <gl.h>
+  #include <OpenGL/gl.h>
   #include <GLUT/glut.h>
 #elif _MSC_VER
   //http://social.msdn.microsoft.com/Forums/eu/vcgeneral/thread/7d6e6fa5-afc2-4370-9a1f-991a76ccb5b7
