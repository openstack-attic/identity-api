This repository contains the RESTful API information for the OpenStack Identity Service, also known as the Keystone project. The Keystone project provides authentication for OpenStack services, with plans to also provide authorization.

Building
========
Build these docs using the same procedure as documented for the `openstack-manuals` project: https://github.com/openstack/openstack-manuals

In short, with Maven 3::

    cd openstack-identity-api
    mvn clean generate-sources

Contributing
============
Our community welcomes all people interested in open source cloud computing, and there are no formal membership requirements. The best way to join the community is to talk with others online or at a meetup and offer contributions through Launchpad, the OpenStack wiki, or blogs. We welcome all types of contributions, from blueprint designs to documentation to testing to deployment scripts.

Installing
==========
Refer to http://keystone.openstack.org to learn more about installing an OpenStack Identity Service server that can respond to these API commands.
