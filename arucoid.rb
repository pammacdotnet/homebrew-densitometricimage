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
diff -cr aruco_test_board_gl-orig.cpp aruco_test_board_gl.cpp
*** aruco_test_board_gl-orig.cpp	Sun Mar  2 20:21:07 2014
--- aruco_test_board_gl.cpp	Sun Mar  2 20:21:36 2014
***************
*** 29,35 ****
  #include <fstream>
  #include <sstream>
  #ifdef __APPLE__
!   #include <gl.h>
    #include <GLUT/glut.h>
  #elif _MSC_VER
    //http://social.msdn.microsoft.com/Forums/eu/vcgeneral/thread/7d6e6fa5-afc2-4370-9a1f-991a76ccb5b7
--- 29,35 ----
  #include <fstream>
  #include <sstream>
  #ifdef __APPLE__
!   #include <OpenGL/gl.h>
    #include <GLUT/glut.h>
  #elif _MSC_VER
    //http://social.msdn.microsoft.com/Forums/eu/vcgeneral/thread/7d6e6fa5-afc2-4370-9a1f-991a76ccb5b7

diff -cr aruco_test_gl-orig.cpp aruco_test_gl.cpp
*** aruco_test_gl-orig.cpp	Thu Jun 14 15:42:30 2012
--- aruco_test_gl.cpp	Sun Mar  2 20:25:07 2014
***************
*** 30,36 ****
  #include <fstream>
  #include <sstream>
  #ifdef __APPLE__
! #include <gl.h>
  #include <GLUT/glut.h>
  #else
  #include <GL/gl.h>
--- 30,36 ----
  #include <fstream>
  #include <sstream>
  #ifdef __APPLE__
! #include <OpenGL/gl.h>
  #include <GLUT/glut.h>
  #else
  #include <GL/gl.h>