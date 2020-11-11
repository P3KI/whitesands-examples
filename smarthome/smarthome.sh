#!/bin/sh
# Device/Control Demo
# Simulating a small smart home scenario
#

# Configuration
# This config should set the variables WHITESANDS_USER,
# WHITESANDS_PASS, as well as WHITESANDS_INSTANCE_1 through
# WHITESANDS_INSTANCE_3 for this demo.
. ~/.whitesands.conf


if [ -z $WHITESANDS_USER -o -z $WHITESANDS_PASS ]; then
	echo "Credentials not configured properly. Please check ~/.whitesands.conf"
	exit -1
fi

if [ -z "$WHITESANDS_INSTANCE_1" -o -z "$WHITESANDS_INSTANCE_2" -o -z "$WHITESANDS_INSTANCE_3" ]; then
	echo "Not enough instances configured. Please check ~/.whitesands.conf"
	exit -1
fi

## Instance on which to store owner and smart home device identities
INSTANCE_OWNER="$WHITESANDS_INSTANCE_1"

## Instance on which to store the friend's identity
INSTANCE_FRIEND="$WHITESANDS_INSTANCE_2"

## Instance used just for kicks to run verifications
## This shows that a global-view third party can verify
## relationships as well.
INSTANCE_GV="$WHITESANDS_INSTANCE_3"

LANG="action:tdns(atomic)"
DOOR_POL='{"policy":"action:{control.door}"}'
LIGHT_POL='{"policy":"action:{control.light}"}'
HEATER_POL='{"policy":"action:{control.heating}"}'
FULL_CTRL_POL='{"policy":"action:{control}"}'

# %%% CONFIGURATION END %%%

# import shared functions
. ../common/common.sh

report


##
## DEMO STARTS HERE
##

echo;echo;echo;echo
echo "-- ACT 0: Setup ------------------------------------------"
echo
echo "# Querying required instances..."
echo
echo " Whitesands: $(get "$(ws_url /ping)")"
echo "      owner: $INSTANCE_OWNER, $(get "$(trinity $INSTANCE_OWNER /ping)")"
echo "     friend: $INSTANCE_FRIEND, $(get "$(trinity $INSTANCE_FRIEND /ping)")"
echo "global view: $INSTANCE_GV, $(get "$(trinity $INSTANCE_GV /ping)")"
echo

echo "# Resetting instances ..."
echo
echo "all instances: $(post "$(ws_url /reset)")"
echo
delay

echo "# Creating identities..."
echo
echo " owner: $(post "$(trinity $INSTANCE_OWNER /identity/owner)")"
echo "  door: $(post "$(trinity $INSTANCE_OWNER /identity/door)")"
echo "heater: $(post "$(trinity $INSTANCE_OWNER /identity/heater)")"
echo " light: $(post "$(trinity $INSTANCE_OWNER /identity/light)")"
echo "friend: $(post "$(trinity $INSTANCE_FRIEND /identity/friend)")"
echo
delay

echo "# Requesting public keys..."
echo
OWNER_KEY=$(get "$(trinity $INSTANCE_OWNER /identity/owner)"   | sed 's/"//g')
DOOR_KEY=$(get "$(trinity $INSTANCE_OWNER /identity/door)"     | sed 's/"//g')
HEATER_KEY=$(get "$(trinity $INSTANCE_OWNER /identity/heater)" | sed 's/"//g')
LIGHT_KEY=$(get "$(trinity $INSTANCE_OWNER /identity/light)"   | sed 's/"//g')
FRIEND_KEY=$(get "$(trinity $INSTANCE_FRIEND /identity/friend)"| sed 's/"//g')
                                                              
echo " owner: $OWNER_KEY"                                     
echo "  door: $DOOR_KEY"                                      
echo "heater: $HEATER_KEY"
echo " light: $LIGHT_KEY"
echo "friend: $FRIEND_KEY"
echo
delay







echo;echo;echo;echo
echo "-- ACT 1: Devices that trust -----------------------------"
echo
echo "# Setting devices to trust owner..."
echo
echo "Note: for sake of simplification, we're using unlimited"
echo "      validity. You should not do that in production."
echo
delay
echo "   door trust owner: $(post "$(trinity $INSTANCE_OWNER /identity/door/trust/$OWNER_KEY )" "$DOOR_POL")"
echo "  light trust owner: $(post "$(trinity $INSTANCE_OWNER /identity/light/trust/$OWNER_KEY )" "$LIGHT_POL")"
echo "heater trusts owner: $(post "$(trinity $INSTANCE_OWNER /identity/heater/trust/$OWNER_KEY )" "$HEATER_POL")"
echo
delay
echo "# Listing relationships..."
echo
echo "  door->owner: $(get "$(trinity $INSTANCE_OWNER /identity/door/trust)")"
echo " light->owner: $(get "$(trinity $INSTANCE_OWNER /identity/light/trust)")"
echo "heater->owner: $(get "$(trinity $INSTANCE_OWNER /identity/heater/trust)")"
echo
delay
echo "# Exporting delegation certificates..."
echo
DOOR_DELEG=$(get "$(trinity $INSTANCE_OWNER /identity/door/trust/export )"     | sed 's/"//g')
LIGHT_DELEG=$(get "$(trinity $INSTANCE_OWNER /identity/light/trust/export )"   | sed 's/"//g')
HEATER_DELEG=$(get "$(trinity $INSTANCE_OWNER /identity/heater/trust/export )" | sed 's/"//g')
echo "  door->owner: $DOOR_DELEG"
echo " light->owner: $LIGHT_DELEG"
echo "heater->owner: $HEATER_DELEG"
echo
delay
echo "# Verifying trust between devices and owner..."
echo
echo "Note: This is not a cryptographic end-to-end verification"
echo "      but a global-view verification from the point of view"
echo "      of a third party. However, the principles are the same."
echo "      For details, please check the commends in the demo script."
echo "      For a proper cryptographic verification please take a"
echo "      look at the handshake example/"
echo
delay
# In practice, this verification is a step done during handshaking by
# the verifying party. The verifying party here are the devices (door,
# light, heater).
# The initial delegation done by the device is usually not published
# and only needs to be known to the device itself. Consider this data
# (eg. $DOOR_DELEG) originating from within the local trust store or
# configuration of the device (eg. door).
# In short: here, the owner would not have to provide any additional
# proof-of-delegation because she's directly trusted by each device.
VER_DO=$(build_verification $DOOR_KEY $OWNER_KEY "action:{control.door}" $DOOR_DELEG)
VER_LO=$(build_verification $LIGHT_KEY $OWNER_KEY "action:{control.light}" $LIGHT_DELEG)
VER_HO=$(build_verification $HEATER_KEY $OWNER_KEY "action:{control.heating}" $HEATER_DELEG)

echo "   owner can control door?: $(post "$(trinity $INSTANCE_GV /verify/trust)" "$VER_DO")"
echo "  owner can control light?: $(post "$(trinity $INSTANCE_GV /verify/trust)" "$VER_LO")"
echo " owner can control heater?: $(post "$(trinity $INSTANCE_GV /verify/trust)" "$VER_HO")"
echo
delay

echo "# Verifying trust between devices and friend..."
echo
echo "Note: the friend has no access, so everything should fail."
# This verification is the same as above.
# No additional proof data except what the devices already
# know themselves is provided.
# However, this time we're seeing if the friend is able to
# exert control over the devices (spoiler: of course not)
VER_DF=$(build_verification $DOOR_KEY $FRIEND_KEY "action:{control.door}" $DOOR_DELEG)
VER_LF=$(build_verification $LIGHT_KEY $FRIEND_KEY "action:{control.light}" $LIGHT_DELEG)
VER_HF=$(build_verification $HEATER_KEY $FRIEND_KEY "action:{control.heating}" $HEATER_DELEG)

echo "  friend can control door?: $(post "$(trinity $INSTANCE_GV /verify/trust)" "$VER_DF")"
echo " friend can control light?: $(post "$(trinity $INSTANCE_GV /verify/trust)" "$VER_LF")"
echo "friend can control heater?: $(post "$(trinity $INSTANCE_GV /verify/trust)" "$VER_HF")"
echo
delay








echo;echo;echo;echo
echo "-- ACT 2: Delegating some --------------------------------"
echo
echo "# Owner delegates PARTIAL control..."
echo
echo "door trust friend with light: $(post "$(trinity $INSTANCE_OWNER /identity/owner/trust/$FRIEND_KEY )" "$LIGHT_POL")"
echo
delay
echo "# Listing relationships of owner..."
echo
echo "owner->friend: $(get "$(trinity $INSTANCE_OWNER /identity/owner/trust)")"
echo
delay
echo "# Exporting owner delegation certificates..."
echo
OWNER_DELEG=$(get "$(trinity $INSTANCE_OWNER /identity/owner/trust/export )"     | sed 's/"//g')
echo "owner->friend: $OWNER_DELEG"
echo
delay
echo "# Verifying trust between devices and friend..."
echo
echo "Note: With the additional delegation of the owner"
echo "      the friend is now able to control the light."
echo "      But _only_ the light."
echo
delay
# As above, but additionally the friend provides a delegation she received
# from the owner (here: $OWNER_DELEG).
# In practices this additional delegation would be only thing the friend
# presents to the respective devices. The initial delegation done by
# the device (eg. $DOOR_DELEG by the door) is known to the device already.
VER_DF=$(build_verification $DOOR_KEY $FRIEND_KEY "action:{control.door}" $DOOR_DELEG $OWNER_DELEG)
VER_LF=$(build_verification $LIGHT_KEY $FRIEND_KEY "action:{control.light}" $LIGHT_DELEG $OWNER_DELEG)
VER_HF=$(build_verification $HEATER_KEY $FRIEND_KEY "action:{control.heating}" $HEATER_DELEG $OWNER_DELEG)

echo "  friend can control door?: $(post "$(trinity $INSTANCE_GV /verify/trust)" "$VER_DF")"
echo " friend can control light?: $(post "$(trinity $INSTANCE_GV /verify/trust)" "$VER_LF")"
echo "friend can control heater?: $(post "$(trinity $INSTANCE_GV /verify/trust)" "$VER_HF")"
echo
delay








echo;echo;echo;echo
echo "-- ACT 3: Delegating all ---------------------------------"
echo
echo "# Owner delegates FULL control..."
echo
echo "door trust friend with light: $(post "$(trinity $INSTANCE_OWNER /identity/owner/trust/$FRIEND_KEY )" "$FULL_CTRL_POL")"
echo
delay
echo "# Listing relationships of owner..."
echo
echo "owner->friend: $(get "$(trinity $INSTANCE_OWNER /identity/owner/trust)")"
echo
delay
echo "# Exporting owner delegation certificates..."
echo
OWNER_DELEG=$(get "$(trinity $INSTANCE_OWNER /identity/owner/trust/export )"     | sed 's/"//g')
echo "owner->friend: $OWNER_DELEG"
echo
delay
echo "# Verifying trust between devices and friend..."
echo
echo "Note: With the broader delegation of the owner"
echo "      the friend is now able to control all devices."
echo "      And do so with a single delegation."
echo
delay
# As above, but additionally the friend provides a delegation she received
# from the owner (here: $OWNER_DELEG).
# In practices this additional delegation would be only thing the friend
# presents to the respective devices. The initial delegation done by
# the device (eg. $DOOR_DELEG by the door) is known to the device already.
VER_DF=$(build_verification $DOOR_KEY $FRIEND_KEY "action:{control.door}" $DOOR_DELEG $OWNER_DELEG)
VER_LF=$(build_verification $LIGHT_KEY $FRIEND_KEY "action:{control.light}" $LIGHT_DELEG $OWNER_DELEG)
VER_HF=$(build_verification $HEATER_KEY $FRIEND_KEY "action:{control.heating}" $HEATER_DELEG $OWNER_DELEG)

echo "  friend can control door?: $(post "$(trinity $INSTANCE_GV /verify/trust)" "$VER_DF")"
echo " friend can control light?: $(post "$(trinity $INSTANCE_GV /verify/trust)" "$VER_LF")"
echo "friend can control heater?: $(post "$(trinity $INSTANCE_GV /verify/trust)" "$VER_HF")"
echo

