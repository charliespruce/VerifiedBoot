OPTEEversion="3.14.0"


echo "____   ____           .__  _____.__           .___ __________               __    "
echo "\   \ /   /___________|__|/ ____\__| ____   __| _/ \______   \ ____   _____/  |_  "
echo " \   Y   // __ \_  __ \  \   __\|  |/ __ \ / __ |   |    |  _//  _ \ /  _ \   __\ "
echo "  \     /\  ___/|  | \/  ||  |  |  \  ___// /_/ |   |    |   (  <_> |  <_> )  |   "
echo "   \___/  \___  >__|  |__||__|  |__|\___  >____ |   |______  /\____/ \____/|__|   "
echo "              \/                        \/     \/          \/                     "

echo "               (OP-TEE $OPTEEversion) By Anna Shortt & Charlie Spruce"

./initialise.sh; ./buildfit.sh; ./rebuild.sh; ./format.sh $1
