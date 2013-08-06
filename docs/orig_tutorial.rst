========
Tutorial
========

Introduction
============

We review here the main concepts used to write a control file (or xml script) for the adms interpreter. When adms parses a verilog-ams file it builds a data tree - the adms data tree. In the course of this tutorial we build step by step a simple control file that will print out some pieces of the xml data tree. 
Version used: admsXml-2.2.8

Prerequisites
=============

`adms` has to be installed on your system. Any bugs/questions can be sent to me 
Run `admsXml -v` to get the adms version installed on your system.

Understand how the adms data tree is structured
===============================================

During parsing the Verilog-AMS input file is 'translated' into the adms data tree. File adms.xml describes how the adms data tree is structured inside adms.

Simple Verilog-AMS input file
=============================

Let suppose that we want to 'run' adms on the following Verilog-AMS input file::

    **************************
    *** Input file myfile.va *
    **************************
    `include "disciplines.h"
    (*p1="v1" p2="v2"*)
    module mymodule (t1,t2);
      inout t1,t2;
      electrical t1,t2;
      (*desc="input param p1" unit="no"*) parameter real p1=1.0;
      real v1;
      real v2;
      analog
	begin
	  v1=1.0;
	  I(t1,t2)<+v1*V(t1,t2) (*source="resistive contrib"*);
	end
    endmodule

After parsing the Verilog-AMS code of file myfile.va is saved internally into an 'adms data tree'. The tree is traversed using xml scripts. The language that specifies how to traverse the tree is close to the XPATH language. In order to avoid any ambiguity we will call it the admstpath.
When a node is traversed a specific action is performed. The language that specficies the actions occuring at node traversing is close to the XSLT language. We will call it the admst language. At the command line the following command:
admsXml myfile.va -e myxml.va
will read the instructions of file myxml.va. These instructions will traverse the adms data tree and perform some operations. Let's now describe the structure of the adms data tree.

adms data tree
==============

The structure of the adms data tree can entirely be deduced from file adms.xml The best way to visualize adms.xml is to go to the adms web site and click on "adms internal data tree".
The starting element of the adms data tree is "admsmain". In the admstpath language character '/' points to this element. Element "admsmain" has children. One of them is called 'name'. It is a string. Suppose we want to print the value of 'name'. For the sake of simplicity we will use the short syntax: /name - which means select child 'name' under element 'admsmain'. The following xml piece of code will select the value of 'name' and prints it to stdout::

    <!--
      xml file myxml1.xml *
    -->
    <!DOCTYPE admst SYSTEM "admst.dtd">
    <admst version="2.2.5" xmlns:admst="http://mot-adms.sourceforge.net/xml-files/admst">
      <admst:value-of select="/name"/> 
      <admst:text format="name of admsmain=%s\n"/> 
    </admst>

The following command: `admsXml -e myxml1.xml` results in::

    $ admsXml -e myxml1.xml
    name of admsmain=admsmain
    [info] elapsed time: 0
    [info] admst iterations: 15 (15 freed)

Note that in this case no input file has been specified at the command line. The adms data tree that has been created contains some general pieces of data. The branch of the tree dedicated for Verilog-AMS data storage is empty. Let's now focus on this part.

admstpath: /module
==================

Child '/module' is the starting point where Verilog-AMS modules are saved . '/module' is a list of elements of type 'module'. Go to the definition of element 'module' in file adms.xml to better unserstand its structure. 
Element 'module' has children. One of them is called 'name' - it is a string. Here we want to print the name of all modules (I assume that the Verilog-AMS input file has different module declarations.) The code below gives a possible implementation of the algorithm::

    <!--
      xml file myxml2.xml *
    -->
    <!DOCTYPE admst SYSTEM "admst.dtd">
    <admst version="2.2.4" xmlns:admst="http://mot-adms.sourceforge.net/xml-files/admst">
      <admst:for-each select="/module">
	<admst:value-of select="name"/> 
	<admst:text format="name=%s\n"/> 
      </admst:for-each>
    </admst>

Let's now run adms. The following command: `admsXml -e myxml1.xml` results in::

    $ admsXml myfile.va -e myxml2.xml
    [info] admsXml-2.2.4 May 31 2006 13:03:37
    name=mymodule
    [info] elapsed time: 0.0937506
    [info] admst iterations: 772 (772 freed)

admstpath: [a='b']
==================

Now let's give a more complex usage of the admstpath language.
Element 'module' has a child called attribute. Child 'attribute' is a list of elements 'attribute'. List 'atttribute' links to the verilog-AMS declarations::

    *** piece of Verilog-AMS code that maps to /module/attribute ****
    (*p1="v1" p2="v2**) module mymodule (....);....

Each pair p="v" is 'converted' into 'attribute' elements. And each attribute element will be added to list module/attribute. 
After looking at the definition of element 'attribute' in file adms.xml you see that this element has two children called 'name' and 'value'. Suppose you want to get the value of p1 and print it to file ".output". In admstpath you will write::

    <!--
      xml file myxml3.xml *
    -->
    <!DOCTYPE admst SYSTEM "admst.dtd">
    <admst version="2.2.4" xmlns:admst="http://mot-adms.sourceforge.net/xml-files/admst">
      <admst:for-each select="/module">
	<admst:value-of select="name"/> 
	<admst:open file="%s.output">
	  <admst:value-of select="attribute[name='p1']/value"/> 
	  <admst:text format="name=%s\n"/> 
	</admst:open>
	<admst:value-of select="name"/> 
	<admst:text format="%s.output: file created\n"/> 
      </admst:for-each>
    </admst>

If the output of adms is redirected to stdout then myxml3.xml can reduce to::

    <!--
      short form *
    -->
    <!DOCTYPE admst SYSTEM "admst.dtd">
    <admst version="2.2.4" xmlns:admst="http://mot-adms.sourceforge.net/xml-files/admst">
      <admst:value-of select="/module/attribute[name='p1']/value"/> 
      <admst:text format="name=%s\n"/> 
    </admst>

admstpath: . and ..
===================

During tree traversal two special strings are used to specify the currently traversed node and the previously traversed node. They are '.' and '..' respectively.::

    <!--
      myxml4.xml: special admstpath strings '.' and '..'
    -->
    <!DOCTYPE admst SYSTEM "admst.dtd">
    <admst version="2.2.4" xmlns:admst="http://mot-adms.sourceforge.net/xml-files/admst">
      <admst:for-each select="/module">
	<admst:for-each select="variable">
	  <admst:value-of select="./name"/> 
	  <admst:value-of select="../name"/> 
	  <admst:text format="module=%s variable=%s\n"/> 
	</admst:for-each>
      </admst:for-each>
    </admst>

Let's now run adms. The following command: `admsXml myfile.va -e myxml4.xml` results in::

    $ admsxml-2.2.3 myfile.va -e myxml4.xml
    [info] admsXml-2.2.3 May 31 2006 13:03:37
    module=mymodule variable=p1
    module=mymodule variable=v1
    module=mymodule variable=v2
    [info] elapsed time: 0.0156252
    [info] admst iterations: 792 (792 freed)

admstpath: global variables
===========================

Global variables are declared/set using the admst rule admst:variable. The declaration should occur just inside the <admst>...</admst> block. Values of variables are accessed using either $name-of-variable or $(name-of-variable). The syntax is::

    <!--
      xml file myxml5.xml using global variables
    -->
    <!DOCTYPE admst SYSTEM "admst.dtd">
    <admst version="2.2.4" xmlns:admst="http://mot-adms.sourceforge.net/xml-files/admst">
      <admst:variable name="moduleName"/> 
      <admst:for-each select="/module">
	<admst:value-of select="name"/> 
	<admst:variable name="moduleName" select="%s"/> 
	<admst:open file="$moduleName.output">
	  <admst:value-of select="attribute[name='p1']/value"/> 
	  <admst:text format="name=%s of module $moduleName\n"/> 
	</admst:open>
	<admst:text format="$moduleName.output: file created\n"/> 
      </admst:for-each>
    </admst>

admst:template
==============

The admst language provides a mechanism to declare a sort of functions. Functions are actually named admst:template. Rule admst:template is used to declare new templates. And rule admst:apply-templates is used to call a given template. Using templates myxml5.xml can be rewritten as::

    <!--
      xml file myxml6.xml using global variables
    -->
    <!DOCTYPE admst SYSTEM "admst.dtd">
    <admst version="2.2.4" xmlns:admst="http://mot-adms.sourceforge.net/xml-files/admst">
      <admst:template match="print:attribute"> 
	<admst:value-of select="./attribute[name='p1']/value"/> 
	<admst:text format="name=%s of module $moduleName\n"/> 
      </admst:template> 
      <admst:for-each select="/module">
	<admst:value-of select="name"/> 
	<admst:variable name="moduleName" select="%s"/> 
	<admst:open file="$moduleName.output">
	  <admst:apply-templates select="." match="print:attribute"/> 
	</admst:open>
	<admst:text format="$moduleName.output: file created\n"/> 
      </admst:for-each>
    </admst>

Variables can be defined inside admst:templates. However the scope of the variables is limited to the code of the admst:template.

Traversing analog code using admst:template and node '/module/analog'
=====================================================================

Child '/module/analog' is the top sub-tree from which all the Verilog-AMS analog code is derived. For instance it is possible to re-create all equations of the source Verilog-AMS code by traversing the adms data tree starting from this node. Note that child 'code' of element 'analog' is special. Its type is '*' which means that it can by any kind of elements. Since the type of 'analog/code' is unknown we have to 'guess' its type before we can perform any operation on it.
Type of each node of the tree is accessed using admstpath '/adms/datatypename'. The following xml code illustrates the concept of 'datatypename' and its application for recursive traversal of the adms data tree.::

    <!--
      xml file myxml7.xml using global variables
      Subtree 'analog' is traversed and the dataypename of each traversed node is printed out.
    -->
    <!DOCTYPE admst SYSTEM "admst.dtd">
    <admst version="2.2.4" xmlns:admst="http://mot-adms.sourceforge.net/xml-files/admst">
      <admst:template match="dump:datatypename:recursively"> 
	<admst:choose> 
	  <admst:when test="adms[datatypename='block']"> 
	    <admst:text format="assignment found (\n"/> 
	    <admst:apply-templates select="item" match="dump:datatypename:recursively"/> 
	  </admst:when> 
	  <admst:when test="adms[datatypename='assignment']"> 
	    <admst:text format="assignment found (\n"/> 
	  </admst:when> 
	  <admst:when test="adms[datatypename='contribution']"> 
	    <admst:text format="contribution found (\n"/> 
	  </admst:when> 
	  <admst:otherwise> 
	    <admst:value-of select="adms/datatypename"/> 
	    <admst:message format="%s: datatypename not handled\n"/> 
	  </admst:otherwise> 
	</admst:choose> 
	<admst:text format=")\n"/> 
      </admst:template> 
      <admst:text format="***************\n"/> 
      <admst:text format="start recursion\n"/> 
      <admst:text format="***************\n"/> 
      <admst:apply-templates select="/module/analog/code" match="dump:datatypename:recursively"/> 
    </admst>

That's all for now! I will put more on the feaures of the admstpath/admst languages after the release of adms-2.2.5 - which should make the use of these languages a lot more easier.
