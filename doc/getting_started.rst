Getting Started
===============

Getting The Code
----------------
::

    git clone https://github.com/upverter/ADMS.git

Building The Code
-----------------

ADMS requires flex and bison. If you're using Ubuntu, you can install these with::

    sudo apt-get install flex bison

After that, it's simply::

    ./configure
    make
    sudo make install

Now try::

   admsXml

If you get errors about missing library files, run::

    sudo ldconfig
    
Running Scripts
---------------

The most common usage is::

    admsXml [verilogaFile.va] -e script1.xml [-e script2.xml ...]

See ``admsXml -h`` for further instructions.

