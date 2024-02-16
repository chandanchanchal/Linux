#!/bin/bash
#-----------------------------------------------------------------------------------
# "SSL_AUTO Script" Version 1.0, Created by Online Instructions
#-----------------------------------------------------------------------------------
# use -p /--path to customize the path of the certificates folders.
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Default Variables
KEYSIZE="2048"
SIGNALG="SHA256withRSA"
KEYALG="rsa"
GSKCMD="gskcapicmd"
LCMD="keytool"
OPNCMD="openssl"
OPNALG="sha256"
ORAPKI="orapki"
PATH_VALUE=`pwd`
NOW=`date '+%F_%H_%M_%S'`
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

##############################################################

#########################
# The command line help #
#########################
display_help() {
    echo "Usage: $0 [option...]" >&2
    echo
    echo "-p / --path - Change Path of your installation of Certficates with custom folder"
    echo "-k / --keysize - Provide Keysize (2048/4096)"
    echo "-s / --signalg - Provide a valid SIGNALG"
    echo "-o / --OPENSSLALG - Only used in terms of OPEN SSL (sha256/sha512)"
    echo
    # echo some stuff here for the -a or --add-options
    exit 1
}

################################
# Check if parameters options  #
# are given on the commandline #
################################
while :
do
    case "$1" in
      -p | --path)
          PATH_VALUE=$2
          shift 2
          ;;
      -h | --help)
          display_help  # Call your function
          exit 0
          ;;
      -k | --keysize)
           KEYSIZE=$2
           shift 2
           ;;

      -s | --signalg)
           SIGNALG=$2
           shift 2
           ;;

      -o | --OPENSSLALG)
           OPNALG=$2
           shift 2
           ;;

      --) # End of all options
          shift
          break
          ;;
      -*)
          echo "Error: Unknown option: $1" >&2
          ## or call function display_help
          exit 1
          ;;
      *)  # No more options
          break
          ;;
    esac
done

##############################################################
echo "*********************Confirm if you have taken a backup of your keys [Y/N]**********************"
read BACKCONFIM
        if [ "$BACKCONFIM" == "Y" ] ; then
                echo
        elif [ "$BACKCONFIM" == "y" ] ; then
                echo
        else
                echo "Please Take A Backup Of The Exiting Files"
                exit;
        fi
#echo "*****************************************************************************************"
echo 
echo "************************************************************************************************"
echo "                            Certficate Creation Tool (Version: 1.0)                             "
echo "************************************************************************************************"
echo "Change Log: V1"
echo "************************************************************************************************"
echo "Press 1: To Build A New KDB/P12 & CSR (IBM HTTP / IBM MQ / Datapower) (SAN Includes: */:)"
echo "Press 2. To Build A New  JKS & CSR (Weblogic / Tomcat) (SAN Only has:letters,digits, '-')"
echo "Press 3. To Build A New New OPENSSL & CSR (Apache HTTP Server / LB / Nginx)"
echo "Press 4. To Convert JKS to P12 (WebSphere or Liberty)"
echo "Press 5. To Convert JKS to wallet [Create JKS] (OHS)"
echo "Press 6. To Add/recieve a new certificate for KDB/P12"
echo "Press 7. To Add/recieve a new certificate for JKS"
echo "Press 8. To Verify The Certificate On Website"
echo "Press 9. To View/Modify An Existing KDB/P12"
echo "Press 10. To Duplicate / Detailed View From A KDB/JKS/P12 File"
echo "Press 11. To View/Modify An Existing JKS"
echo "Press 12. To Decrypt Stash File"
echo "Press 13. To Self Signed Certificates"
echo "************************************************************************************************"
echo " KeySize:$KEYSIZE | SIGNALG=$SIGNALG | KEYALG=$KEYALG | OPENSSL=$OPNALG | Date=$NOW"
echo "************************************************************************************************"
echo 
if [ $? == 1 ]; then
echo "Wrong folder / Check Permission"
exit;
fi
cd $PATH_VALUE
echo "Setting Your Home Directory - $PATH_VALUE"
echo
sleep 1
echo "Please Select An Option [1-13]:"
read OPTION
CONVERTP12()
{
        CONP12()
        {
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "Enter FILE Name Of the .jks (WITHOUT EXTENSION), which has been created and signed."
                read FINALJKS
                echo "Enter The JKS Password"
                read PASSJKS
                echo "Enter The Alias Name In The JKS"
                read ALIASJKS
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "Converting to P12"
                $LCMD -importkeystore -srckeystore $FINALJKS.jks -destkeystore $FINALJKS.p12 -srcstoretype JKS -deststoretype PKCS12 -srcstorepass $PASSJKS -deststorepass $PASSJKS -srcalias $ALIASJKS -destalias $ALIASJKS -srckeypass $PASSJKS -destkeypass $PASSJKS -noprompt
                echo "Your keystore is created view your keystore by typing: $GSKCMD -cert -details -label $ALIASJKS -db /$PATH_VALUE/$FINALJKS.p12 -pw $PASSJKS"
        }

        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "To Convert To P12, You First Need To Have Created .JKS and CSR, Have that Signed With Root, Inter & Personal Certficate"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Would You Like To Proceed [Y/N]"
        read CONFIM1
                if [ "$CONFIM1" == "Y" ] ; then
                echo "Gather Details For Your Converstion"
                CONP12
        elif [ "$CONFIM1" == "y" ] ; then
                echo "Gather Details For Your Converstion"
                CONP12
        else
                echo "Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
        fi
}
SELFSIGNED()
{
echo "Press 1. To Build A New KDB/P12 (IBM HTTP / IBM MQ / Datapower) (SAN Includes: */:)"
echo "Press 2. To Build A New JKS (Weblogic / Tomcat) (SAN Only has:letters,digits, '-')"
echo "Press 3. To Build A New New OPENSSL (Apache HTTP Server / LB / Nginx)"
sleep 1
echo "Please Select An Option [1-3]:"
read OPTION
SELFKDBP12()
{
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Your about to create a KDB/P12 File, this will create a new .kdb file in the  $PATH_VALUE and .csr file, please enter CTRL+C to cancel this operation"
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
        echo "Enter the FILE NAME [filename] IF YOU HAVE GIVEN WITH EXTENSION CTRL+C AND RESTART THE SCRIPT:"
        read FNAME
        echo "Enter the LABEL Name:"
        read ANAME
        echo "Enter the password for the LABEL NOTE: PASSWORD MUST BE 6+ LETTERS AND SHOULD BE COMPLEX:"
        read APASSWD
        echo "Enter the Common Name (CN):"
        read CNAME
        echo "Enter the Organisation Unit (OU):"
        read OUNAME
        echo "Enter the Organisation Name (O):"
        read ONAME
        echo "Enter the Location (L):"
        read LONAME
        echo "Enter the State Name (ST):"
        read STNAME
        echo "Enter the Country (C):"
        read CONAME
	echo "Expire (In Number of Days eg: 365)"
        read EXPIRE
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
        echo "Enter Your Choice [SAN / SAN+EMAIL / NO] Note: Its Mandatory that CN should be given as the SAN NAME"
        read SANNAME


        EXEONESAN()
        {
                $GSKCMD -keydb -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -stash -type $TYPE
                $GSKCMD -cert -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -size $KEYSIZE -type $TYPE -sig_alg $SIGNALG -label $ANAME -dn "CN=$CNAME,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME" -san_dnsname "`cat .tmp_san.txt`" -expire $EXPIRE
                if [ $? -eq 1 ] ; then
                        echo
                        echo "The GSK Command execution failed. Check if the /$PATH_VALUE/$FNAME.kdb file already exits or check if $GSKCMD command works fine"
                fi
                echo
                echo "Your Certificate is installed here $ANAME.$TYPE"
                echo "Your keystore details: "$GSKCMD -cert -details -label $ANAME -db /$PATH_VALUE/$FNAME.$TYPE -stashed""
                rm .tmp_san.txt
        }


        EXETWOSAN()
        {
                $GSKCMD -keydb -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -stash -type $TYPE
                $GSKCMD -cert -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -size $KEYSIZE -type $TYPE -sig_alg $SIGNALG -label $ANAME -dn "CN=$CNAME,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME" -san_dnsname "`cat .tmp_san.txt`" -san_emailaddr "`cat .tmp_sane.txt`" -expire $EXPIRE
                if [ $? -eq 1 ] ; then
                        echo
                        echo "The GSK Command execution failed. Check if the /$PATH_VALUE/$FNAME.kdb file already exits or check if $GSKCMD command works fine"
                fi
                echo
                echo "Your Certificate is installed here $ANAME.$TYPE"
                echo "Your keystore details: "$GSKCMD -cert -details -label $ANAME -db /$PATH_VALUE/$FNAME.$TYPE -stashed""
                rm .tmp_san.txt
                rm .tmp_sane.txt
        }


        EXENOSAN()
        {
                $GSKCMD -keydb -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -stash -type $TYPE
                $GSKCMD -cert -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -size $KEYSIZE -type $TYPE -sig_alg $SIGNALG -label $ANAME -dn "CN=$CNAME,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME" -expire $EXPIRE
                if [ $? -eq 1 ] ; then
                        echo
                        echo "The GSK Command execution failed. Check if the /$PATH_VALUE/$FNAME.kdb file already exits or check if $GSKCMD command works fine"
                fi
                echo
                echo "Your Certificate is installed here $ANAME.$TYPE"
                echo "Your keystore details: "$GSKCMD -cert -details -label $ANAME -db /$PATH_VALUE/$FNAME.$TYPE -stashed""
        }



        WISAN()
        {
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN DNS Entry are you planning to enter[0-9]"
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify DNS"
                echo "Enter the DNS address"
                read FIRSTSAN
                echo -n $FIRSTSAN"," >> .tmp_san.txt
                done
                echo "All The Values You Have Given Is Correct ? [Y/N]"
                read CONFIM
                if [ "$CONFIM" == "Y" ] ; then
                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                else
                echo "You have entereted an invalid option"
                exit
                fi
                elif [ "$CONFIM" == "y" ] ; then
                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                else
                echo "You have entereted an invalid option"
                exit
                fi
                else
                echo "Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        }

        WIESAN()
        {
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN DNS Entry are you planning to enter[0-9]"
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify DNS"
                echo "Enter the DNS address"
                read FIRSTSAN
                echo -n $FIRSTSAN"," >> .tmp_san.txt
                done
                else
                echo "Wrong Value Entered - Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN EMAIL Entry are you planning to enter[0-9]"
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify EMAIL eg:onlineinstructions@gmail.com"
                echo "Enter the Email address"
                read FIRSTSAN
                echo -n $FIRSTSAN"," >> .tmp_sane.txt
                done
                echo "All The Values You Have Given Is Correct ? [Y/N]"
                read CONFIM
                if [ "$CONFIM" == "Y" ] ; then
                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                else
                echo "Wrong Value Entered - Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                elif [ "$CONFIM" == "y" ] ; then
                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXETWOSAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXETWOSAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXETWOSAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXETWOSAN
                else
                echo "You have entereted an invalid option"
                exit
                fi
                else
                echo "Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        }

WOSAN()
        {
                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXENOSAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXENOSAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXENOSAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXENOSAN
                else
                echo "You have entereted an invalid option"
                exit
                fi


        }

	if [ "$SANNAME" == "SAN" ] ; then
                 echo "Only SAN Name is selected"
                 WISAN
        elif [ "$SANNAME" == "san" ] ; then
                echo "SAN + EMAIL Name is Selected"
                WISAN
        elif [ "$SANNAME" == "SAN+EMAIL" ] ; then
                echo "SAN + EMAIL Name is Selected"
                WIESAN
        elif [ "$SANNAME" == "san+email" ] ; then
                echo "SAN + EMAIL Name is Selected"
                WIESAN
        else
                echo "SAN Name is not needed"
                WOSAN
        fi
}

SELFJKS()
{
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Your about to create a JKS File, this will create a new .jks file in the  $PATH_VALUE and .csr file, please enter CTRL+C to cancel this operation"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
        echo "Enter the FILE NAME [filename] IF YOU HAVE GIVEN WITH EXTENSION CTRL+C AND RESTART THE SCRIPT:"
        read FNAME
        echo "Enter the alias Name:"
        read ANAME
        echo "Enter the password for the alias NOTE: PASSWORD MUST BE 6+ LETTERS AND SHOULD BE COMPLEX:"
        read APASSWD
        echo "Enter the Common Name (CN):"
        read CNAME
        echo "Enter the Organisation Unit (OU):"
        read OUNAME
        echo "Enter the Organisation Name (O):"
        read ONAME
        echo "Enter the Location (L):"
        read LONAME
        echo "Enter the State Name (ST):"
        read STNAME
        echo "Enter the Country (C):"
        read CONAME
	echo "Enter the EMAIL ID: (MANDATORY: Team Email / App Email)"
        read EMAILID
	echo "Expire Date: (MANDATORY: Number of Days (365)"
        read EXPIRE
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
        echo "Would you like to provide SAN Names for this certificate (Y/N):"
        read SANNAME
        EXEONESAN()
        {
                $LCMD -genkey -keystore /$PATH_VALUE/$FNAME.jks -storepass $APASSWD -keypass $APASSWD -keysize $KEYSIZE -keyalg $KEYALG -sigalg $SIGNALG -alias $ANAME -dname "CN=$CNAME,EMAILADDRESS=$EMAILID,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME" -ext "SAN=`cat .tmp_san.txt`" -validity $EXPIRE
                rm .tmp_san.txt
                if [ $? -eq 1 ] ; then
                                      echo
                        echo "The Keytool Command execution failed. Check if the /$PATH_VALUE/$FNAME.jks file already exits or if keytool command works fine"
                        exit
                fi
                echo
                echo "Your CSR file is named as $ANAME.csr"
                echo "Your keystore is created view your keystore by typing: "keytool -list -v -keystore /$PATH_VALUE/$FNAME.jks -storepass $APASSWD""
        }
        EXENOSAN()
        {
                $LCMD -genkey -keystore /$PATH_VALUE/$FNAME.jks -storepass $APASSWD -keypass $APASSWD -keysize $KEYSIZE -keyalg $KEYALG -sigalg $SIGNALG -alias $ANAME -dname "CN=$CNAME,EMAILADDRESS=$EMAILID,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME" -validity $EXPIRE
                if [ $? -eq 1 ] ; then
                        echo "The Keytool Command execution failed. Check if the /$PATH_VALUE/$FNAME.jks file already exits or if keytool command works fine"
                        exit
                fi
                echo
                echo "Your CSR file is named as $ANAME.csr"
                echo "Your keystore details: "keytool -list -v -keystore /$PATH_VALUE/$FNAME.jks -storepass $APASSWD""
        }
        WISAN()
        {
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN DNS Entry are you planning to enter [0-9] "
                echo "Please only specify DNS Address NOTE: DONT MENTION[:]"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify DNS"
                echo "Enter the DNS address"
                read FIRSTSAN
                echo -n "dns:"$FIRSTSAN"," >> .tmp_san.txt
                done
                echo "All The Values You Have Given Is Correct ? [Y/N]"
                read CONFIM
                if [ "$CONFIM" == "Y" ] ; then
                echo "Executing The Logic To Create Your Certificate"
                EXEONESAN
                elif [ "$CONFIM" == "y" ] ; then
                echo "Executing The Logic To Create Your Certificate"
                EXEONESAN
                else
                echo "Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        }
        WOSAN()
        {
                EXENOSAN

        }
        if [ "$SANNAME" == "Y" ] ; then
                echo "SAN Name is needed"
                WISAN
        elif [ "$SANNAME" == "y" ] ; then
                echo "SAN Name is needed y"
                WISAN
        else
                echo "SAN Name is not needed"
                WOSAN
        fi

}

SELFOPN()
{
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Your about to create a key File, this will create a new .key file in the  $PATH_VALUE and .crt file, please enter CTRL+C to cancel this operation"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
        echo "Enter the FILE NAME - NOTE: NO NEED TO SPECIFY THE .key EXTENSION IF YOU HAVE GIVEN THE SAME GIVE A CTRL+C AND RESTART THE SCRIPT:"
        read FNAME
        echo "Enter the password -  NOTE: PASSWORD MUST BE 6+ LETTERS AND SHOULD BE COMPLEX:"
        read APASSWD
	echo "Enter the Common Name (CN): (MANDATORY)"
        read CNAME
        echo "Enter the Organisation Unit (OU): (MANDATORY)"
        read OUNAME
        echo "Enter the Organisation Name (O): (MANDATORY)"
        read ONAME
        echo "Enter the Location (L): (MANDATORY)"
        read LONAME
        echo "Enter the State Name (ST): (MANDATORY)"
        read STNAME
        echo "Enter the Country (C) - (MANDATORY: MAKE SURE ITS TWO CHARECTERS [GB]):"
        read CONAME
        echo "Enter the Eamil ID: (MANDATORY: You Team Email ID/ App Email ID)"
        read EMAILID
	echo "Expire Days: (MANDATORY: Please mention the number of days (365))"
        read EXPIRE
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
        echo "Would you like to provide SAN+IP Names for this certificate (Y/N):"
        read SANNAME
        EXEONESAN()
        {
                $OPNCMD req -x509 -new -days $EXPIRE -out /$PATH_VALUE/$FNAME.crt -keyout $FNAME.key -passout pass:"$APASSWD" -config .tmp_san1.txt -extensions req_ext
                if [ $? -eq 1 ] ; then
                                      echo
                        echo "The Key Command execution failed. Check if the /$PATH_VALUE/$FNAME.key file already exits or if key command works fine"
                fi
                echo
                echo "Your certificate is created view by typing: openssl x509 -in /$PATH_VALUE/$FNAME.crt -noout -text"
                #rm .tmp_san.txt .tmp_san1.txt
        }
        EXENOSAN()
        {
                $OPNCMD req -x509 -new -days $EXPIRE -keyout /$PATH_VALUE/$FNAME.key -out $FNAME.crt -$OPNALG -newkey rsa:$KEYSIZE -passout pass:"$APASSWD" -subj "/CN=$CNAME,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME"
                if [ $? -eq 1 ] ; then
                                      echo
                        echo "The Key Command execution failed. Check if the /$PATH_VALUE/$FNAME.key file already exits or if key command works fine"
                fi
                echo
                echo "Your Certficate is created view your keystore by typing: openssl x509 -in /$PATH_VALUE/$FNAME.crt -noout -text"
        }
        WISAN()
        {
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN DNS Entry are you planning to enter [0-9]:"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                echo "FQDN = "$CNAME >> .tmp_san.txt
                echo "[req]" >> .tmp_san.txt
                echo "default_bits = " $KEYSIZE >> .tmp_san.txt
                echo "default_md = "$OPNALG  >> .tmp_san.txt
                echo "prompt = no " >> .tmp_san.txt
                echo "distinguished_name = dn" >> .tmp_san.txt
                echo "req_extensions = req_ext" >> .tmp_san.txt
                echo "[ dn ]" >> .tmp_san.txt
                echo "emailAddress=" $EMAILID >> .tmp_san.txt
                echo "C = " $CONAME >> .tmp_san.txt
                echo "ST = " $STNAME >> .tmp_san.txt
                echo "L = " $LONAME >> .tmp_san.txt
                echo "O = " $ONAME >> .tmp_san.txt
                echo "OU = " $OUNAME >> .tmp_san.txt
                echo "CN = " $CNAME >> .tmp_san.txt
                echo "" >> .tmp_san.txt
                echo "[ req_ext ]" >> .tmp_san.txt
                echo "keyUsage = nonRepudiation, digitalSignature, keyEncipherment" >> .tmp_san.txt
                echo "extendedKeyUsage = serverAuth" >> .tmp_san.txt
                echo -n "subjectAltName = " >> .tmp_san.txt
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify DNS"
                echo "Enter the DNS address"
                read FIRSTSAN
                echo -n "DNS:"$FIRSTSAN"," >> .tmp_san.txt
                done
                echo
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "No. of. IP Entry [0-9] Select 0 if you have no IP address:"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read IAMT
                i=0
                while [ $i -lt $IAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify IP address eg:127.50.50.50"
                read FIRSTSAN
                echo -n "IP:"$FIRSTSAN"," >> .tmp_san.txt
                done
                echo
                sed '$ s/.$//' .tmp_san.txt > .tmp_san1.txt
                echo "All The Values You Have Given Is Correct ? [Y/N]"
                read CONFIM
                if [ "$CONFIM" == "Y" ] ; then
                echo "Executing The Logic To Create Your Certificate"
                EXEONESAN
                elif [ "$CONFIM" == "y" ] ; then
                echo "Executing The Logic To Create Your Certificate"
                EXEONESAN
                else
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "This Means You Have Made Some Mistake In The Variables, Which Can Be edited In The File .tmp_san.txt, You Can Find In The Same Folder.(It is a hidden file). Once Modified the file and use the option 12 to execte the modified variable"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                fi
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        }
        WOSAN()
        {
                EXENOSAN
        }
        if [ "$SANNAME" == "Y" ] ; then
                echo "SAN Name is needed"
                WISAN
        elif [ "$SANNAME" == "y" ] ; then
                echo "SAN Name is needed y"
                WISAN
        else
                echo "SAN Name is not needed"
                WOSAN
        fi
}

if [ "$OPTION" == "1" ] ; then
        SELFKDBP12
fi

if [ "$OPTION" == "2" ] ; then
        SELFJKS
fi

if [ "$OPTION" == "3" ] ; then
        SELFOPN
fi
}
CREATEKDB()
{
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Your about to create a KDB/P12 File, this will create a new .kdb file in the  $PATH_VALUE and .csr file, please enter CTRL+C to cancel this operation"
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
        echo "Enter the FILE NAME [filename] IF YOU HAVE GIVEN WITH EXTENSION CTRL+C AND RESTART THE SCRIPT:"
        read FNAME
        echo "Enter the LABEL Name:"
        read ANAME
        echo "Enter the password for the LABEL NOTE: PASSWORD MUST BE 6+ LETTERS AND SHOULD BE COMPLEX:"
        read APASSWD
        echo "Enter the Common Name (CN):"
        read CNAME
        echo "Enter the Organisation Unit (OU):"
        read OUNAME
        echo "Enter the Organisation Name (O):"
        read ONAME
        echo "Enter the Location (L):"
        read LONAME
        echo "Enter the State Name (ST):"
        read STNAME
        echo "Enter the Country (C):"
        read CONAME
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
        echo "Enter Your Choice [SAN / SAN+EMAIL / NO] Note: Its Mandatory that CN should be given as the SAN NAME"
        read SANNAME
        EXEONESAN()
        {
                $GSKCMD -keydb -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -stash -type $TYPE
                $GSKCMD -certreq -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -size $KEYSIZE -type $TYPE -sig_alg $SIGNALG -label $ANAME -dn "CN=$CNAME,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME" -san_dnsname "`cat .tmp_san.txt`" -file $ANAME.csr
                if [ $? -eq 1 ] ; then
                        echo
                        echo "The GSK Command execution failed. Check if the /$PATH_VALUE/$FNAME.kdb file already exits or check if $GSKCMD command works fine"
                fi
                echo
                echo "Your CSR file is named as $ANAME.csr"
                echo "Your keystore details: "$GSKCMD -certreq -details -label $ANAME -db /$PATH_VALUE/$FNAME.$TYPE -stashed""
                rm .tmp_san.txt
        }
        EXETWOSAN()
        {
                $GSKCMD -keydb -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -stash -type $TYPE
                $GSKCMD -certreq -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -size $KEYSIZE -type $TYPE -sig_alg $SIGNALG -label $ANAME -dn "CN=$CNAME,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME" -san_dnsname "`cat .tmp_san.txt`" -san_emailaddr "`cat .tmp_sane.txt`" -file $ANAME.csr
                if [ $? -eq 1 ] ; then
                        echo
                        echo "The GSK Command execution failed. Check if the /$PATH_VALUE/$FNAME.kdb file already exits or check if $GSKCMD command works fine"
                fi
                echo
                echo "Your CSR file is named as $ANAME.csr"
                echo "Your keystore details: "$GSKCMD -certreq -details -label $ANAME -db /$PATH_VALUE/$FNAME.$TYPE -stashed""
                rm .tmp_san.txt
                rm .tmp_sane.txt
        }
        EXENOSAN()
        {
                $GSKCMD -keydb -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -stash -type $TYPE
                $GSKCMD -certreq -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -size $KEYSIZE -type $TYPE -sig_alg $SIGNALG -label $ANAME -dn "CN=$CNAME,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME" -file $ANAME.csr
                if [ $? -eq 1 ] ; then
                        echo
                        echo "The GSK Command execution failed. Check if the /$PATH_VALUE/$FNAME.kdb file already exits or check if $GSKCMD command works fine"
                fi
                echo
                echo "Your CSR file is named as $ANAME.csr"
                echo "Your keystore details can be found here: "$GSKCMD -certreq -details -label $ANAME -db /$PATH_VALUE/$FNAME.$TYPE -stashed""
        }
        WISAN()
        {
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN DNS Entry are you planning to enter[0-9]"
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify DNS"
                echo "Enter the DNS address"
                read FIRSTSAN
                echo -n $FIRSTSAN"," >> .tmp_san.txt
                done
                echo "All The Values You Have Given Is Correct ? [Y/N]"
                read CONFIM
                if [ "$CONFIM" == "Y" ] ; then
                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                else
                echo "You have entereted an invalid option"
                exit
                fi
                elif [ "$CONFIM" == "y" ] ; then
                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                else
                echo "You have entereted an invalid option"
                exit
                fi
                else
                echo "Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        }
        WIESAN()
        {
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN DNS Entry are you planning to enter[0-9]"
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify DNS"
                echo "Enter the DNS address"
                read FIRSTSAN
                echo -n $FIRSTSAN"," >> .tmp_san.txt
                done
                else
                echo "Wrong Value Entered - Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN EMAIL Entry are you planning to enter[0-9]"
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify EMAIL eg:onlineinstructions@gmail.com"
                echo "Enter the Email address"
                read FIRSTSAN
                echo -n $FIRSTSAN"," >> .tmp_sane.txt
                done
                echo "All The Values You Have Given Is Correct ? [Y/N]"
                read CONFIM
                if [ "$CONFIM" == "Y" ] ; then
                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                else
                echo "Wrong Value Entered - Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                elif [ "$CONFIM" == "y" ] ; then
                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXETWOSAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXETWOSAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXETWOSAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXETWOSAN
                else
                echo "You have entereted an invalid option"
                exit
                fi
                else
                echo "Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        }
        WOSAN()
        {
                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXENOSAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXENOSAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXENOSAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXENOSAN
                else
                echo "You have entereted an invalid option"
                exit
                fi


        }
        if [ "$SANNAME" == "SAN" ] ; then
                echo "Only SAN Name is selected"
                WISAN
        #Fourth Change 2.1
        elif [ "$SANNAME" == "san" ] ; then
                echo "SAN + EMAIL Name is Selected"
                WISAN
        elif [ "$SANNAME" == "SAN+EMAIL" ] ; then
                echo "SAN + EMAIL Name is Selected"
                WIESAN
        elif [ "$SANNAME" == "san+email" ] ; then
                echo "SAN + EMAIL Name is Selected"
                WIESAN
        else
                echo "SAN Name is not needed"
                WOSAN
        fi
}
CREATEJKS()
{
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Your about to create a JKS File, this will create a new .jks file in the  $PATH_VALUE and .csr file, please enter CTRL+C to cancel this operation"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
        echo "Enter the FILE NAME [filename] IF YOU HAVE GIVEN WITH EXTENSION CTRL+C AND RESTART THE SCRIPT:"
        read FNAME
        echo "Enter the alias Name:"
        read ANAME
        echo "Enter the password for the alias NOTE: PASSWORD MUST BE 6+ LETTERS AND SHOULD BE COMPLEX:"
        read APASSWD
        echo "Enter the Common Name (CN):"
        read CNAME
        echo "Enter the Organisation Unit (OU):"
        read OUNAME
        echo "Enter the Organisation Name (O):"
        read ONAME
        echo "Enter the Location (L):"
        read LONAME
        echo "Enter the State Name (ST):"
        read STNAME
        echo "Enter the Country (C):"
        read CONAME
        echo "Enter the EMAIL ID: (MANDATORY: Team Email / App Email"
        read EMAILID
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
        echo "Would you like to provide SAN Names for this certificate (Y/N):"
        read SANNAME
        EXEONESAN()
        {
                $LCMD -genkey -keystore /$PATH_VALUE/$FNAME.jks -storepass $APASSWD -keypass $APASSWD -keysize $KEYSIZE -keyalg $KEYALG -sigalg $SIGNALG -alias $ANAME -dname "CN=$CNAME,EMAILADDRESS=$EMAILID,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME" -ext "SAN=`cat .tmp_san.txt`"
                $LCMD -certreq -alias $ANAME -storepass $APASSWD -keystore /$PATH_VALUE/$FNAME.jks -ext "SAN=`cat .tmp_san.txt`" -file $ANAME.csr
                rm .tmp_san.txt
                if [ $? -eq 1 ] ; then
                                      echo
                        echo "The Keytool Command execution failed. Check if the /$PATH_VALUE/$FNAME.jks file already exits or if keytool command works fine"
                        exit
                fi
                echo
                echo "Your CSR file is named as $ANAME.csr"
                echo "Your keystore is created view your keystore by typing: "keytool -list -v -keystore $PATH_VALUE/$FNAME.jks -storepass $APASSWD""
        }
        EXENOSAN()
        {
                $LCMD -genkey -keystore /$PATH_VALUE/$FNAME.jks -storepass $APASSWD -keypass $APASSWD -keysize $KEYSIZE -keyalg $KEYALG -sigalg $SIGNALG -alias $ANAME -dname "CN=$CNAME,EMAILADDRESS=$EMAILID,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME"
                $LCMD -certreq -alias $ANAME -storepass $APASSWD -keystore /$PATH_VALUE/$FNAME.jks -file $ANAME.csr
                if [ $? -eq 1 ] ; then
                        echo "The Keytool Command execution failed. Check if the /$PATH_VALUE/$FNAME.jks file already exits or if keytool command works fine"
                        exit
                fi
                echo
                echo "Your CSR file is named as $ANAME.csr"
                echo "Your keystore details: "keytool -list -v -keystore $PATH_VALUE/$FNAME.jks -storepass $APASSWD""
        }
        WISAN()
        {
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN DNS Entry are you planning to enter [0-9] "
                echo "Please only specify DNS Address NOTE: DONT MENTION[:]"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify DNS"
                echo "Enter the DNS address"
                read FIRSTSAN
                echo -n "dns:"$FIRSTSAN"," >> .tmp_san.txt
                done
                echo "All The Values You Have Given Is Correct ? [Y/N]"
                read CONFIM
                if [ "$CONFIM" == "Y" ] ; then
                echo "Executing The Logic To Create Your Certificate"
                EXEONESAN
                elif [ "$CONFIM" == "y" ] ; then
                echo "Executing The Logic To Create Your Certificate"
                EXEONESAN
                else
                echo "Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        }
        WOSAN()
        {
                EXENOSAN

        }
        if [ "$SANNAME" == "Y" ] ; then
                echo "SAN Name is needed"
                WISAN
        elif [ "$SANNAME" == "y" ] ; then
                echo "SAN Name is needed y"
                WISAN
        else
                echo "SAN Name is not needed"
                WOSAN
        fi
}
RECIEVEKDB()
{
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "                                                Add/Receive Certificate Menu For KDB"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "1: Signer Certificate (Root/Intermedate)"
        echo "2: Personal Certificate (certificate file from CA)"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Enter Your Option:"
        read OPTION
        echo "Please Enter The DB File Name (Including Extension .kdb):"
        read DBNAME
        echo "Please Enter The Password:"
        read DBPASSWD
        echo
        if [ "$OPTION" == 1 ] ; then
                echo "How Many Signer Certificates You Want To Add To The DB:"
                read CNUM
                if [[ $CNUM =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $CNUM ]
                do
                i=`expr $i + 1`
                echo "Enter The Name Of The Signer Certificate File eg; Root/Inter (Including Extension .pem/crt)"
                read CERTNAME
                echo "Enter The Label Name Where The Signer Certificate Will Be Used To Call Itself"
                read LBLNAME
                $GSKCMD -cert -add -db $DBNAME -pw $DBPASSWD -label $LBLNAME -file $CERTNAME
                echo "Added The Certificate"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                done
                sh SSL_AUTO.sh && exit
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        elif [ "$OPTION" == 2 ] ; then
                echo "How Many Personal Certificates You Want To Add To The DB:"
                read CNUM
                if [[ $CNUM =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $CNUM ]
                do
                i=`expr $i + 1`
                echo "Enter The Name Of The Personal Certificate eg; File From The CA (Including Extension)"
                read CERTNAME
                $GSKCMD -cert -receive -db $DBNAME -pw $DBPASSWD -file $CERTNAME
                echo "Added The Certificate"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                done
                sh SSL_AUTO.sh && exit
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        fi
}
RECIEVEJKS()
{
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=="
        echo "                                                Add/Receive Certificate Menu For JKS"
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=="
        echo "1: Signer Certificate (Root/Intermedate)"
        echo "2: Personal Certificate (certificate file from CA)"
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=="
        echo "Please Enter Your Option:"
        read OPTION
        echo "Please Enter The Keystore File Name (Including Extension .jks):"
        read KEYNAME
        echo "Please Enter The Password:"
        read KEYPASSWD
        echo
        if [ "$OPTION" == 1 ] ; then
                echo "How Many Signer Certificates You Want To Add To The Keystore:"
                read CNUM
                if [[ $CNUM =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $CNUM ]
                do
                i=`expr $i + 1`
                echo "Enter The Name Of The Signer Certificate File eg; Root/Inter (Including Extension .pem/crt)"
                read CERTNAME
                echo "Enter The Alias Name Where The Signer Certificate Will Be Used To Call Itself"
                read ANAME
                $LCMD -importcert  -keystore $KEYNAME -storepass $KEYPASSWD -alias $ANAME -file $CERTNAME
                echo "Added The Certificate"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                done
                sh SSL_AUTO.sh && exit
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        elif [ "$OPTION" == 2 ] ; then
                echo "How Many Personal Certificates You Want To Add To The Keystore:"
                read CNUM
                if [[ $CNUM =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $CNUM ]
                do
                i=`expr $i + 1`
                echo "Enter The Name Of The Personal Certificate eg; File From The CA (Including Extension)"
                read CERTNAME
                echo "Enter The Alias Name Which You Used It At The Time Of The Certificate Creation"
                read ANAME
                $LCMD -importcert  -keystore $KEYNAME -storepass $KEYPASSWD -alias $ANAME -file $CERTNAME
                echo "Added The Certificate"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                done
                sh SSL_AUTO.sh && exit
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        fi
}
VERIFYCER()
{
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Your about to Verify The Certificate Using Host Name And Port Number"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Enter The Host Name"
        read HOSTN
        echo "Enter The Port Number"
        read PORTN
        echo -n | $OPNCMD s_client -showcerts -connect $HOSTN:$PORTN > .tmp_san.txt
        awk '/s:/{found=0} {if(found) print} /i:/{found=1}' .tmp_san.txt > .tmp_crt.txt
        $OPNCMD x509 -text -noout -in .tmp_crt.txt
        rm .tmp_san.txt .tmp_crt.txt
}
CREATEOPENSSL()
{
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Your about to create a key File, this will create a new .key file in the  $PATH_VALUE and .csr file, please enter CTRL+C to cancel this operation"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
        echo "Enter the FILE NAME - NOTE: NO NEED TO SPECIFY THE .key EXTENSION IF YOU HAVE GIVEN THE SAME GIVE A CTRL+C AND RESTART THE SCRIPT:"
        read FNAME
        echo "Enter the password -  NOTE: PASSWORD MUST BE 6+ LETTERS AND SHOULD BE COMPLEX:"
        read APASSWD
	echo "Enter the Common Name (CN): (MANDATORY)"
        read CNAME
        echo "Enter the Organisation Unit (OU): (MANDATORY)"
        read OUNAME
        echo "Enter the Organisation Name (O): (MANDATORY)"
        read ONAME
        echo "Enter the Location (L): (MANDATORY)"
        read LONAME
        echo "Enter the State Name (ST): (MANDATORY)"
        read STNAME
        echo "Enter the Country (C) - (MANDATORY: MAKE SURE ITS TWO CHARECTERS [GB]):"
        read CONAME
        echo "Enter the Eamil ID: (MANDATORY: You Team Email ID/ App Email ID)"
        read EMAILID
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
        echo "Would you like to provide SAN+IP Names for this certificate (Y/N):"
        read SANNAME
        EXEONESAN()
        {
                $OPNCMD req -new  -out /$PATH_VALUE/$FNAME.csr -keyout $FNAME.key -passout pass:"$APASSWD" -config .tmp_san1.txt 
                if [ $? -eq 1 ] ; then
                                      echo
                        echo "The Keytool Command execution failed. Check if the /$PATH_VALUE/$FNAME.key file already exits or if keytool command works fine"
                fi
                echo
                echo "Your keystore is created view your keystore by typing: openssl req -text -noout -verify -in /$PATH_VALUE/$FNAME.csr"
                rm .tmp_san.txt .tmp_san1.txt
        }
        EXENOSAN()
        {
                $OPNCMD req -keyout /$PATH_VALUE/$FNAME.key -out $FNAME.csr -$OPNALG -newkey rsa:$KEYSIZE -passout pass:"$APASSWD" -subj "/CN=$CNAME,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME"
                if [ $? -eq 1 ] ; then
                                      echo
                        echo "The Keytool Command execution failed. Check if the /$PATH_VALUE/$FNAME.key file already exits or if keytool command works fine"
                fi
                echo
                echo "Your keystore is created view your keystore by typing: openssl req -text -noout -verify -in /$PATH_VALUE/$FNAME.csr"
        }
        WISAN()
        {
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN DNS Entry are you planning to enter [0-9]:"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                echo "FQDN = "$CNAME >> .tmp_san.txt
                echo "[req]" >> .tmp_san.txt
                echo "default_bits = " $KEYSIZE >> .tmp_san.txt
                echo "default_md = "$OPNALG  >> .tmp_san.txt
                echo "prompt = no " >> .tmp_san.txt
                echo "distinguished_name = dn" >> .tmp_san.txt
                echo "req_extensions = req_ext" >> .tmp_san.txt
                echo "[ dn ]" >> .tmp_san.txt
                echo "emailAddress=" $EMAILID >> .tmp_san.txt
                echo "C = " $CONAME >> .tmp_san.txt
                echo "ST = " $STNAME >> .tmp_san.txt
                echo "L = " $LONAME >> .tmp_san.txt
                echo "O = " $ONAME >> .tmp_san.txt
                echo "OU = " $OUNAME >> .tmp_san.txt
                echo "CN = " $CNAME >> .tmp_san.txt
                echo "" >> .tmp_san.txt
                echo "[ req_ext ]" >> .tmp_san.txt
		echo "keyUsage = nonRepudiation, digitalSignature, keyEncipherment" >> .tmp_san.txt
                echo "extendedKeyUsage = serverAuth" >> .tmp_san.txt
                echo -n "subjectAltName = " >> .tmp_san.txt
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify DNS"
                echo "Enter the DNS address"
                read FIRSTSAN
                echo -n "DNS:"$FIRSTSAN"," >> .tmp_san.txt
                done
                echo
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "No. of. IP Entry [0-9] Select 0 if you have no IP address:"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read IAMT
                i=0
                while [ $i -lt $IAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify IP address eg:127.50.50.50"
                read FIRSTSAN
                echo -n "IP:"$FIRSTSAN"," >> .tmp_san.txt
                done
                echo
                sed '$ s/.$//' .tmp_san.txt > .tmp_san1.txt
                echo "All The Values You Have Given Is Correct ? [Y/N]"
                read CONFIM
                if [ "$CONFIM" == "Y" ] ; then
                echo "Executing The Logic To Create Your Certificate"
                EXEONESAN
                elif [ "$CONFIM" == "y" ] ; then
                echo "Executing The Logic To Create Your Certificate"
                EXEONESAN
                else
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "This Means You Have Made Some Mistake In The Variables, Which Can Be edited In The File .tmp_san.txt, You Can Find In The Same Folder.(It is a hidden file). Once Modified the file and use the option 12 to execte the modified variable"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                fi
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        }
        WOSAN()
        {
                EXENOSAN
        }
        if [ "$SANNAME" == "Y" ] ; then
                echo "SAN Name is needed"
                WISAN
        elif [ "$SANNAME" == "y" ] ; then
                echo "SAN Name is needed y"
                WISAN
        else
                echo "SAN Name is not needed"
                WOSAN
        fi
}
CREATEWALLET()
{
        CONWAL()
        {
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "Enter The Location Of The orakpi Command Location (/u01/Oracle/Middleware/oracle_common/bin/)"
                read ORAPKIPATH
                echo "Enter The Name Of the .jks (WITH EXTENSION), which has been created and signed."
                read FINALJKS
                echo "Enter The JKS Password"
                read PASSJKS
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "Converting to P12"
                $ORAPKIPATH/$ORAPKI wallet create -wallet . -pwd $PASSJKS
                $ORAPKIPATH/$ORAPKI wallet jks_to_pkcs12 -wallet . -keystore $FINALJKS -pwd $PASSJKS -jkspwd $PASSJKS
                $ORAPKIPATH/$ORAPKI wallet create -wallet . -auto_login -pwd $PASSJKS
		echo "To Display the newly created wallet: $ORAPKIPATH/$ORAPKI wallet display -wallet $ -pwd $PASSJKS"
        }
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "To Convert To Wallet, You First Need To Have Created .JKS and CSR, Have that Signed With Root, Inter & Personal Certficate"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Would You Like To Proceed [Y/N]"
        read CONFIM1
                if [ "$CONFIM1" == "Y" ] ; then
                echo "Gather Details For Your Converstion"
                CONWAL
        elif [ "$CONFIM1" == "y" ] ; then
                echo "Gather Details For Your Converstion"
                CONWAL
        else
                echo "Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
        fi
}
MODIFYKDB()
{
ADDKDB()
        {
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Your about to Add a label to a KDB File, this will create a new .kdb file in the  $PATH_VALUE and .csr file, please enter CTRL+C to cancel this operation"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Hold on for 3"
        sleep 1
        echo "Hold on for 2"
        sleep 1
        echo "Please Wait for 1 Sec"
        sleep 1
        echo "Enter the New Alias Name:"
        read ANAME
        echo "Enter the Common Name (CN):"
        read CNAME
        echo "Enter the Organisation Unit (OU):"
        read OUNAME
        echo "Enter the Organisation Name (O):"
        read ONAME
        echo "Enter the Location (L):"
        read LONAME
        echo "Enter the State Name (ST):"
        read STNAME
        echo "Enter the Country (C):"
        read CONAME
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Enter Your Choice [SAN / SAN+EMAIL / NO] Note: Its Mandatory that CN should be given as the SAN NAME"
        read SANNAME
        EXEONESAN()
        {
		$GSKCMD -keydb -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -stash -type $TYPE
                $GSKCMD -certreq -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $KPASSWD -size $KEYSIZE -type $TYPE -sig_alg $SIGNALG -label $ANAME -dn "CN=$CNAME,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME" -san_dnsname "`cat .tmp_san.txt`" -file $ANAME.csr
                if [ $? -eq 1 ] ; then
                        echo
                        echo "The GSK Command execution failed. Check if the /$PATH_VALUE/$FNAME.KDB file already exits or check if $GSKCMD command works fine"
                fi
                echo
                echo "Your keystore is created view your keystore by typing: $GSKCMD -certreq -details -label $ANAME -db /$PATH_VALUE/$FNAME.$TYPE -stashed"
                rm .tmp_san.txt
        }
        EXETWOSAN()
        {
                $GSKCMD -keydb -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -stash -type $TYPE
                $GSKCMD -certreq -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $KPASSWD -size $KEYSIZE -type $TYPE -sig_alg $SIGNALG -label $ANAME -dn "CN=$CNAME,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME" -san_dnsname "`cat .tmp_san.txt`" -san_emailaddr "`cat .tmp_sane.txt`" -file $ANAME.csr
                if [ $? -eq 1 ] ; then
                        echo
                        echo "The GSK Command execution failed. Check if the /$PATH_VALUE/$FNAME.kdb file already exits or check if $GSKCMD command works fine"
                fi
                echo
                echo "Your CSR file is named as $ANAME.csr"
                echo "Your keystore is created view your keystore by typing: $GSKCMD -certreq -details -label $ANAME -db /$PATH_VALUE/$FNAME.$TYPE -stashed"
                rm .tmp_san.txt
                rm .tmp_sane.txt
        }
        EXENOSAN()
        {
		$GSKCMD -keydb -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $APASSWD -stash -type $TYPE
                $GSKCMD -certreq -create -db /$PATH_VALUE/$FNAME.$TYPE -pw $KPASSWD -size $KEYSIZE -type $TYPE -sig_alg $SIGNALG -label $ANAME -dn "CN=$CNAME,OU=$OUNAME,o=$ONAME,L=$LONAME,ST=$STNAME,C=$CONAME" -file $ANAME.csr
                if [ $? -eq 1 ] ; then
                        echo
                        echo "The GSK Command execution failed. Check if the /$PATH_VALUE/$FNAME.jks file already exits or check if $GSKCMD command works fine"
                fi
                echo
                echo "Your keystore is created view your keystore by typing: $GSKCMD -certreq -details -label $ANAME -db /$PATH_VALUE/$FNAME.$TYPE -stashed"
        }
        WISAN()
        {
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN DNS Entry are you planning to enter[0-9]"
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify DNS"
                echo "Enter the DNS address"
                read FIRSTSAN
                echo -n $FIRSTSAN"," >> .tmp_san.txt
                done
                echo "All The Values You Have Given Is Correct ? [Y/N]"
                read CONFIM
                if [ "$CONFIM" == "Y" ] ; then
#                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
#                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                else
                echo "You have entereted an invalid option"
                exit
                fi
                elif [ "$CONFIM" == "y" ] ; then
#               echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
#                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                else
                echo "You have entereted an invalid option"
                exit
                fi
                else
                echo "Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        }
        WIESAN()
        {
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN DNS Entry are you planning to enter[0-9]"
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify DNS"
                echo "Enter the DNS address"
                read FIRSTSAN
                echo -n $FIRSTSAN"," >> .tmp_san.txt
                done
                else
                echo "Wrong Value Entered - Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN EMAIL Entry are you planning to enter[0-9]"
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify EMAIL eg:venkat@mail.com"
                echo "Enter the Email address"
                read FIRSTSAN
                echo -n $FIRSTSAN"," >> .tmp_sane.txt
                done
                echo "All The Values You Have Given Is Correct ? [Y/N]"
                read CONFIM
                if [ "$CONFIM" == "Y" ] ; then
                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXEONESAN
                else
                echo "Wrong Value Entered - Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                elif [ "$CONFIM" == "y" ] ; then
                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXETWOSAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXETWOSAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXETWOSAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXETWOSAN
                else
                echo "You have entereted an invalid option"
                exit
                fi
                else
                echo "Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        }
        WOSAN()
        {
#                echo "Enter Your Prefernece 'KDB or P12' [KDB/P12]"
#                read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXENOSAN
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                EXENOSAN
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXENOSAN
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                EXENOSAN
                else
                echo "You have entereted an invalid option"
                exit
                fi
        }
        if [ "$SANNAME" == "SAN" ] ; then
                echo "Only SAN Name is selected"
                WISAN
        #Fourth Change 2.1
        elif [ "$SANNAME" == "san" ] ; then
                echo "SAN + EMAIL Name is Selected"
                WISAN
        elif [ "$SANNAME" == "SAN+EMAIL" ] ; then
                echo "SAN + EMAIL Name is Selected"
                WIESAN
        elif [ "$SANNAME" == "san+email" ] ; then
                echo "SAN + EMAIL Name is Selected"
                WIESAN
        else
                echo "SAN Name is not needed"
                WOSAN
        fi
        }
        DKDB()
        {
        $GSKCMD -cert -list -db /$PATH_VALUE/$FNAME.$TYPE -type $TYPE -pw $KPASSWD |grep '-' |grep -v personal > .tmp_ssl.txt
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "These are the Personal Keys available"
        cat .tmp_ssl.txt
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please choose ONE from the exisitng Keys [keyname]"
        read KCHOICE
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "*********THE SCRIPT IS ABOUT TO REMOVE THE ALIAS FROM THIS CERTIFICATE. PLEASE PRESS CTRL+C TO CANCEL THIS OPERATION. YOU HAVE 4 SECONDS***********"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        sleep 4
        $GSKCMD -cert -delete -db /$PATH_VALUE/$FNAME.$TYPE -type $TYPE -pw $KPASSWD -label $KCHOICE
        echo "Removed the alias From Your Key. Verify The Current Keys"
        $GSKCMD -cert -list -db /$PATH_VALUE/$FNAME.$TYPE -pw $KPASSWD -type $TYPE|grep '-' |grep -v personal > .tmp_ssl.txt
        cat .tmp_ssl.txt
        sleep 1
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "These are the Personal Keys available"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Would You Like To Add A New Key To This KDB Now [Y/N]"
        rm .tmp_ssl.txt
        read KDBOPTION
                if [ "$KDBOPTION" == "Y" ] ; then
                echo "Gathering Other Details"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=="
                sleep 2;
                ADDKDB
        elif [ "$KDBOPTION" == "y" ] ; then
                echo "Gathering Other Details"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=="
                sleep 2;
                ADDKDB
        else
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        fi
        }
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "    Your About To Modify KDB File, PLEASE TAKE A BACKUP OF THIS KDB FILE BEFORE PROCEEDING. please enter CTRL+C to cancel this operation"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Enter the FILE NAME Wihtout Extension [filename]:"
        read FNAME
        echo "Enter the KDB Password:"
        read KPASSWD
        echo "Enter If THis is A KDB or P12 [p12/kdb]:"
        read KEYCHOICE
                if [ "$KEYCHOICE" == "KDB" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                elif [ "$KEYCHOICE" == "kdb" ] ; then
                TYPE="kdb"
                echo "Executing The Logic To Create Your KDB Certificate WITH SAN"
                elif [ "$KEYCHOICE" == "P12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                elif [ "$KEYCHOICE" == "p12" ] ; then
                TYPE="p12"
                echo "Executing The Logic To Create Your P12 Certificate WITH SAN"
                else
                echo "You have entereted an invalid option"
                exit
                fi
        echo "View The Current Certificate in the KDB"
        $GSKCMD -cert -list -db /$PATH_VALUE/$FNAME.$TYPE -type $TYPE -pw $KPASSWD |grep '-' |grep -v personal > .tmp_ssl.txt
        cat .tmp_ssl.txt
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Are You here to remove a label from the KDB (Y/N):"
        read LNAME
                if [ "$LNAME" == "Y" ] ; then
                echo "Gather Details For The Key Removal"
                DKDB
        elif [ "$LNAME" == "y" ] ; then
                echo "Gather Details For The Key Removal"
                DKDB
        else
                echo "Add A New Certificate to your Keystore"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                rm .tmp_ssl.txt
                sleep 2;
                ADDKDB
        fi
}
DECRYPTSTH()
{
echo "Enter The Name of the Stach File WITH EXTENSION [filename.sth]"
read FNAME
echo '#!/usr/bin/perl' >> .tmp_ssl.pl
echo 'use strict;' >> .tmp_ssl.pl
echo 'die "Usage: $0 <stash file>>n" if $#ARGV != 0;'  >> .tmp_ssl.pl
echo 'my $file=$ARGV[0];'  >> .tmp_ssl.pl
echo 'open(F,$file) || die "Cant open $file: $!";' >> .tmp_ssl.pl
echo 'my $stash;' >> .tmp_ssl.pl
echo 'read F,$stash,1024;' >> .tmp_ssl.pl
echo 'my @unstash=map { $_^0xf5 } unpack("C*",$stash);' >> .tmp_ssl.pl
echo 'foreach my $c (@unstash) {' >> .tmp_ssl.pl
echo ' last if $c eq 0;' >> .tmp_ssl.pl
echo ' printf "%c",$c;' >> .tmp_ssl.pl
echo '}' >> .tmp_ssl.pl
echo 'printf ' ";" >> .tmp_ssl.pl
echo
echo "The Password is displayed as below"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
perl .tmp_ssl.pl /$PATH_VALUE/$FNAME
echo
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
echo
rm .tmp_ssl.pl
}
MODIFYJKS()
{
        DJKS()
        {
        echo
        $LCMD -list  -noprompt -keystore /$PATH_VALUE/$FNAME -storepass $JPASSWD |grep "PrivateKeyEntry" > .tmp_ssl.txt
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "These are the Personal Keys available"
        echo
        cat .tmp_ssl.txt
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please choose ONE from the exisitng Keys [keyname]"
        read JCHOICE
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "*********THE SCRIPT IS ABOUT TO REMOVE THE ALIAS FROM THIS CERTIFICATE. PLEASE PRESS CTRL+C TO CANCEL THIS OPERATION. YOU HAVE 4 SECONDS***********"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        sleep 4
        $LCMD -delete -noprompt -keystore /$PATH_VALUE/$FNAME -storepass $JPASSWD -alias $JCHOICE
        echo "Removed the alias From Your Key. Verify The Current alias"
        $LCMD -list  -noprompt -keystore /$PATH_VALUE/$FNAME -storepass $JPASSWD |grep "PrivateKeyEntry" > .tmp_ssl.txt
        cat .tmp_ssl.txt
        sleep 1
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "These are the Personal Keys available"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Would you like to create a New JKS Now [Y/N]"
        rm .tmp_ssl.txt
        read KDBOPTION
                if [ "$KDBOPTION" == "Y" ] ; then
                echo "Redirecting To Main Menu SELECT OPTION [2]"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh 2 && exit
        elif [ "$KDBOPTION" == "y" ] ; then
                echo "Redirecting To Main Menu SELECT OPTION [2]"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                sh SSL_AUTO.sh 2 && exit
        else
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        fi
        }
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "    Your About To Modify JKS File, PLEASE TAKE A BACKUP OF THIS JKS FILE BEFORE PROCEEDING. please enter CTRL+C to cancel this operation"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Enter the FILE NAME [filename]:"
        read FNAME
        echo "Enter the JKS Password:"
        read JPASSWD
        echo
        echo "View The Current Certificate in the jks"
        $LCMD -list  -noprompt -keystore /$PATH_VALUE/$FNAME.jks -storepass $JPASSWD |grep "PrivateKeyEntry" > .tmp_ssl.txt
        cat .tmp_ssl.txt
        echo
        echo "Are you hear to remove a key from the keystore (Y/N):"
        read LNAME
                if [ "$LNAME" == "Y" ] ; then
                echo "Gather Details For The Key Removal"
                DJKS
        elif [ "$LNAME" == "y" ] ; then
                echo "Gather Details For The Key Removal"
                DJKS
        else
                echo "Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                rm .tmp_ssl.txt
                sleep 2;
                sh SSL_AUTO.sh && exit
        fi
}
VERIFYCERTS()
{
        ADDKDB()
        {
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
        #echo "Enter the New Key File Name No Extension [filename]:"
        #read FNAME
        echo "Moving the Exisitng /$PATH_VALUE/$FNAME to $FNAME.$TYPE_$NOW"
        mv /$PATH_VALUE/$FNAME $FNAME.$TYPE_$NOW
        ANAME=$JCHOICE
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        #echo "Would you like to provide SAN Names for this certificate (Y/N):"
        #read SANNAME
        #EXEONESAN()
        #{
        if [ -s .tmp_ssl3.txt ]; then
                echo "Cloning with San"
                $GSKCMD -keydb -create -db /$PATH_VALUE/$FNAME -pw $JPASSWD -stash -type $TYPE
                $GSKCMD -certreq -create -db /$PATH_VALUE/$FNAME -pw $JPASSWD -size $KEYSIZE -type $TYPE -sig_alg $SIGNALG -label $ANAME -dn "`cat .tmp_ssl2.txt`" -san_dnsname "`cat .tmp_ssl3.txt`" -file $ANAME.csr
        else
                echo "Cloaning without San"
                $GSKCMD -keydb -create -db /$PATH_VALUE/$FNAME -pw $JPASSWD -stash -type $TYPE
                $GSKCMD -certreq -create -db /$PATH_VALUE/$FNAME -pw $JPASSWD -size $KEYSIZE -type $TYPE -sig_alg $SIGNALG -label $ANAME -dn "`cat .tmp_ssl2.txt`" -file $ANAME.csr
fi
                if [ $? -eq 1 ] ; then
                        echo
                        echo "The GSK Command execution failed. Check if the /$PATH_VALUE/$FNAME file already exits or check if $GSKCMD command works fine"
                fi
                echo
                echo "Your CSR file is named as $ANAME.csr"
                echo "Your keystore is created view your keystore by typing: $GSKCMD -cert -details -label $ANAME -db /$PATH_VALUE/$FNAME.$TYPE -pw <PASSWORD>"
                rm .tmp_ssl2.txt
                rm .tmp_ssl3.txt
        #}
        EXENOSAN()
        {
                $GSKCMD -certreq -create -db /$PATH_VALUE/$FNAME -pw $JPASSWD -size $KEYSIZE -type $TYPE -sig_alg $SIGNALG -label $ANAME -dn "`cat .tmp_ssl2.txt`" -file $ANAME.csr
                if [ $? -eq 1 ] ; then
                        echo
                        echo "The GSK Command execution failed. Check if the /$PATH_VALUE/$FNAME file already exits or check if $GSKCMD command works fine"
                fi
                echo
                echo "Your CSR file is named as $ANAME.csr"
                echo "Your keystore is created view your keystore by typing: $GSKCMD -cert -details -label $ANAME -db /$PATH_VALUE/$FNAME -pw <PASSWORD>"
        }
        WISAN()
        {
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                echo "How many number of SAN DNS Entry are you planning to enter[0-9]"
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                read SAMT
                if [[ $SAMT =~ ^-?[0-9]+$ ]] ; then
                i=0
                while [ $i -lt $SAMT ]
                do
                i=`expr $i + 1`
                echo "Note - Please only specify DNS"
                echo "Enter the DNS address"
                read FIRSTSAN
                echo -n $FIRSTSAN"," >> .tmp_san.txt
                done
                echo "All The Values You Have Given Is Correct ? [Y/N]"
                read CONFIM
                if [ "$CONFIM" == "Y" ] ; then
                echo "Executing The Logic To Create Your Certificate"
                EXEONESAN
                elif [ "$CONFIM" == "y" ] ; then
                echo "Executing The Logic To Create Your Certificate"
                EXEONESAN
                else
                echo "Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                sleep 2;
                sh SSL_AUTO.sh && exit
                fi
                else
                        echo "You Have Entered Wrong Value Please Reload The Script"
                        exit 1
                fi
        }
        WOSAN()
        {
                EXENOSAN

        }
        #if [ "$SANNAME" == "Y" ] ; then
        #        echo "SAN Name is needed"
        #        WISAN
        #elif [ "$SANNAME" == "y" ] ; then
        #        echo "SAN Name is needed y"
        #        WISAN
        #else
        #        echo "SAN Name is not needed"
        #        WOSAN
        #fi
        }
        VKDB()
        {
        echo "Enter the Store Password:"
        read JPASSWD
        $GSKCMD -cert -list -db /$PATH_VALUE/$FNAME -type $TYPE -pw $JPASSWD |grep '-' |grep -v personal > .tmp_ssl.txt
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "These are the Personal Keys available"
        echo
        cat .tmp_ssl.txt
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please choose ONE from the exisitng Keys [keyname]"
        read JCHOICE
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++=="
        sleep 1
        echo "Gathering Information"
        $GSKCMD -cert -details -db /$PATH_VALUE/$FNAME -type $TYPE -pw $JPASSWD -label $JCHOICE > .tmp_ssl1.txt
        sleep 1
        echo "++++++++++++++++++++++++++++++++++++=="
        echo "Certificate Details Are Listed Below:"
        echo "++++++++++++++++++++++++++++++++++++=="
        echo "Issuer Details"
        cat .tmp_ssl1.txt |sed -n '6p' |cut -c11- > .tmp_ssl2.txt
        echo `cat .tmp_ssl2.txt`
        echo "++++++++++++=="
        echo "DNS SAN NAMES"
        echo "++++++++++++=="
        echo -n `cat .tmp_ssl1.txt |grep dNSName` > .tmp_ssl3.txt
        echo `cat .tmp_ssl1.txt |grep dNSName`
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        rm .tmp_ssl.txt
        rm .tmp_ssl1.txt
        #NEED TO SHIFT THIS
        #rm .tmp_ssl2.txt
        #rm .tmp_ssl3.txt
        #rm .tmp_ssl4.txt
        echo "Would you like to recreate the same $TYPE To A Differnt Store [Y/N]"
        read KDBOPTION
                if [ "$KDBOPTION" == "Y" ] ; then
                echo "Gathering Other Details"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=="
                sleep 2;
                ADDKDB
        elif [ "$KDBOPTION" == "y" ] ; then
                echo "Gathering Other Details"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=="
                sleep 2;
                ADDKDB
        else
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sh SSL_AUTO.sh 2 && exit
        fi
        }
        ADDJKS()
        {
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please Wait for 1 Sec"
        sleep 1
#        echo "Enter the FILE NAME [filename] IF YOU HAVE GIVEN WITH EXTENSION CTRL+C AND RESTART THE SCRIPT:"
#        read FNAME
        echo "Moving the Exisitng /$PATH_VALUE/$FNAME to $FNAME.$TYPE_$NOW"
        mv /$PATH_VALUE/$FNAME $FNAME.$TYPE_$NOW
        echo "Enter the password for the alias NOTE: PASSWORD MUST BE 6+ LETTERS AND SHOULD BE COMPLEX:"
        read APASSWD
        ANAME=$JCHOICE
        if [ -s .tmp_ssl3.txt ]; then
                echo "Cloning With San"
                $LCMD -genkey -keystore /$PATH_VALUE/$FNAME -storepass $APASSWD -keypass $APASSWD -keysize $KEYSIZE -keyalg $KEYALG -sigalg $SIGNALG -alias $ANAME -dname "`cat .tmp_ssl2.txt`" -ext "SAN='`cat .tmp_ssl3.txt`'"
                $LCMD -certreq -alias $ANAME -storepass $APASSWD -keystore /$PATH_VALUE/$FNAME -ext "SAN=`cat .tmp_ssl3.txt`" -file $ANAME.csr
        else
                echo "Cloning Without San"
                $LCMD -genkey -keystore /$PATH_VALUE/$FNAME -storepass $APASSWD -keypass $APASSWD -keysize $KEYSIZE -keyalg $KEYALG -sigalg $SIGNALG -alias $ANAME -dname "`cat .tmp_ssl2.txt`"
                $LCMD -certreq -alias $ANAME -storepass $APASSWD -keystore /$PATH_VALUE/$FNAME -file $ANAME.csr
        fi
        }
        VJKS()
        {
        JPASSWD=""
        echo
        echo $JPASSWD|$LCMD -list  -noprompt -keystore /$PATH_VALUE/$FNAME |grep "PrivateKeyEntry" > .tmp_ssl.txt
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "These are the Personal Keys available"
        echo
        cat .tmp_ssl.txt
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Please choose ONE from the exisitng Keys [keyname]"
        read JCHOICE
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++=="
        sleep 1
        echo "Gathering Information"
        echo $JPASSWD|$LCMD -list -v -noprompt -keystore /$PATH_VALUE/$FNAME -alias $JCHOICE > .tmp_ssl1.txt
        sleep 1
        echo "++++++++++++++++++++++++++++++++++++=="
        echo "Certificate Details Are Listed Below:"
        echo "++++++++++++++++++++++++++++++++++++=="
        echo "Issuer Details"
        cat .tmp_ssl1.txt |sed -n '6p' |cut -c8- > .tmp_ssl2.txt
        echo `cat .tmp_ssl2.txt`
        echo "++++++++++++=="
        echo "DNS SAN NAMES"
        echo "++++++++++++=="
        echo -n `cat .tmp_ssl1.txt |grep DNSName` > .tmp_ssl3.txt
        echo `cat .tmp_ssl1.txt |grep DNSName`
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++="
        rm .tmp_ssl.txt
        rm .tmp_ssl1.txt
        echo "Would You Like To Create A New Key And Copy The Same Details [Y/N]"
        read KDBOPTION
                if [ "$KDBOPTION" == "Y" ] ; then
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                ADDJKS
        elif [ "$KDBOPTION" == "y" ] ; then
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                sleep 2;
                ADDJKS
        else
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        fi
        }
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "                                                  Your About To View The Keystore."
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Enter the JKS/KDB FILE NAME [filename.jks/kdb/p12] NOTE: YOU NEED TO GIVE THE FILE NAME WITH EXTENSION:"
        read FNAME
        LNAME=`echo "${FNAME#"${FNAME%???}"}"`
        if [ "$LNAME" == "KDB" ] ; then
                TYPE="kdb"
                echo "Gather Details For The KDB"
                VKDB
        elif [ "$LNAME" == "kdb" ] ; then
                TYPE="kdb"
                echo "Gather Details For The KDB"
                VKDB
        elif [ "$LNAME" == "P12" ] ; then
                TYPE="p12"
                echo "Gather Details For The KDB"
                VKDB
        elif [ "$LNAME" == "p12" ] ; then
                TYPE="p12"
                echo "Gather Details For The KDB"
                VKDB
        elif [ "$LNAME" == "JKS" ] ; then
                echo "Gather Details For The JKS"
                VJKS
        elif [ "$LNAME" == "jks" ] ; then
                echo "Gather Details For The JKS"
                VJKS
        else
                echo "Redirecting To Main Menu"
                echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
                rm .tmp_ssl.txt
                sleep 2;
                sh SSL_AUTO.sh && exit
        fi
}

if [ "$OPTION" == 1 ] ; then
        echo "You have entered Creating New KDB File."
        echo
        CREATEKDB
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
fi

if [ "$OPTION" == 2 ] ; then
        echo "You have entered Creating New JKS File."
        CREATEJKS
        echo
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
fi

if [ "$OPTION" == 3 ] ; then
        echo "You have entered Creating New Openssl File."
        CREATEOPENSSL
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
fi

if [ "$OPTION" == 4 ] ; then
        CONVERTP12
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
fi

if [ "$OPTION" == 5 ] ; then
        CREATEWALLET
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
fi

if [ "$OPTION" == 6 ] ; then
        echo "You have entered Add/Recive a certificate from CA for KDB File."
        RECIEVEKDB
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
fi

if [ "$OPTION" == 7 ] ; then
        echo "You have entered Add/Recive a certificate from CA for JKS File."
        RECIEVEJKS
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
fi

if [ "$OPTION" == "8" ] ; then
        VERIFYCER
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
fi

if [ "$OPTION" == "9" ] ; then
        MODIFYKDB
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
fi

if [ "$OPTION" == "10" ] ; then
        VERIFYCERTS
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
fi

if [ "$OPTION" == "11" ] ; then
        MODIFYJKS
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
fi

if [ "$OPTION" == "12" ] ; then
        DECRYPTSTH
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
fi

if [ "$OPTION" == "13" ] ; then
        SELFSIGNED
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
        echo "Online Instruction is glad to help you create or modify or delete your SSL certficates"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++="
fi
