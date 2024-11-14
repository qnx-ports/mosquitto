#!/usr/bin/env python3
# Test whether a broker handles cleansession and local_cleansession correctly on bridges

import sys
from mosq_test_helper import *
from collections import namedtuple

(port_a_listen, port_b_listen) = mosq_test.get_port(2)
if sys.platform.startswith('qnx'):
    subprocess.run(['python3', './06-bridge-clean-session-core.py', str(port_a_listen), str(port_b_listen), "False", "None"])
else:
    subprocess.run(['./06-bridge-clean-session-core.py', str(port_a_listen), str(port_b_listen), "False", "None"])

