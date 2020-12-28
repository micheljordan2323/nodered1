#!/bin/bash
# password setter for Node-RED on Raspberry Pi
# auther: utaani@ueno.org
# 
# usage: bash nradminpass.sh password
#
# this script will change Pi default Node-RED file.
# after that, you need nodered restart with node-red-restart

# password
INPUTPASS=$1
# target settings.js
SETTINGSJS="./settings.js"

# check edited setting.js
CHECKER=`grep '//    type: "credentials",' $SETTINGSJS`
if [ -z "$CHECKER" ]; then
    echo "changed settings.js found. you must change settings.js by hand."
    exit 1
fi

# create password crypted string
ADMINPASS=`/usr/bin/node -e "console.log(require('/usr/lib/node_modules/node-red/node_modules/bcryptjs/dist/bcrypt.min.js').hashSync('$INPUTPASS'));"`

# backup org file
cp $SETTINGSJS $SETTINGSJS.org

# replace adminAuth line
REPLINE="adminAuth: { type:\"credentials\", users: [{ username: \"admin\", password: \"$ADMINPASS\", permissions: \"*\" }] },"
sed -i "/adminAuth\:/c $REPLINE" $SETTINGSJS 
