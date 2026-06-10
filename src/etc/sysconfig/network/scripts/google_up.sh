#!/bin/bash
# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# /etc/sysconfig/network/scripts/google_up.sh
# Called by wicked via POST_UP_SCRIPT when an interface comes online
INTERFACE=$1
# 1. Ignore the local loopback interface so we don't spam the Metadata server
if [ "$INTERFACE" = "lo" ] || [ -z "$INTERFACE" ]; then
    exit 0
fi
# 2. Hand off to the dual-stack master orchestrator.
# We MUST push this to the background and sever the file descriptors (>/dev/null 2>&1 &).
# If we do not do this, wicked will freeze waiting for the curl command to finish, 
# which will stall the entire SUSE boot process.
if [ -x /usr/bin/google_set_metadata_network ]; then
    /usr/bin/google_set_metadata_network >/dev/null 2>&1 &
fi
