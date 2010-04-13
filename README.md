Tehila
======
A 3d engine written in scheme.

Currently Tehila is alpha-quality, and very [Chicken Scheme](http://chicken.wiki.br/) specific. There's tons of room for speed optimization, and plenty to do to make it more scheme-like. But it's progressing quite nicely.

Dependencies
------------
You'll need the following [eggs](http://chicken.wiki.br/eggs):

[opengl](http://chicken.wiki.br/opengl)  
[glut](http://chicken.wiki.br/eggref/4/glut)  

And the following extensions (don't worry, **they should be included by default**):  
lolevel  
[srfi-1](http://srfi.schemers.org/srfi-1/srfi-1.html)  
[srfi-4](http://srfi.schemers.org/srfi-4/srfi-4.html)  

Usage
-----
Check out the examples directory, or "csi launcher.scm"

Beware that you will need the bitmap (bmp) files in resources/ currently. There are only a few, but they're there.

Tutorials
---------
The [Nehe tutorials](http://nehe.gamedev.net/lesson.asp?index=01) 1-5 have been translated and are in the examples directory. Edit launcher.scm to specify which to open.
