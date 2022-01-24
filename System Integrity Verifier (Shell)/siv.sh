#!/bin/bash

############################################ checking the number of command line arguments #################################################
if [ "$#" = 5 ];then

######################################### To verify if the hash function is supported by siv program #######################################
a="md5"
b="sha1"
pwd=$(pwd)
if [ \( "$5" = "$a" \) -o \( "$5" = "$b" \) ]
then
h=$5
echo "---> The specifed hash function $5 is supported by siv program"
else
echo "################################################################################################"
echo "#                                                                                              #"
echo "#! The program does not support entered hash function in the argument command line interface  !#"
echo "#                                                                                              #"
echo "################################################################################################"
exit 0
fi
############################################### INITIALIZATION MODE FOR SIV PROGRAM ########################################################
c="-i"
if [ $1 = $c ]
then
find . -type f -name "*~" -exec rm -f {} \;
echo "                                  "
echo "##################################"
echo "#                                #"
echo "#  ENTERING INITIALIZATION MODE  #"
echo "#                                #"
echo "##################################"
echo "                                  "

date1=$(date -u +"%s")
######################################## Checking if the specified monitored directory exists ##############################################
if [ -d "$2" ]
then
    echo "---> The specified monitored directory $2 exists"
echo "                                  "

else
    echo "!!!The specified monitored directory $2  does not exists!!!"
echo "                                  "
fi
############################### checking if the verification file  is present inside or outside the directory ##############################
if [ ! -f "$3" ]
then
    echo "---> The verification file $3 is present outside the specified monitored directories"
echo "                                  "

else
    echo "!!!The verification file $3 is present inside the specified monitored directory!!!"
echo "                                  "
fi

################################# checking if the report file is present inside or outside the directory ###################################
if [ ! -f "$4" ]
then
    echo "---> The report file $4 is present outside the specified monitored directory"
echo "                                  "

else
    echo "!!!The report file $4 is present inside the specified monitored directory!!!"
echo "                                  "
fi
 

############################################## VERIFICATION FILE OVERWRITING ###############################################################

##################################        Reading if the specified verification file exits       ###########################################
if [ -f "$3" ]
then
echo "                                                                                                     "
echo "                                         !!! WARNING !!!                                             "
echo "---> The verification file exists in the path $3 already, Do you want to overwrite the existing file "
echo "---> Enter [ yes/no: ]"
read value
ans="yes"

########################################## if else loop for over-write the verification file ###############################################
if [ $value = $ans ]
then																												
echo "---> The file found in path $3 is over-writing.........."
echo "---> You can find your new verification file in $4 location "
echo "---> Please be patient !!!"  
echo " ">$3
for line in $(find $2 -type f)
do
echo "$line#$(stat -c%s "$line")#$(stat -c%U "$line")#$(stat -c%G "$line")#$(stat -c%a "$line")#$(stat -c%y "$line")#$($5sum $line | awk -F" " '{print $1}')">>$3
done
for line in $(find $2 -type d)
do
echo "$line#$(stat -c%s "$line")#$(stat -c%U "$line")#$(stat -c%G "$line")#$(stat -c%a "$line")#$(stat -c%y "$line")">>$3
done
else
echo "                                                                                               "
echo "                                    !!!!! WARNING !!!!!                                        "
echo "         Change the verification file name or its path inorder to continue further             "
echo "                                  See you again! Bye!!                                         "
echo "                              The program is going to terminate .........                      "
exit 0
fi

######################################### if else loop to over-write verification file closes ##############################################
else
echo "---> You can find your new verification file in $3 location "
echo "---> Please be patient !!!"  

#*************************************************ACCESS RIGHTS TO THE FILE; NAME OF USER OWNING THE FILE; NAME OF GROUP OWNING THE FILE; SIZE OF THE FILE; LAST MODIFICATION DATE****************************************************
#*COMPUTED MESSAGE DIGEST WITH SPECIFIED HASH FUNCTON OVER FILE CONTENT; FULL PATH TO FILE, INCLUDING FILE NAME********************************
echo " ">$3
for line in $(find $2 -type f)
do
echo "$line#$(stat -c%s "$line")#$(stat -c%U "$line")#$(stat -c%G "$line")#$(stat -c%a "$line")#$(stat -c%y "$line")#$($5sum $line | awk -F" " '{print $1}')">>$3
done
for line in $(find $2 -type d)
do
echo "$line#$(stat -c%s "$line")#$(stat -c%U "$line")#$(stat -c%G "$line")#$(stat -c%a "$line")#$(stat -c%y "$line")">>$3
done
fi

################################################### REPORT FILE OVERWRITING ################################################################

#####################################    Reading if the specified report file exits     ####################################################
if [ -f "$4" ]
then
echo "                                                                                               "
echo "                                     !!! WARNING !!!                                           "
echo "The report file exists in the path $4 already, Do you want to overwrite the existing file   "
echo "Enter [ yes/no: ]"
read value
ans="yes"

############################################ if else loop for over-write the report file ###################################################
if [ $value = $ans ]
then																												
echo "---> The report file found in path $4 is over-written.........."
echo "----> You can find your new report file in $4 location "

echo "######################################################### REPORT FILE ###############################################################" >$4
echo "Full pathname to monitored Directory: $2">>$4

echo "Full pathname to Verification file  : $pwd/$3">>$4

g=` find $2 -type d | wc -l `
echo "Number of directories parsed        : $g">>$4
h=` find $2 -type f | wc -l `
echo "Number of files parsed              : $h">>$4
date2=$(date -u +"%s")
diff=$(($date2-$date1))
echo "Time for the initialization mode    : $(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed.">>$4
else
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! WARNING !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "                                                                                               "
echo "             Change the report file name or its path inorder to continue further               "
echo "                                    See you again! Bye!!                                       "
echo "                             The program is going to terminate.........                        "
fi

############################################ if else loop to over-write report file closes #################################################
else
echo "---> You can find your new report file in $4 location "
echo "######################################################### REPORT FILE ###############################################################" >$4
echo "                                  "
echo "Full pathname to monitored Directory:$2">>$4

echo "Full pathname to Verification file  : $pwd/$3">>$4

g=` find $2 -type d | wc -l `
echo "Number of directories parsed:$g">>$4
h=` find $2 -type f | wc -l `
echo "Number of files parsed:$h">>$4
date2=$(date -u +"%s")
diff=$(($date2-$date1))
echo "Time to complete the initialization mode:$(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed.">>$4
fi

##Storing initialization mode verification file in to a temp file vinit for comparsion of changes
#cat $3>siv_init_temp
################################################## VERIFICATION MODE #######################################################################
#######################################         -i/-v mode else loop              ##########################################################
else
echo "                                  "
echo "################################"
echo "#                              #"
echo "#  ENTERING VERIFICATION MODE  #"
echo "#                              #"
echo "################################"
echo "                                  "

date1=$(date -u +"%s")

######################################## Checking if the specified verification file exists #################################################
if [ -f "$3" ]
then
    echo "---> The specified verification file $3 exists"
else
    echo "!!!The specified verification file $3 does not exists!!!"
fi

############################### checking if the verification file is present inside or outside the directory ###############################
if [ ! -f "$3" ]
then
    echo "---> The verification file $3 is present outside the specified monitored directory"
else
    echo "!!!The verification file $3 is present inside the specified monitored directory!!!"
fi

################################# checking if the report file is present inside or outside the directory ###################################
if [ ! -f "$4" ]
then
    echo "---> The report file $4 is present outside the specified monitored directory"
else
    echo "!!!The report file $4 is present inside the specified monitored directory!!!"
fi

echo " Please be patient !!!"  
gfile='gfile.txt'

##Storing verification mode verification file in to a temp file for comparsion of changes
echo " ">$gfile
for line in $(find $2 -type f)
do
echo "$line#$(stat -c%s "$line")#$(stat -c%U "$line")#$(stat -c%G "$line")#$(stat -c%a "$line")#$(stat -c%y "$line")#$($5sum $line | awk -F" " '{print $1}')">>$gfile
done
for line in $(find $2 -type d)
do
echo "$line#$(stat -c%s "$line")#$(stat -c%U "$line")#$(stat -c%G "$line")#$(stat -c%a "$line")#$(stat -c%y "$line")">>$gfile
done
#Finding differences
warfile="war.txt";

cmp -s $gfile $3 > /dev/null
if [ $? -eq 1 ]; then
echo "Modifications are done to $2 !!!" > $warfile;
echo "--------------------------------------------------------- WARNINGS -------------------------------------------------------------" >> $warfile;

#files created for caomparsion algorithm
verify_veri='verify_veri.txt'
verify_init='verify_init.txt'
initveri='initveri.txt'
veriinit='veriinit.txt'

echo " " >> $warfile;
cat $gfile | awk -F"#" '{print $1}' > $verify_veri
cat $3 | awk -F"#" '{print $1}' > $verify_init 

#To find if any files are added.
echo " WARNING --- Added files/Directories: " >>$warfile
echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
diff $verify_veri $verify_init | grep "<" | awk -F" " '{print $2}' >> $warfile;
diff $verify_veri $verify_init | grep "<" | awk -F" " '{print $2}' > $initveri;
echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
wa=`diff $verify_veri $verify_init | grep "<" | awk -F" " '{print $2}' | wc -l`

#To find if any files are removed.
echo " WARNING --- Removed Files/Directories: " >>$warfile;
echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
diff $verify_veri $verify_init | grep ">" | awk -F" " '{print $2}' >> $warfile;
diff $verify_veri $verify_init | grep ">" | awk -F" " '{print $2}' >> $initveri;
echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
wr=`diff $verify_veri $verify_init | grep ">" | awk -F" " '{print $2}'| wc -l`

#WARNINGS=$(diff $gfile $3 | grep -ci "#")
#WARNINGS=$((WARNINGS - $(cat $initveri | wc -l)))
#WARNINGS=$((WARNINGS/2 + $(cat $initveri | wc -l)))

array=$(cat $initveri)
echo ${array[*]} > $veriinit

#To find if any files with a different size than recorded.

echo " WARNING --- Files with a different size than recorded: " >>$warfile;
echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
cat $gfile | awk -F"#" '{ getline line<"veriinit.txt"; if (line !~ $1) {print $1 " " $2}}' > $verify_veri
cat $3 | awk -F"#" '{ getline line<"veriinit.txt"; if (line !~ $1) {print $1 " " $2}}' > $verify_init
diff $verify_veri $verify_init | grep ">" | awk -F" " '{print $2}' >> $warfile;
echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
ws=`diff $verify_veri $verify_init | grep ">" | awk -F" " '{print $2}' | wc -l`

#To find if any files with a different message digest than computed before.
echo " WARNING --- Files with a different message digest than computed before:" >>$warfile;
echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
cat $gfile | awk -F"#" '{ getline line<"veriinit.txt"; if (line !~ $1) {print $1 " " $7}}' > $verify_veri
cat $3 | awk -F"#" '{ getline line<"veriinit.txt"; if (line !~ $1) {print $1 " " $7}}' > $verify_init
diff $verify_veri $verify_init | grep ">" | awk -F" " '{print $2}' >> $warfile;
echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
wm=`diff $verify_veri $verify_init | grep ">" | awk -F" " '{print $2}'|wc -l`

#To find if any files user name are modified.
echo " WARNING --- Files with modified user/group:" >>$warfile;
echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
cat $gfile | awk -F"#" '{ getline line<"veriinit.txt"; if (line !~ $1) {print $1 " " $3 " " $4}}' > $verify_veri
cat $3 | awk -F"#" '{ getline line<"veriinit.txt"; if (line !~ $1) {print $1 " " $3 " " $4}}' > $verify_init
diff $verify_veri $verify_init | grep ">" | awk -F" " '{print $2}' >> $warfile;
echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
wug=`diff $verify_veri $verify_init | grep ">" | awk -F" " '{print $2}' |wc -l`

echo " WARNING --- Files with modified access rights:" >> $warfile;
echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
cat $gfile | awk -F"#" '{ getline line<"veriinit.txt"; if (line !~ $1) {print $1 " " $5}}' > $verify_veri
cat $3 | awk -F"#" '{ getline line<"veriinit.txt"; if (line !~ $1) {print $1 " " $5}}' > $verify_init
diff $verify_veri $verify_init | grep ">" | awk -F" " '{print $2}' >> $warfile;
echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
wrr=`diff $verify_veri $verify_init | grep ">" | awk -F" " '{print $2}'|wc -l`

echo " WARNING --- Files/Directories with a different modification date:" >> $warfile;
echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
cat $gfile | awk -F"#" '{ getline line<"veriinit.txt"; if (line !~ $1) {print $1 " " $6}}' > $verify_veri
cat $3 | awk -F"#" '{ getline line<"veriinit.txt"; if (line !~ $1) {print $1 " " $6}}' > $verify_init
diff $verify_veri $verify_init | grep ">" | awk -F" " '{print $2}' >> $warfile;

echo "--------------------------------------------------------------------------------------------------------------------------------" >>$warfile
wd=`diff $verify_veri $verify_init | grep ">" | awk -F" " '{print $2}' |wc -l`


else
echo "Modifications are not done in the monitored directory: $2" > $warfile;
#echo "NO WARNINGS: HAVE A NICE DAY " >> $warfile;
wa="0";
wr="0";
ws="0";
wm="0";
wug="0";
wrr="0";
wd="0";
fi

echo "######################################################### REPORT FILE ################################################" >$4
echo "Full pathname to monitored Directory: $2">>$4
echo "Full pathname to Verification file  : $pwd/$3">>$4
echo "Full pathname to report file: $pwd/$4">>$4
p=` find $2 -type d | wc -l `
echo "Number of directories parsed: $p">>$4
q=` find $2 -type f | wc -l `
echo "Number of files parsed: $q">>$4
echo "                                                 ">>$4
cat $warfile >> $4;
cat $gfile > $3;
warnings_count=$(($wa+$wr+$ws+$wm+$wug+$wrr+$wd));
echo "THE TOTAL NUMBER OF WARNINGS ISSUED: $warnings_count">>$4



date2=$(date -u +"%s")
diff=$(($date2-$date1))
echo "Time to complete the verification mode:$(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed.">>$4
fi


if [[ -f "$gfile" ]]; then
rm $gfile;
fi
if [[ -f "$warfile" ]]; then
rm $warfile;
fi
if [[ -f "$verify_init" ]]; then
rm $verify_init;
fi
if [[ -f "$verify_veri" ]]; then
rm $verify_veri;
fi
if [[ -f "$initveri" ]]; then
rm $initveri;
fi
if [[ -f "$veriinit" ]]; then
rm $veriinit;
fi


###############################Number of arguments loop closing in initialization mode######################################################
else
echo "                                  "
echo "###########################################################################"
echo "#                                                                         #"
echo "#~ Illegal number of arguments, Please enter the command again correctly ~#"
echo "#                     You have entered $# arguments                        #"
echo "#         You must only enter exactly 5 command line arguments            #"
echo "#                                                                         #"
echo "###########################################################################"
exit 0
fi
