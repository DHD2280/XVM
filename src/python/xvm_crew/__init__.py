"""
SPDX-License-Identifier: GPL-3.0-or-later
Copyright (c) 2013-2025 XVM Contributors
"""

#
# Imports
#

# XVM Crew
import crew



#
# XFW API
#

__initialized = False

def xfw_module_init():
    global __initialized
    if not __initialized:
        crew.init()
        __initialized = True


def xfw_module_fini():
    global __initialized
    if __initialized:
        crew.fini()
        __initialized = False


def xfw_is_module_loaded():
    global __initialized
    return __initialized