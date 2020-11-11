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
# build the basic challenge request
HS_CHR_DO=$(build_hs_challenge "action:{control.door}")
HS_CHR_LO=$(build_hs_challenge "action:{control.light}")
HS_CHR_HO=$(build_hs_challenge "action:{control.heating}")

# use the challenge request to create a cryptographically signed challenge
HS_CH_DO=$(post "$(trinity $INSTANCE_OWNER /identity/door/handshake/challenge)" "$HS_CHR_DO"   | sed 's/"//g')
HS_CH_LO=$(post "$(trinity $INSTANCE_OWNER /identity/light/handshake/challenge)" "$HS_CHR_LO"  | sed 's/"//g')
HS_CH_HO=$(post "$(trinity $INSTANCE_OWNER /identity/heater/handshake/challenge)" "$HS_CHR_HO" | sed 's/"//g')

# create requests to manufacture a suitable response object
# by adding the device's trust delegations into the mix as proofs
HS_RESR_DO=$(build_hs_response "$HS_CH_DO" "$DOOR_DELEG")
HS_RESR_LO=$(build_hs_response "$HS_CH_LO" "$LIGHT_DELEG")
HS_RESR_HO=$(build_hs_response "$HS_CH_HO" "$HEATER_DELEG")

# now use it to create the cryptographically signed responses
HS_RES_DO=$(post "$(trinity $INSTANCE_OWNER /identity/owner/handshake/response)" "$HS_RESR_DO" | sed 's/"//g')
HS_RES_LO=$(post "$(trinity $INSTANCE_OWNER /identity/owner/handshake/response)" "$HS_RESR_LO" | sed 's/"//g')
HS_RES_HO=$(post "$(trinity $INSTANCE_OWNER /identity/owner/handshake/response)" "$HS_RESR_HO" | sed 's/"//g')

# now we need to create yet another request structure to trigger a verification
HS_VERR_DO=$(build_hs_verification "$HS_CH_DO" "$HS_RES_DO")
HS_VERR_LO=$(build_hs_verification "$HS_CH_LO" "$HS_RES_LO")
HS_VERR_HO=$(build_hs_verification "$HS_CH_HO" "$HS_RES_HO")


# Note: at this point the handshake verification could be done by anyone! Does not need to be the owner.
echo "   owner can control door?: $(post "$(trinity $INSTANCE_OWNER /verify/handshake)" "$HS_VERR_DO")"
echo "  owner can control light?: $(post "$(trinity $INSTANCE_OWNER /verify/handshake)" "$HS_VERR_LO")"
echo " owner can control heater?: $(post "$(trinity $INSTANCE_OWNER /verify/handshake)" "$HS_VERR_HO")"
echo
delay

echo "# Verifying trust between devices and friend..."
echo
echo "Note: the friend has no access, so everything should fail."
echo "Note: we actually will not reach the point where we can verify"
echo "      the handshake, rather we already fail at creating a response."
echo


# we're not trying to generate responses to the previously generated challenges
echo "  friend can control door?: $(post "$(trinity $INSTANCE_FRIEND /identity/friend/handshake/response)" "$HS_RESR_DO" | sed 's/"//g')"
echo " friend can control light?: $(post "$(trinity $INSTANCE_FRIEND /identity/friend/handshake/response)" "$HS_RESR_LO" | sed 's/"//g')"
echo "friend can control heater?: $(post "$(trinity $INSTANCE_FRIEND /identity/friend/handshake/response)" "$HS_RESR_HO" | sed 's/"//g')"

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

HS_RESR_LO=$(build_hs_response "$HS_CH_LO" "$LIGHT_DELEG" "$OWNER_DELEG")

# we're not trying to generate responses to the previously generated challenges
RESP_DO=$(post "$(trinity $INSTANCE_FRIEND /identity/friend/handshake/response)" "$HS_RESR_DO" | sed 's/"//g')
RESP_LO=$(post "$(trinity $INSTANCE_FRIEND /identity/friend/handshake/response)" "$HS_RESR_LO" | sed 's/"//g')
RESP_HO=$(post "$(trinity $INSTANCE_FRIEND /identity/friend/handshake/response)" "$HS_RESR_HO" | sed 's/"//g')

echo "  friend response to door challenge: $RESP_DO"
echo " friend response to light challenge: $RESP_LO"
echo "friend response to heater challenge: $RESP_HO"
echo
echo "Note: at this point, it only makes sense to proceed with the verification for light."
echo
delay

# now we need to create yet another request structure to trigger a verification
HS_VERR_LO=$(build_hs_verification "$HS_CH_LO" "$RESP_LO")

# Note: at this point the handshake verification could be done by anyone! Does not need to be the owner.
echo "friend can control light?: $(post "$(trinity $INSTANCE_OWNER /verify/handshake)" "$HS_VERR_LO")"
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

HS_RESR_DO=$(build_hs_response "$HS_CH_DO" "$DOOR_DELEG" "$OWNER_DELEG")
HS_RESR_LO=$(build_hs_response "$HS_CH_LO" "$LIGHT_DELEG" "$OWNER_DELEG")
HS_RESR_HO=$(build_hs_response "$HS_CH_HO" "$HEATER_DELEG" "$OWNER_DELEG")

# we're not trying to generate responses to the previously generated challenges
RESP_DO=$(post "$(trinity $INSTANCE_FRIEND /identity/friend/handshake/response)" "$HS_RESR_DO" | sed 's/"//g')
RESP_LO=$(post "$(trinity $INSTANCE_FRIEND /identity/friend/handshake/response)" "$HS_RESR_LO" | sed 's/"//g')
RESP_HO=$(post "$(trinity $INSTANCE_FRIEND /identity/friend/handshake/response)" "$HS_RESR_HO" | sed 's/"//g')

# now we need to create yet another request structure to trigger a verification
HS_VERR_DO=$(build_hs_verification "$HS_CH_DO" "$RESP_DO")
HS_VERR_LO=$(build_hs_verification "$HS_CH_LO" "$RESP_LO")
HS_VERR_HO=$(build_hs_verification "$HS_CH_HO" "$RESP_HO")

# Note: at this point the handshake verification could be done by anyone! Does not need to be the owner.
echo "  friend can control door?: $(post "$(trinity $INSTANCE_OWNER /verify/handshake)" "$HS_VERR_DO")"
echo " friend can control light?: $(post "$(trinity $INSTANCE_OWNER /verify/handshake)" "$HS_VERR_LO")"
echo "friend can control heater?: $(post "$(trinity $INSTANCE_OWNER /verify/handshake)" "$HS_VERR_HO")"
echo

