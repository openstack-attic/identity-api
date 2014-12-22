Identity Service API
++++++++++++++++++++

This repository is now frozen-in-time and will not accept new patches.

It was the original holder for API information for the OpenStack
Identity Service, also known as the Keystone project. The Keystone
project provides authentication for OpenStack services, with plans to
also provide authorization.

The Identity Service APIs are now included in the Keystone Specifications
project. Available `to view online at
<http://specs.openstack.org/openstack/keystone-specs/>`_

Building v2.0 Docs
==================

Build these docs using the same procedure as documented for the `openstack-manuals` project: https://github.com/openstack/openstack-manuals

In short, with Maven 3::

    cd openstack-identity-api/v2.0
    mvn clean generate-sources

Building v3 Docs
================
The v3 docs require an extra proprocessing to convert the Markdown source into the DocBook format required by the Maven build process. A few extra tools are required for this preprocessing step.

Installing conversion tools on Ubuntu::

    apt-get install pandoc xsltproc docbook5-xml

To build the docs:

    cd openstack-identity-api/v3
    ./preprocess.sh
    mvn clean generate-sources

Testing of changes and building of the manual
=============================================

Install the python tox package and run ``tox`` from the top-level
directory to use the same tests that are done as part of our Jenkins
gating jobs.

If you like to run individual tests, run:

 * ``tox -e checkniceness`` - to run the niceness tests
 * ``tox -e checksyntax`` - to run syntax checks
 * ``tox -e checkdeletions`` - to check that no deleted files are referenced
 * ``tox -e checkbuild`` - to actually build the manual

tox will use the `openstack-doc-tools package
<https://github.com/openstack/openstack-doc-tools>`_ for execution of
these tests. openstack-doc-tools has a requirement on maven for the
build check.

Contributing
============

Our community welcomes all people interested in open source cloud
computing, and there are no formal membership requirements. The best
way to join the community is to talk with others online or at a meetup
and offer contributions through Launchpad, the OpenStack wiki, or
blogs. We welcome all types of contributions, from blueprint designs
to documentation to testing to deployment scripts.

Installing
==========

Refer to http://keystone.openstack.org to learn more about installing
an OpenStack Identity Service server that can respond to these API
commands.
