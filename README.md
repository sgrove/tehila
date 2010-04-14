Tehila
======
A 3d engine written in scheme.

Currently Tehila is alpha-quality, and very [Chicken Scheme](http://chicken.wiki.br/) specific. There's tons of room for speed optimization, and plenty to do to make it more scheme-like. But it's progressing quite nicely.

Dependencies
------------
You'll need the following [eggs](http://chicken.wiki.br/eggs):

[opengl](http://chicken.wiki.br/opengl)  
[glut](http://chicken.wiki.br/eggref/4/glut)  

Installation & Usage
--------------------
To install, first install chicken scheme, and then:

    sudo chicken-install opengl
    sudo chicken-install glut
    git clone git://github.com/sgrove/tehila.git

That's it! Tehila is setup with all its dependencies. Now edit launcher.scheme to pick an example to run, then

    csi launcher.scm

And you should see your chosen example appear. For all the examples available, check out the examples directory, or "csi launcher.scm"

Tutorials
---------
The [Nehe tutorials](http://nehe.gamedev.net/lesson.asp?index=01) 1-5 have been translated and are in the examples directory. Edit launcher.scm to specify which to open.
