Basic Scripting
===============


Basic admst Script File Structure
---------------------------------

After ADMS has parsed a Verilog-A model, a tree representation of the model is held in memory. The data in this tree is accessible via a built-in language called admst. admst is an XML-based scripting language, inspired by XPath. All admst scripts share a basic structure. These tell the XML parser about the schema and namespace::

    <!DOCTYPE admst SYSTEM "admst.dtd">
    <admst version="2.3.0" xmlns:admst="http://mot-adms.sourceforge.net/xml-files/admst">
        <!-- Code Here -->
    </admst>

Navigating The Data Tree
------------------------

The information about a parsed Verilog-A file is stored as a tree in memory. To access the data, one uses an XPath-style path syntax.

The root node can be selected with the ``/`` character::

    <admst:value-of select="/"/>

Elements can be selected with their absolute path. This will loop over each node in each module found::

    <admst:for-each select="/module/node">

Some commands, like for-each create a new scope. It's possible to access elements relative to that scope with ``.`` and ``..``
::

    <admst:for-each select="/module/node">
        <admst:value-of select="./name"/>    <!-- Select the current node's name -->
        <admst:value-of select="../name"/>   <!-- Select the node's parent module's name -->
    </admst:for-each>

You can also leave off the ``./`` to access the current element::

    <admst:for-each select="/module/node">
        <admst:value-of select="name"/>    <!-- Also selects the current node's name -->
    </admst:for-each>

It is possible to only select elements that match a certain condition::

    <admst:for-each select="/module/node[direction='input']/name">

Inspecting Objects
------------------

Almost every object will have a name, all objects will have a datatypename and most will have a stringification (an implicit ``toString`` function).
It's possible to access these with the ``value-of`` command::

    <admst:value-of select="."/>
    <admst:value-of select="name"/>
    <admst:value-of select="datatypename"/> 

    <admst:text format="datatypename=%s name=%s stringification=%s"/>

The ``value-of`` retrieves an object and puts it on top of a stack. (Note that values are used in the order opposite of how they were read.) The ``%s`` string used in the ``text``'s format argument pops an object off of the stack and converts it into a string, if necessary. This conversion will call the object's stringification if it's not already a string.

Calling ``value-of`` without a corresponding ``%s`` will result in an error at the end of the parsing due to a non-empty stack. Using ``%s`` without having first called ``value-of`` will result in an error when the stack underflows.

A much easier way to get strings is to use ``%(<path>)``::

    <admst:text format="datatypename=%(datatypename) name=%(name) stringification=%(.)"/>

Object Reference
----------------

The structure of every object is defined in the ADMS source code, in `adms.xml`. This is used not just for documentation, but also code generation! Adding new objects to `adms.xml` will allow you to use them in admst scripts, as well as the actual Verilog-A parser.

You can generate an interactive tree representation of the object tree locally with::

    xsltproc adms.xml -o adms.html

`There is also a compiled version available online. <http://upverter.github.io/ADMS/2.3/adms.html>`_

Variables
---------

Variables provide storage for objects or data. Their values can be set to anything that you can use in a ``select`` argument::

    <admst:variable name="myvar1" select="/module"/>
    <admst:variable name="myvar2" select="/module/node[name='foo']"/>
    <admst:variable name="myvar3" select="'foo'"/>
    <admst:variable name="myvar4" select="1"/>

To access a variable, use ``$variable_name`` or ``$(variable_name)``, like this::

    <admst:variable name="myvar5" select="$myvar4"/>
    <admst:for-each select="$(myvar1)/node[name=$(myvar2)]">

You can omit the ``select`` statement in the variable declaration to leave the variable uninitialized::

    <admst:variable name="myvar6"/>

Variables defined outside of a template are global, and can be accessed anywhere. Variables defined inside of a template are not accessible outside of the template.

Templates
---------

Templates in admst are mostly equivalent to functions in other languages. They can only receive one argument, and may only return string values. They do create a new scope for variables, and may be called recursively.

You can define a template like this::

    <admst:template match="my_first_template">
        <admst:text format="%(name)"/>
    </admst:template>

And then call it like this::

    <admst:apply-templates match="my_first_template" select="/module">

This will pass in the object/objects from the select argument, which all paths inside of the template will be relative to.

