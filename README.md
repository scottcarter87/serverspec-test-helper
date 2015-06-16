# serverspec_test_helper-cookbook

This cookbook will write out all the node attributes of a node into a json file at /tmp/serverspec/node.json.  This file
can then be read while serverspec is running to get access to node attributes that would be otherwise inaccessible.