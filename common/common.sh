#!/bin/sh
## The Whitesands base-URL
WHITESANDS="$WHITESANDS_URL/api/v2"

## Credentials for Whitesands
CREDS="-u $WHITESANDS_USER:$WHITESANDS_PASS"

# Assemble a Whitesands URL
#
# $1: Query string
function ws_url {
	echo "$WHITESANDS$1"
}

# Assemble a Whitesands instance URL
#
# $1: Instance name
# $2: Query string (optional)
function instance {
	ws_url "/instance/$1$2"
}


# Assemble a Whitesands instance URL
#
# $1: Instance name
# $2: Query string (optional)
function trinity {
	instance "$1" "/trinity/api/v1$2"
}


# Execute POST request
#
# $1: URL to post to
# $2: Optional data to post
function post {
	#>&2 echo "POST $1 $2"
	curl -s $CREDS -X POST --header 'Content-Type: application/json' --data "$2" "$1"
}

# Execute GET request
#
# $1: URL to get
function get {
	#>&2 echo "GET $1"
	curl -s $CREDS $1
}

# Combines bare delegations without quotes around them into quoted strings
# in a comma-separated list
#
# $@: exported signed delegations
function combine_delegations () {
	RES=""
	if [ ! -z $1 ]; then
		RES="\"$1\""
		shift
		for del in "$@"; do
	 		RES="$RES,\"$del\""
		done
	fi
	echo "$RES"
}

# The current time in a format suitable for trinityd
function now () {
	date --iso-8601=seconds --utc
}

# Build a verification job
#
# $1: source key
# $2: target key
# $3: required policy
# $4..$n: delegation proofs
function build_verification () {
SOURCE=$1; shift
TARGET=$1; shift
REQ_POL=$1; shift
PROOF=$(combine_delegations $@)
cat << EOF
{
  "source": "$SOURCE",
  "target": "$TARGET",
  "language": "$LANG",
  "policy": "$REQ_POL",
  "at_time": "$(now)",
  "certificates": [ $PROOF ]
}
EOF
}


function build_hs_challenge () {
REQ_POL=$1; shift
cat << EOF
{
  "language": "$LANG",
  "min_policy": "$REQ_POL"
}
EOF
}


function build_hs_response () {
CHALLENGE=$1; shift
PROOF=$(combine_delegations $@)
ret=$(cat << EOF
{
  "challenge": "$CHALLENGE",
  "certificate": [ $PROOF ]
}
EOF
)
#echo "$ret" >&2
echo "$ret"
}

function build_hs_verification () {
CHALLENGE=$1; shift
RESPONSE=$1; shift
ret=$( cat << EOF
{
  "challenge": "$CHALLENGE",
  "response": "$RESPONSE"
}
EOF
)
#echo "$ret" >&2
echo "$ret"
}


function report () {
	echo "Whitesands URL: $WHITESANDS_URL"
	echo "Whitesands User: $WHITESANDS_USER"
	echo "Whitesands instances: $WHITESANDS_INSTANCE_1, $WHITESANDS_INSTANCE_2, $WHITESANDS_INSTANCE_3, $WHITESANDS_INSTANCE_4, $WHITESANDS_INSTANCE_5"
}

function delay() {
	if [ -z ${MANUAL+x} ]; then
		if [ ! -z ${DELAY+x} ]; then
			sleep $DELAY
		fi
	else
		read  -n 1 -p "Press <ENTER> to continue" mainmenuinput
		echo;echo
	fi
}
